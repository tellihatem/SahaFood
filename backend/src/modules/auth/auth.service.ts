import { Injectable, UnauthorizedException, BadRequestException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as argon2 from 'argon2';
import * as crypto from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { SendOtpDto, VerifyOtpDto, RefreshTokenDto, RegisterDto, LoginDto, CompleteProfileDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async sendOtp(dto: SendOtpDto) {
    const { phone } = dto;

    // Check rate limiting - max 3 OTPs per 5 minutes
    const recentOtps = await this.prisma.otp.count({
      where: {
        phone,
        created_at: {
          gte: new Date(Date.now() - 5 * 60 * 1000),
        },
      },
    });

    if (recentOtps >= 3) {
      throw new BadRequestException('تم تجاوز الحد الأقصى لطلبات OTP. حاول بعد 5 دقائق');
    }

    // Generate 6-digit OTP
    const otp = crypto.randomInt(100000, 999999).toString();
    const otpHash = await argon2.hash(otp);

    // Store OTP
    await this.prisma.otp.create({
      data: {
        phone,
        otp_hash: otpHash,
        expires_at: new Date(Date.now() + 5 * 60 * 1000), // 5 minutes
      },
    });

    // TODO: Send OTP via SMS/WhatsApp using Infobip
    // For development, log the OTP
    console.log(`[DEV] OTP for ${phone}: ${otp}`);

    return {
      message: 'تم إرسال رمز التحقق',
      expiresIn: 300, // 5 minutes in seconds
    };
  }

  async verifyOtp(dto: VerifyOtpDto) {
    const { phone, otp } = dto;

    // Find valid OTP
    const otpRecord = await this.prisma.otp.findFirst({
      where: {
        phone,
        consumed_at: null,
        expires_at: {
          gte: new Date(),
        },
      },
      orderBy: {
        created_at: 'desc',
      },
    });

    if (!otpRecord) {
      throw new UnauthorizedException('رمز التحقق غير صالح أو منتهي الصلاحية');
    }

    // Check attempts
    if (otpRecord.attempts >= 3) {
      throw new UnauthorizedException('تم تجاوز الحد الأقصى للمحاولات');
    }

    // Verify OTP
    const isValid = await argon2.verify(otpRecord.otp_hash, otp);

    if (!isValid) {
      // Increment attempts
      await this.prisma.otp.update({
        where: { id: otpRecord.id },
        data: { attempts: { increment: 1 } },
      });
      throw new UnauthorizedException('رمز التحقق غير صحيح');
    }

    // Mark OTP as consumed
    await this.prisma.otp.update({
      where: { id: otpRecord.id },
      data: { consumed_at: new Date() },
    });

    // Find or create user
    let user = await this.prisma.user.findUnique({
      where: { phone },
    });

    const isNewUser = !user;

    if (!user) {
      user = await this.prisma.user.create({
        data: {
          phone,
          phone_verified: true,
          role: 'user',
        },
      });
    } else {
      // Update phone_verified if not already
      if (!user.phone_verified) {
        await this.prisma.user.update({
          where: { id: user.id },
          data: { phone_verified: true },
        });
      }
    }

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.role);

    return {
      ...tokens,
      isNewUser,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        role: user.role,
      },
    };
  }

  async refreshToken(dto: RefreshTokenDto) {
    const { refreshToken } = dto;

    // Find valid refresh token
    const tokenRecord = await this.prisma.refreshToken.findFirst({
      where: {
        expires_at: {
          gte: new Date(),
        },
      },
      include: {
        user: true,
      },
    });

    if (!tokenRecord) {
      throw new UnauthorizedException('رمز التحديث غير صالح');
    }

    // Verify token hash
    const isValid = await argon2.verify(tokenRecord.token, refreshToken);
    if (!isValid) {
      throw new UnauthorizedException('رمز التحديث غير صالح');
    }

    // Delete old token
    await this.prisma.refreshToken.delete({
      where: { id: tokenRecord.id },
    });

    // Generate new tokens
    const tokens = await this.generateTokens(tokenRecord.user.id, tokenRecord.user.role);

    return {
      ...tokens,
      user: {
        id: tokenRecord.user.id,
        phone: tokenRecord.user.phone,
        name: tokenRecord.user.name,
        role: tokenRecord.user.role,
      },
    };
  }

  async logout(userId: string, refreshToken?: string) {
    if (refreshToken) {
      // Delete specific token
      const tokens = await this.prisma.refreshToken.findMany({
        where: { user_id: userId },
      });

      for (const token of tokens) {
        const isMatch = await argon2.verify(token.token, refreshToken);
        if (isMatch) {
          await this.prisma.refreshToken.delete({
            where: { id: token.id },
          });
          break;
        }
      }
    } else {
      // Delete all tokens for user
      await this.prisma.refreshToken.deleteMany({
        where: { user_id: userId },
      });
    }

    return { message: 'تم تسجيل الخروج بنجاح' };
  }

  async register(dto: RegisterDto) {
    const { phone, name, password } = dto;

    // Check if user already exists
    const existingUser = await this.prisma.user.findUnique({
      where: { phone },
    });

    if (existingUser) {
      throw new ConflictException('رقم الهاتف مسجل مسبقاً');
    }

    // Hash password if provided
    const passwordHash = password ? await argon2.hash(password) : null;

    // Create user
    const user = await this.prisma.user.create({
      data: {
        phone,
        name,
        password_hash: passwordHash,
        phone_verified: false,
        role: 'user',
      },
    });

    // Send OTP for verification
    await this.sendOtp({ phone });

    return {
      message: 'تم إنشاء الحساب. يرجى التحقق من رقم الهاتف',
      userId: user.id,
      requiresVerification: true,
    };
  }

  async login(dto: LoginDto) {
    const { phone, password } = dto;

    // Find user
    const user = await this.prisma.user.findUnique({
      where: { phone },
    });

    if (!user) {
      throw new UnauthorizedException('رقم الهاتف أو كلمة المرور غير صحيحة');
    }

    // Check if user has password set
    if (!user.password_hash) {
      throw new BadRequestException('هذا الحساب لا يملك كلمة مرور. استخدم تسجيل الدخول بـ OTP');
    }

    // Verify password
    const isValid = await argon2.verify(user.password_hash, password);
    if (!isValid) {
      throw new UnauthorizedException('رقم الهاتف أو كلمة المرور غير صحيحة');
    }

    // Check if phone is verified
    if (!user.phone_verified) {
      // Send OTP for verification
      await this.sendOtp({ phone });
      return {
        message: 'يرجى التحقق من رقم الهاتف أولاً',
        requiresVerification: true,
      };
    }

    // Check if user is deleted
    if (user.deleted_at) {
      throw new UnauthorizedException('هذا الحساب محذوف');
    }

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.role);

    return {
      ...tokens,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        role: user.role,
        profile_image: user.profile_image,
      },
    };
  }

  async completeProfile(userId: string, dto: CompleteProfileDto) {
    const { name, password } = dto;

    // Hash password if provided
    const passwordHash = password ? await argon2.hash(password) : undefined;

    // Update user
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        name,
        ...(passwordHash && { password_hash: passwordHash }),
      },
      select: {
        id: true,
        phone: true,
        name: true,
        role: true,
        profile_image: true,
      },
    });

    return {
      message: 'تم تحديث الملف الشخصي بنجاح',
      user,
    };
  }

  async getMe(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        phone: true,
        name: true,
        gender: true,
        birthdate: true,
        profile_image: true,
        role: true,
        phone_verified: true,
        created_at: true,
      },
    });

    if (!user) {
      throw new UnauthorizedException('المستخدم غير موجود');
    }

    return user;
  }

  private async generateTokens(userId: string, role: string) {
    const payload = { sub: userId, role };

    const accessToken = this.jwtService.sign(payload);

    const refreshToken = crypto.randomBytes(32).toString('hex');
    const refreshTokenHash = await argon2.hash(refreshToken);

    // Store refresh token
    await this.prisma.refreshToken.create({
      data: {
        user_id: userId,
        token: refreshTokenHash,
        expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
      },
    });

    return {
      accessToken,
      refreshToken,
      expiresIn: 900, // 15 minutes in seconds
    };
  }
}

import { IsString, IsNotEmpty, Matches, Length, IsOptional, MinLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class SendOtpDto {
  @ApiProperty({
    description: 'Phone number with country code',
    example: '+213555123456',
  })
  @IsString()
  @IsNotEmpty()
  @Matches(/^\+[1-9]\d{6,14}$/, {
    message: 'رقم الهاتف غير صالح. يجب أن يبدأ بـ + ورمز الدولة',
  })
  phone: string;
}

export class VerifyOtpDto {
  @ApiProperty({
    description: 'Phone number with country code',
    example: '+213555123456',
  })
  @IsString()
  @IsNotEmpty()
  @Matches(/^\+[1-9]\d{6,14}$/, {
    message: 'رقم الهاتف غير صالح',
  })
  phone: string;

  @ApiProperty({
    description: '6-digit OTP code',
    example: '123456',
  })
  @IsString()
  @IsNotEmpty()
  @Length(6, 6, { message: 'رمز التحقق يجب أن يكون 6 أرقام' })
  @Matches(/^\d{6}$/, { message: 'رمز التحقق يجب أن يحتوي على أرقام فقط' })
  otp: string;
}

export class RefreshTokenDto {
  @ApiProperty({
    description: 'Refresh token',
  })
  @IsString()
  @IsNotEmpty()
  refreshToken: string;
}

export class LogoutDto {
  @ApiPropertyOptional({
    description: 'Refresh token to invalidate (optional, if not provided all sessions will be logged out)',
  })
  @IsString()
  @IsOptional()
  refreshToken?: string;
}

export class RegisterDto {
  @ApiProperty({
    description: 'Phone number with country code',
    example: '+213555123456',
  })
  @IsString()
  @IsNotEmpty()
  @Matches(/^\+[1-9]\d{6,14}$/, {
    message: 'رقم الهاتف غير صالح. يجب أن يبدأ بـ + ورمز الدولة',
  })
  phone: string;

  @ApiProperty({
    description: 'User full name',
    example: 'أحمد محمد',
  })
  @IsString()
  @IsNotEmpty({ message: 'الاسم مطلوب' })
  name: string;

  @ApiPropertyOptional({
    description: 'Password (optional, for password-based login)',
    example: 'securePassword123',
  })
  @IsString()
  @MinLength(8, { message: 'كلمة المرور يجب أن تكون 8 أحرف على الأقل' })
  @IsOptional()
  password?: string;
}

export class LoginDto {
  @ApiProperty({
    description: 'Phone number with country code',
    example: '+213555123456',
  })
  @IsString()
  @IsNotEmpty()
  @Matches(/^\+[1-9]\d{6,14}$/, {
    message: 'رقم الهاتف غير صالح',
  })
  phone: string;

  @ApiProperty({
    description: 'User password',
    example: 'securePassword123',
  })
  @IsString()
  @IsNotEmpty({ message: 'كلمة المرور مطلوبة' })
  password: string;
}

export class CompleteProfileDto {
  @ApiProperty({
    description: 'User full name',
    example: 'أحمد محمد',
  })
  @IsString()
  @IsNotEmpty({ message: 'الاسم مطلوب' })
  name: string;

  @ApiPropertyOptional({
    description: 'Password for future logins',
    example: 'securePassword123',
  })
  @IsString()
  @MinLength(8, { message: 'كلمة المرور يجب أن تكون 8 أحرف على الأقل' })
  @IsOptional()
  password?: string;
}

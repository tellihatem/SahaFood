import { IsString, IsOptional, IsDateString, IsIn } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateUserDto {
  @ApiPropertyOptional({ description: 'User name', example: 'أحمد محمد' })
  @IsString()
  @IsOptional()
  name?: string;

  @ApiPropertyOptional({ description: 'Gender', example: 'male', enum: ['male', 'female'] })
  @IsString()
  @IsIn(['male', 'female'], { message: 'الجنس يجب أن يكون ذكر أو أنثى' })
  @IsOptional()
  gender?: string;

  @ApiPropertyOptional({ description: 'Birthdate', example: '1990-01-01' })
  @IsDateString({}, { message: 'تاريخ الميلاد غير صالح' })
  @IsOptional()
  birthdate?: string;

  @ApiPropertyOptional({ description: 'Profile image URL' })
  @IsString()
  @IsOptional()
  profile_image?: string;
}

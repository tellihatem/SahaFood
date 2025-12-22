import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable text widget optimized for Arabic text display
/// Includes proper font fallbacks and RTL support
class ArabicText extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Font size (will be converted to responsive size)
  final double fontSize;
  
  /// Font weight
  final FontWeight fontWeight;
  
  /// Text color
  final Color color;
  
  /// Text alignment
  final TextAlign textAlign;
  
  /// Line height multiplier
  final double? height;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// How text overflow is handled
  final TextOverflow? overflow;
  
  /// Optional custom font family
  final String? fontFamily;

  const ArabicText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
    this.height,
    this.maxLines,
    this.overflow,
    this.fontFamily = 'Tajawal',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        height: height,
        fontFamily: fontFamily,
        fontFamilyFallback: const [
          'Noto Sans Arabic',
          'Arial Unicode MS',
          'Tahoma',
          'Arial',
          'sans-serif',
        ],
        locale: const Locale('ar'),
      ),
    );
  }
}

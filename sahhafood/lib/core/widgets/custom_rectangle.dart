import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRectangle extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Color color;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const CustomRectangle({
    Key? key,
    this.width = 240,
    this.height = 292,
    this.borderRadius = 12,
    this.color = const Color(0xFF98A8B8),
    this.child,
    this.padding,
    this.margin,
    this.border,
    this.boxShadow,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: border,
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: child,
    );
  }

  /// Creates a rectangle with a border
  factory CustomRectangle.withBorder({
    Key? key,
    double? width,
    double? height,
    double borderRadius = 12,
    Color color = Colors.transparent,
    Color borderColor = const Color(0xFF98A8B8),
    double borderWidth = 1.0,
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
  }) {
    return CustomRectangle(
      key: key,
      width: width,
      height: height,
      borderRadius: borderRadius,
      color: color,
      padding: padding,
      margin: margin,
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      boxShadow: boxShadow,
      child: child,
    );
  }

  /// Creates a rectangle with a gradient background
  factory CustomRectangle.gradient({
    Key? key,
    double? width,
    double? height,
    double borderRadius = 12,
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return CustomRectangle(
      key: key,
      width: width,
      height: height,
      borderRadius: borderRadius,
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      padding: padding,
      margin: margin,
      border: border,
      boxShadow: boxShadow,
      child: child,
    );
  }
}

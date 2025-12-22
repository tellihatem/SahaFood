import 'package:flutter/material.dart';

class SliderIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const SliderIndicator({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
    this.activeColor = const Color(0xFFFF7622),
    this.inactiveColor = const Color(0xFFFFE1CE),
    this.dotSize = 10,
    this.spacing = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // Force LTR for the indicator
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          itemCount,
          (index) => Container(
            width: dotSize,
            height: dotSize,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            decoration: BoxDecoration(
              color: index == currentIndex ? activeColor : inactiveColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated favorite button widget
/// Follows architecture rules: reusable, stateful for animation

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  final String itemId;
  final FavoriteType type;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButton({
    super.key,
    required this.itemId,
    required this.type,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    ref.read(favoritesProvider.notifier).toggleFavorite(
          widget.itemId,
          widget.type,
        );
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);
    final isFavorite = favoritesState.isFavorite(widget.itemId);

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size + 16,
              height: widget.size + 16,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: widget.size,
                  color: isFavorite
                      ? (widget.activeColor ?? AppColors.error)
                      : (widget.inactiveColor ?? AppColors.textSecondary),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../theme/salmon_colors.dart';

class SalmonBottomNavbarItem extends StatelessWidget {
  const SalmonBottomNavbarItem({
    this.duration = const Duration(milliseconds: 200),
    required this.child,
    required this.isActive,
    super.key,
  });

  final Duration duration;
  final Widget child;
  final bool isActive;

  static const double _size = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        const SizedBox(height: 6),
        AnimatedSlide(
          duration: duration * 0.8,
          offset: isActive ? const Offset(0, 0) : const Offset(0, 3),
          child: AnimatedScale(
            duration: duration,
            scale: isActive ? 1 : 0,
            child: Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        )
      ],
    );
  }
}

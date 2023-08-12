import 'package:flutter/material.dart';

import '../../../theme/salmon_colors.dart';

class PostTagChip extends StatelessWidget {
  const PostTagChip({
    required this.child,
    this.maxWidth = double.infinity,
    this.onTap,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: 0.3,
              color: SalmonColors.muted,
            ),
            color: SalmonColors.muted.withOpacity(0.15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

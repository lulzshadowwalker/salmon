import 'package:flutter/material.dart';

import '../../../theme/salmon_colors.dart';

class PostCardTag extends StatelessWidget {
  const PostCardTag({
    required this.title,
    super.key,
  });

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: SalmonColors.muted,
        ),
        color: const Color.fromARGB(40, 84, 84, 84),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: title,
      ),
    );
  }
}

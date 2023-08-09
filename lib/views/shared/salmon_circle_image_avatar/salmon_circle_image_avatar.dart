import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/theme/salmon_colors.dart';

/// circle image avatar with an animated avatar placeholder if [image] is null
class SalmonCircleImageAvatar extends StatelessWidget {
  const SalmonCircleImageAvatar({
    super.key,
    this.radius = 128,
    required this.image,
  });

  final double radius;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        color: context.cs.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
        image: image != null
            ? DecorationImage(
                image: image!,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: image == null
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                BlendMode.srcATop,
              ),
              child: Lottie.asset(
                SalmonAnims.avatar,
                frameRate: FrameRate.max,
                filterQuality: FilterQuality.medium,
                addRepaintBoundary: true,
              ),
            )
          : null,
    );
  }
}

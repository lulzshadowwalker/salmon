import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
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
        color: const Color(0xD0F8D58A),
        shape: BoxShape.circle,
        border: Border.all(
          color: SalmonColors.lightBlue,
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
              colorFilter: const ColorFilter.mode(
                SalmonColors.blue,
                BlendMode.hue,
              ),
              child: Lottie.asset(
                SalmonAnims.avatar,
                frameRate: FrameRate.max,
                filterQuality: FilterQuality.high,
              ),
            )
          : null,
    );
  }
}

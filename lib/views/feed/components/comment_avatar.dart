import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../helpers/salmon_images.dart';

class CommentAvatar extends StatelessWidget {
  const CommentAvatar({
    super.key,
    required this.imageUrl,
    this.size = 36,
  });

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? SalmonImages.defaultAvatar,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image(
          image: imageProvider,
          height: size,
          width: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
        ),
      ),
      errorWidget: (context, url, error) => const SizedBox.shrink(),
    );
  }
}

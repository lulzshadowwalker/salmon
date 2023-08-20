import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/models/salmon_user.dart';

import '../../../theme/salmon_colors.dart';

class CommentAvatar extends StatelessWidget {
  const CommentAvatar({
    super.key,
    required this.user,
    this.size = 36,
  });

  final SalmonUser user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: user.pfp ?? '',
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
      placeholder: (context, url) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.cs.primaryContainer,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          user.displayName?[0] ?? 'A',
          style: TextStyle(
            color: SalmonColors.white,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.cs.primaryContainer,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          user.displayName?[0] ?? 'A',
          style: TextStyle(
            color: SalmonColors.white,
          ),
        ),
      ),
    );
  }
}

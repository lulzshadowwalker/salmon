import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';

import '../../shared/salmon_loading_indicator/salmon_loading_indicator.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    required this.imageUrl,
    this.backgroundColor,
    super.key,
  });

  final String imageUrl;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? context.theme.colorScheme.primaryContainer,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CachedNetworkImage(
            imageUrl: SalmonImages.agencyPlaceholder,
            memCacheHeight: 256,
          ),
          errorWidget: (context, url, error) => CachedNetworkImage(
            imageUrl: SalmonImages.agencyPlaceholder,
            memCacheHeight: 256,
          ),
          memCacheHeight: 256,
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../theme/salmon_colors.dart';
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
        color: backgroundColor ?? SalmonColors.lightYellow,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => const Center(
            child:
                SalmonLoadingIndicator(), // TODO add placeholder and error builder
          ),
          memCacheHeight: 256,
        ),
      ),
    );
  }
}
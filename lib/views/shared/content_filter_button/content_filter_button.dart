import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/content_filter/content_filter_provider.dart';

import '../../../theme/salmon_colors.dart';
import 'components/content_filters.dart';

class ContentFilterButton extends ConsumerWidget {
  const ContentFilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(contentFilterProvider).isActive;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (context) => const ContentFilters(),
        );
      },
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          context.cs.primary,
          isActive ? BlendMode.srcIn : BlendMode.dstIn,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                Icons.filter_list_rounded,
                size: 28,
              ),
              const SizedBox(width: 4),
              Text(
                context.sl.filter,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

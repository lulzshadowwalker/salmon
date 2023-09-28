import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_images.dart';

import '../../../../l10n/l10n_imports.dart';
import '../../../../providers/content_filter/content_filter_provider.dart';
import '../../../../theme/salmon_colors.dart';
import '../../salmon_checkbox_list_tile/salmon_checkbox_list_tile.dart';
import '../../salmon_constrained_box/salmon_constrained_box.dart';

class ContentFilters extends ConsumerWidget {
  const ContentFilters({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(contentTagsProvider(context.sl.localeName));
    final selectedTags =
        ref.watch(contentFilterProvider(context.sl.localeName));

    return SalmonConstrainedBox(
      child: SafeArea(
        bottom: kFlutterMemoryAllocationsEnabled,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            border: Border.all(
              width: 0.2,
              color: SalmonColors.muted,
            ),
            color: context.theme.scaffoldBackgroundColor,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            minChildSize: 0.25,
            initialChildSize: 0.35,
            maxChildSize: 0.6,
            builder: (context, scrollController) => Padding(
              padding: const EdgeInsets.all(42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.buildingColumns,
                        size: 28,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.sl.agencies,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: List.generate(
                          tags.length,
                          (index) {
                            final tag = tags[index];

                            return SalmonCheckboxListTile(
                              title: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: tag.logo ??
                                        SalmonImages.agencyPlacholder,
                                    height: 36,
                                    width: 36,
                                    imageBuilder: (context, imageProvider) =>
                                        Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        end: 16,
                                      ),
                                      child: Image(
                                        image: imageProvider,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const SizedBox.shrink(),
                                  ),
                                  Expanded(
                                    child: Text(
                                      (context.isEn
                                              ? tag.enName
                                              : tag.arName) ??
                                          SL.of(context).unknown,
                                      style: TextStyle(
                                        color: SalmonColors.muted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              value: selectedTags.tags.contains(tag),
                              onChanged: (val) {
                                ref
                                    .read(contentFilterProvider(
                                            context.sl.localeName)
                                        .notifier)
                                    .toggleSelect(tag);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

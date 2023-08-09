import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

import '../../../providers/drawer/drawer_provider.dart';
import '../../shared/menu_button/menu_button.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({
    this.title,
    super.key,
  });

  final Widget? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: title,
      leading: const MenuButton(),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 32),
          child: FaIcon(
            FontAwesomeIcons.bell,
            size: 32,
            color: context.textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

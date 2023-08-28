import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

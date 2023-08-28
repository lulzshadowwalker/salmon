import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MenuButton extends ConsumerWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20),
      child: IconButton(
        iconSize: 26,
        onPressed: () {
          final s = Scaffold.of(context);
          s.isDrawerOpen ? s.closeDrawer() : s.openDrawer();
        },
        icon: const Icon(FontAwesomeIcons.bars),
      ),
    );
  }
}

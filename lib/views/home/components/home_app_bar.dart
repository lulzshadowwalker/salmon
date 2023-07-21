import 'package:flutter/material.dart';

import '../../shared/animated_menu_icon/animated_menu_icon.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.only(
        top: 72,
        bottom: 16,
        start: 42,
      ),
      child: AnimatedMenuIcon(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../theme/salmon_colors.dart';
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
        end: 42,
      ),
      child: Row(
        children: [
          AnimatedMenuIcon(),
          Spacer(),
          FaIcon(
            FontAwesomeIcons.bell,
            size: 24,
            color: SalmonColors.black,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/controllers/notif/notif_controller.dart';
import 'package:salmon/views/shared/app_bar_divider/app_bar_divider.dart';
import '../../helpers/salmon_anims.dart';
import '../../helpers/salmon_helpers.dart';
import '../../l10n/l10n_imports.dart';
import '../salmon_drawer/components/salmon_drawer_components.dart';
import '../shared/menu_button/menu_button.dart';
import '../shared/salmon_info_dialog/salmon_info_dialog.dart';

class Analytics extends HookConsumerWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // TODO custom hook
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SalmonHelpers.maybeShowIntroductoryDialog(
          context: context,
          builder: (context) {
            // TODO dialog msgs
            return SalmonInfoDialog(
              title: 'We Hear You',
              subtitle: 'we value your\nconcerns and suggestions',
              child: Lottie.asset(
                SalmonAnims.shapes,
              ),
            );
          },
          id: 'analytics',
        );
      });

      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        leading: const MenuButton(),
        title: Text(SL.of(context).settings),
        bottom: const AppBarDivider(),
      ),
      drawer: const Drawer(child: SalmonDrawer()),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            onPressed: () {
              NotifController.showInDevPopup(context);
            },
            child: const Text('tappitty tap'),
          ),
        ),
      ),
    );
  }
}

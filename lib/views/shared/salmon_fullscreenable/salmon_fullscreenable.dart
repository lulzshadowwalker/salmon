import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/router/salmon_routes.dart';

/// talk about naming ikr ;)
class SalmonFullscreenable extends ConsumerWidget {
  const SalmonFullscreenable({
    required this.child,
    this.onWillPop,
    this.fullscreen,
    this.appBar,
    super.key,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? fullscreen;
  final Future<bool> Function()? onWillPop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(salmonThemeProvider);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          SalmonRoutes.screen,
          extra: Theme(
            data: theme.dark(),
            child: WillPopScope(
              onWillPop: onWillPop,
              child: Scaffold(
                appBar: appBar ?? (context.canAnyPop ? AppBar() : null),
                body: Center(
                  child: InteractiveViewer(
                    child: fullscreen ?? child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

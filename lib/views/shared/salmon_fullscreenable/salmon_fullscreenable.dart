import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/router/salmon_routes.dart';

/// talk about naming ikr ;)
class SalmonFullscreenable extends StatelessWidget {
  const SalmonFullscreenable({
    required this.child,
    this.appBar,
    super.key,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          SalmonRoutes.fullscreenable,
          extra: Scaffold(
            appBar: appBar ?? (context.canAnyPop ? AppBar() : null),
            body: Center(
              child: InteractiveViewer(
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

class SalmonNavigator extends StatefulWidget {
  const SalmonNavigator({
    this.onGenerateRoute,
    this.onGenerateInitialRoutes = Navigator.defaultGenerateInitialRoutes,
    this.child,
    super.key,
  });

  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(NavigatorState, String)
      onGenerateInitialRoutes;
  final Widget? child;

  @override
  State<SalmonNavigator> createState() => _SalmonNavigatorState();
}

class _SalmonNavigatorState extends State<SalmonNavigator> {
  final _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState? navigatorState = _navKey.currentState;
        if (navigatorState != null && navigatorState.canPop()) {
          navigatorState.pop();
          return false;
        }

        return true;
      },
      child: Navigator(
        key: _navKey,
        onGenerateRoute: widget.onGenerateRoute,
        onGenerateInitialRoutes: widget.child == null
            ? widget.onGenerateInitialRoutes
            : (navigator, initialRoute) => [
                  MaterialPageRoute(
                    builder: (context) => widget.child!,
                  ),
                ],
      ),
    );
  }
}

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/views/analytics/analytics.dart';
import 'package:salmon/views/interface/interface.dart';
import 'package:salmon/views/settings/comps/settings_comps.dart';
import '../views/auth/sign_in.dart';
import '../views/auth/sign_up.dart';
import '../views/not_found/not_found.dart';
import 'gorouter_refresh_stream.dart';

class SalmonRouter {
  SalmonRouter(this.ref);
  final Ref ref;

  GoRouter get config => GoRouter(
        errorBuilder: (context, state) => const NotFound(),
        redirect: (context, state) {
          // final isFirstLaunch =
          //     GetStorage().read<bool>(SalmonConst.skIsFirstLaunch) ?? true;

          // final isOnSplash = state.location == SalmonRoutes.splash;
          final isAuthenticated = ref.read(a12nProvider).isAuthenticated;
          final isGoingToAuthenticate = state.location == SalmonRoutes.signIn ||
              state.location == SalmonRoutes.signUp;

          if (!isAuthenticated && !isGoingToAuthenticate) {
            return SalmonRoutes.signUp;
          } else if (isAuthenticated && isGoingToAuthenticate) {
            return SalmonRoutes.home;
          }
          return null;
        },
        refreshListenable:
            GoRouterRefreshStream(ref.read(a12nProvider).authState),
        routes: [
          GoRoute(
            name: SalmonRoutes.home,
            path: SalmonRoutes.home,
            builder: (context, state) => const Interface(),
          ),
          GoRoute(
              name: SalmonRoutes.settings,
              path: SalmonRoutes.settings,
              builder: (context, state) => const Settings(),
              routes: [
                GoRoute(
                  name: SalmonRoutes.accountDetails,
                  path: SalmonRoutes.accountDetails,
                  builder: (context, state) => const AccountDetails(),
                )
              ]),
          GoRoute(
            name: SalmonRoutes.analytics,
            path: SalmonRoutes.analytics,
            builder: (context, state) => const Analytics(),
          ),
          GoRoute(
            name: SalmonRoutes.signIn,
            path: SalmonRoutes.signIn,
            builder: (context, state) => const SignIn(),
          ),
          GoRoute(
            name: SalmonRoutes.signUp,
            path: SalmonRoutes.signUp,
            builder: (context, state) => const SignUp(),
          ),
        ],
      );
}

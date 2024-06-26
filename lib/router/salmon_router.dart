import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/views/feed/components/post_view.dart';
import 'package:salmon/views/interface/interface.dart';
import 'package:salmon/views/issues/components/general_submission/components/general_submission_components.dart';
import 'package:salmon/views/issues/components/issue_submission/components/issue_submission_components.dart';
import 'package:salmon/views/issues/components/submisison_review.dart';
import 'package:salmon/views/onboarding/onboarding.dart';
import 'package:salmon/views/salmon_webview/salmon_webview.dart';
import 'package:salmon/views/settings/comps/settings_comps.dart';
import 'package:salmon/views/shared/salmon_screen/salmon_screen.dart';
import 'package:salmon/views/splash/splash.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../helpers/salmon_const.dart';
import '../models/post.dart';
import '../models/event.dart' as salmon;
import '../models/submission.dart';
import '../views/auth/sign_in.dart';
import '../views/auth/sign_up.dart';
import '../views/chat/components/channel_view.dart';
import '../views/events/components/event_components.dart';
import '../views/not_found/not_found.dart';
import 'gorouter_refresh_stream.dart';

class SalmonRouter {
  SalmonRouter(this.ref);
  final Ref ref;

  GoRouter get config => GoRouter(
        errorBuilder: (context, state) => const NotFound(),
        redirect: (context, state) {
          final isFirstLaunch =
              GetStorage().read<bool>(SalmonConst.skIsFirstLaunch) ?? true;

          final isOnSplash = state.location == SalmonRoutes.splash;
          final isAuthenticated = ref.read(a12nProvider).isAuthenticated;
          final isGoingToAuthenticate = state.location == SalmonRoutes.signIn ||
              state.location == SalmonRoutes.signUp;

          if (!isOnSplash && isFirstLaunch) {
            return SalmonRoutes.onboarding;
          } else if (!isAuthenticated &&
              !isGoingToAuthenticate &&
              !isOnSplash) {
            return SalmonRoutes.signUp;
          } else if (isAuthenticated && isGoingToAuthenticate) {
            return SalmonRoutes.home;
          }
          return null;
        },
        refreshListenable:
            GoRouterRefreshStream(ref.watch(a12nProvider).authState),
        initialLocation: SalmonRoutes.splash,
        routes: [
          GoRoute(
            name: SalmonRoutes.home,
            path: SalmonRoutes.home,
            builder: (context, state) => const Interface(),
            routes: [
              GoRoute(
                name: SalmonRoutes.postView,
                path: SalmonRoutes.postView,
                builder: (context, state) {
                  final extra = state.extra! as Post;
                  return PostView(post: extra);
                },
              ),
              GoRoute(
                name: SalmonRoutes.eventView,
                path: SalmonRoutes.eventView,
                builder: (context, state) {
                  final extra = state.extra! as salmon.Event;
                  return EventView(event: extra);
                },
              ),
              GoRoute(
                name: SalmonRoutes.chat,
                path: SalmonRoutes.chat,
                builder: (context, state) {
                  final channel = state.extra as Channel;
                  return ChannelView(channel: channel);
                },
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
                  ),
                  GoRoute(
                    name: SalmonRoutes.notifsDetails,
                    path: SalmonRoutes.notifsDetails,
                    builder: (context, state) => const NotifsDetails(),
                  ),
                ],
              ),
              GoRoute(
                name: SalmonRoutes.analytics,
                path: SalmonRoutes.analytics,
                builder: (context, state) => const Events(),
              ),
              GoRoute(
                name: SalmonRoutes.generalSubmission,
                path: SalmonRoutes.generalSubmission,
                builder: (context, state) => const GeneralSubmission(),
              ),
              GoRoute(
                name: SalmonRoutes.issueSubmission,
                path: SalmonRoutes.issueSubmission,
                builder: (context, state) => const IssueSubmission(),
              ),
              GoRoute(
                name: SalmonRoutes.submissionReview,
                path: SalmonRoutes.submissionReview,
                builder: (context, state) {
                  final submission = state.extra as Submission;

                  return SubmissionReview(
                    submission: submission,
                  );
                },
              ),
              GoRoute(
                name: SalmonRoutes.screen,
                path: SalmonRoutes.screen,
                builder: (context, state) => SalmonScreen(
                  widget: state.extra as Widget,
                ),
              ),
              // GoRoute(
              //   // TODO GoRouter pop w value prolly requires a higher package version
              //   name: SalmonRoutes.locationPicker,
              //   path: SalmonRoutes.locationPicker,
              //   builder: (context, state) => const SalmonLocationPicker(),
              // )
              GoRoute(
                name: SalmonRoutes.webview,
                path: SalmonRoutes.webview,
                builder: (context, state) {
                  final title = (state.extra as Map<String, String>)['title']!;
                  final url = (state.extra as Map<String, String>)['url']!;

                  return SalmonWebview(
                    title: title,
                    url: url,
                  );
                },
              )
            ],
          ),
          GoRoute(
            name: SalmonRoutes.splash,
            path: SalmonRoutes.splash,
            builder: (context, state) => const Splash(),
          ),
          GoRoute(
            name: SalmonRoutes.onboarding,
            path: SalmonRoutes.onboarding,
            builder: (context, state) => const Onboarding(),
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

final class SalmonRoutes {
  static const String home = '/';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String splash = '/splash';
  static const String settings = 'settings';
  static const String onboarding = '/onboarding';
  static const String analytics = 'analytics';
  static const String accountDetails = 'account-details';
  static const String notifsDetails = 'notifs-details';
  static const String postView = 'post-view';
  static const String issueSubmission = 'issue-submission';
  static const String generalSubmission = 'general-submission';
  static const String submissionReview = 'submission-review';
  static const String fullscreenable = 'fullscreenable';
  // static const String locationPicker = 'location-picker';
  static const String chat = 'chat';
  static const String eventView = 'event-view';

  static const all = <String>[
    home,
    signIn,
    signUp,
    splash,
    settings,
    onboarding,
    analytics,
    accountDetails,
    postView,
    issueSubmission,
    generalSubmission,
    submissionReview,
    fullscreenable,
  ];

  static bool validate(String route) => all.contains(route);
}

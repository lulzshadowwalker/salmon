part of './issue_submission_components.dart';

class _SubmissionData extends InheritedWidget {
  const _SubmissionData({
    super.key,
    required this.data,
    required super.child,
  });

  final Submission data;

  static _SubmissionData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SubmissionData>();
  }

  @override
  bool updateShouldNotify(_SubmissionData oldWidget) {
    return data != oldWidget.data;
  }
}

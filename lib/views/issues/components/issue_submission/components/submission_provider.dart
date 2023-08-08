part of './issue_submission_components.dart';

class _SubmissionNotifier extends AutoDisposeNotifier<Submission> {
  @override
  Submission build() {
    return const Submission();
  }

  void set(Submission submission) {
    state = submission;
  }

  void addAtttachments(
    List attachments, [
    Function? callback,
  ]) {
    final original = state.attachments;

    state = state.copyWith(
      attachments: (original ?? [])..addAll(attachments),
    );

    if (callback != null) {
      callback();
    }
  }

  void removeAttachments(
    Object attachment, [
    Function? callback,
  ]) {
    final original = state.attachments;
    state = state.copyWith(
      attachments: (original ?? [])..remove(attachment),
    );

    if (callback != null) {
      callback();
    }
  }
}

final _submissionProvider =
    NotifierProvider.autoDispose<_SubmissionNotifier, Submission>(
  () => _SubmissionNotifier(),
);

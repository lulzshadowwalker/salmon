import 'package:flutter/material.dart';
import 'package:salmon/views/issues/components/general_submission/components/general_submission_components.dart';
import 'package:salmon/views/issues/components/issue_submission/components/issue_submission_components.dart';

import '../../../models/submission.dart';

class SubmissionReview extends StatelessWidget {
  const SubmissionReview({
    required this.submission,
    super.key,
  });

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    switch (submission.type) {
      case 'general':
        return GeneralSubmissionReview(
          submission: submission,
        );

      case 'issue':
      default:
        return IssueSubmissionReview(
          submission: submission,
        );
    }
  }
}

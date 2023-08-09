import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/models/submission.dart';
import 'package:salmon/providers/submissions/submissions_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/views/home/components/home_app_bar.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';
import 'package:salmon/views/shared/salmon_single_child_scroll_view/salmon_single_child_scroll_view.dart';
import 'package:salmon/views/shared/salmon_step_progress_indicator/salmon_step_progress_indicator.dart';

import '../../../helpers/salmon_anims.dart';
import '../../../theme/salmon_colors.dart';
import 'issue_submission/components/issue_submission_components.dart';

part '../issues.dart';
part './issue_card.dart';
part 'submission_tile.dart';

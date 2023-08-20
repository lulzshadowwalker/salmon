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
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';

import '../../../helpers/salmon_anims.dart';
import '../../../helpers/salmon_helpers.dart';
import '../../../theme/salmon_colors.dart';
import '../../shared/salmon_info_dialog/salmon_info_dialog.dart';

part '../issues.dart';
part './issue_card.dart';
part 'submission_tile.dart';

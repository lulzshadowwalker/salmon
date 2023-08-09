import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/models/attachment.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';
import 'package:salmon/views/interface/interface.dart';
import 'package:salmon/views/issues/components/issues_components.dart';
import 'package:salmon/views/shared/salmon_step_progress_indicator/salmon_step_progress_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../../../helpers/salmon_anims.dart';
import '../../../../../helpers/salmon_helpers.dart';
import '../../../../../helpers/salmon_images.dart';
import '../../../../../models/submission.dart';
import '../../../../../providers/agencies/agencies_provider.dart';
import '../../../../../providers/agency/agency_provider.dart';
import '../../../../../theme/salmon_colors.dart';
import '../../../../shared/salmon_attachment_card/salmon_attachment_card.dart';
import '../../../../shared/salmon_form_field/salmon_form_field.dart';
import '../../../../shared/salmon_fullscreenable/salmon_fullscreenable.dart';
import '../../../../shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import '../../../../shared/salmon_location_picker/salmon_location_picker.dart';
import '../../../../shared/salmon_single_child_scroll_view/salmon_single_child_scroll_view.dart';
import '../../../../shared/salmon_unfocusable_wrapper/salmon_unfocusable_wrapper.dart';
import '../../../../shared/salmon_video_player/salmon_video_player.dart';

part 'general_submission_step_1.dart';
part 'general_submission_step_2.dart';
part 'general_submission_step_3.dart';
part 'general_submission_preview.dart';
part 'general_submission_review.dart';
part 'submission_provider.dart';
part 'submission_review_stepper.dart';
part 'submission_data.dart';
part '../general_submission.dart';
part 'general_submit_button.dart';
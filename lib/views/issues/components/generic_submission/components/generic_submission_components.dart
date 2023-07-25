import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';
import 'package:salmon/views/issues/components/issues_components.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../../../helpers/salmon_helpers.dart';
import '../../../../../helpers/salmon_images.dart';
import '../../../../../models/submission.dart';
import '../../../../../providers/agencies/agencies_provider.dart';
import '../../../../../theme/salmon_colors.dart';
import '../../../../shared/salmon_attachment_card/salmon_attachment_card.dart';
import '../../../../shared/salmon_form_field/salmon_form_field.dart';
import '../../../../shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import '../../../../shared/salmon_location_picker/salmon_location_picker.dart';
import '../../../../shared/salmon_unfocusable_wrapper/salmon_unfocusable_wrapper.dart';

part '../generic_submission.dart';
part 'generic_submission_step_1.dart';
part 'generic_submission_step_2.dart';
part 'generic_submission_step_3.dart';

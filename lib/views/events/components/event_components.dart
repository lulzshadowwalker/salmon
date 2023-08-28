import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:salmon/controllers/events/events_controller.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/models/event.dart';
import 'package:salmon/providers/check_event_user/check_event_user_provider.dart';
import 'package:salmon/providers/event_users/event_users_provider.dart';
import 'package:salmon/providers/events/events_provider.dart';
import 'package:salmon/providers/theme_data/theme_data_provider.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/theme/salmon_theme.dart';
import 'package:salmon/views/home/components/home_app_bar.dart';
import 'package:salmon/views/salmon_drawer/components/salmon_drawer_components.dart';
import 'package:salmon/views/shared/salmon_single_child_scroll_view/salmon_single_child_scroll_view.dart';
import 'package:salmon/views/shared/salmon_tag_chip/salmon_tag_chip.dart';
import 'package:salmon/views/shared/salmon_user_avatar/salmon_user_avatar.dart';
import 'package:shimmer/shimmer.dart';

import '../../../providers/agency/agency_provider.dart';
import '../../../theme/salmon_colors.dart';
import '../../shared/salmon_animated_overlapping_stack/salmon_animated_overlapping_stack.dart';

part './event_card.dart';
part './event_view.dart';
part '../events.dart';
part './event_data.dart';
part './is_going_button.dart';
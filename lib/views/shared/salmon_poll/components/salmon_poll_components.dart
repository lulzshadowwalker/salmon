import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/models/poll.dart';
import 'package:salmon/models/poll_option.dart';
import 'package:salmon/models/poll_vote.dart';
import 'package:salmon/providers/agency/agency_provider.dart';
import 'package:salmon/providers/check_vote/check_vote_provider.dart';
import 'package:salmon/providers/db/remote_db/remote_db_provider.dart';
import '../../../../theme/salmon_colors.dart';

part '../salmon_poll.dart';
part './salmon_poll_option.dart';
part 'salmon_poll_data.dart';
part './salmon_poll_vote_data.dart';

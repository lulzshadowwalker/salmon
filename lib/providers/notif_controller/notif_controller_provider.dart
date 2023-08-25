import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/notifs/notifs_controller.dart';

final notifControllerProvider = Provider((ref) => NotifsController(ref));

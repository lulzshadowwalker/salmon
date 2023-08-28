import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/notifs/notifs_controller.dart';

final notifsControllerProvider = Provider((ref) => NotifsController(ref));

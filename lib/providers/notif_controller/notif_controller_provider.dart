import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/notif/notif_controller.dart';

final notifControllerProvider = Provider((ref) => NotifController(ref));

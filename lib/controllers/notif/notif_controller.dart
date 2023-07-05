import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/theme/salmon_colors.dart';
import '../../models/enums/notif_type.dart';
import '../../models/notif_config.dart';

class NotifController {
  NotifController._internal();
  factory NotifController() => NotifController._internal();

  static final _log = SalmonHelpers.getLogger('NotifController');

  static final _notifConfigs = <NotifType, NotifConfig>{
    NotifType.success: NotifConfig(
      color: SalmonColors.green,
      leading: Lottie.asset(
        SalmonAnims.success,
        repeat: false,
      ),
    ),
    NotifType.warning: NotifConfig(
      color: SalmonColors.yellow,
      leading: Lottie.asset(
        SalmonAnims.warning,
        repeat: false,
      ),
    ),
    NotifType.oops: NotifConfig(
      color: SalmonColors.red,
      leading: Lottie.asset(
        SalmonAnims.oops,
        repeat: false,
      ),
    ),
    NotifType.tip: NotifConfig(
      color: SalmonColors.lightBlue,
      leading: Lottie.asset(
        SalmonAnims.info,
        repeat: false,
      ),
    ),
  };

  static NotifConfig _getNotifConfig(NotifType type) =>
      _notifConfigs[type] ?? _notifConfigs[NotifType.tip]!;

  static void _showMobilePopop({
    required BuildContext context,
    required String title,
    required String desc,
    required NotifType type,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: _getNotifConfig(type).color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 56,
        ),
        content: ListTile(
          leading: SizedBox(
            height: double.infinity,
            child: _getNotifConfig(type).leading,
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: SalmonColors.white),
          ),
          subtitle: Text(
            desc,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: SalmonColors.white.withOpacity(0.65)),
          ),
        ),
      ),
    );
  }

  /// shows an adaptive platform appropriate popup
  static void showPopup({
    required BuildContext context,
    String? title,
    required String message,
    required NotifType type,
  }) {
    const duration = Duration(milliseconds: 3500);

    switch (type) {
      case NotifType.success:
        _showMobilePopop(
          context: context,
          title: title ?? SL.of(context).success,
          desc: message,
          type: type,
          duration: duration,
        );
        break;
      case NotifType.oops:
        _showMobilePopop(
          context: context,
          title: title ?? SL.of(context).oops,
          desc: message,
          type: type,
          duration: duration,
        );
        break;
      case NotifType.warning:
        _showMobilePopop(
          context: context,
          title: title ?? SL.of(context).warning,
          desc: message,
          type: type,
          duration: duration,
        );
        break;
      case NotifType.tip:
        _showMobilePopop(
          context: context,
          title: title ?? SL.of(context).tip,
          desc: message,
          type: type,
          duration: duration,
        );
        break;
    }

    _log.v('''
Popup shown with details
  type: ${type.name},
  title: $title, 
  description: $message
''');
  }
}

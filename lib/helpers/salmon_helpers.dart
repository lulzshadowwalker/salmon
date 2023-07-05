import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:salmon/helpers/salmon_log_printer.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/views/shared/salmon_image_picker_options/salmon_image_picker_options.dart';
import '../controllers/notif/notif_controller.dart';
import '../models/enums/notif_type.dart';
import '../models/salmon_silent_exception.dart';

final class SalmonHelpers {
  static final _log = getLogger('SalmonHelpers');

  /// Instantiate a [Logger] instance with the neseccary boilerplate code
  static Logger getLogger(String className) => Logger(
        printer: SalmonLogPrinter(className),
      );

  /// image picking utility for android/iOS/web
  /// ..
  /// mobile, gallery / camera
  /// web, gallery
  static Future<Uint8List?> pickImage(BuildContext context) async {
    try {
      const aborted = SalmonSilentException(
          'image picking proccess terminated by the user');

      final imageSource = await showModalBottomSheet(
        context: context,
        builder: (_) => const SalmonImagePickerOptions(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        constraints: const BoxConstraints(maxWidth: 500),
      );

      if (imageSource == null) {
        throw aborted;
      }

      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) {
        throw aborted;
      }

      return image.readAsBytes();
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  static void handleException({
    required BuildContext context,
    required Object e,
    required Logger logger,
  }) {
    if (e is SocketException) {
      _handleSocketException(context, logger);
    } else if (e is FirebaseAuthException) {
      _handleFirebaseAuthException(context, e);
    } else if (e is SalmonSilentException) {
      logger.e(e.message);
    } else {
      _handleUnkownError(context, e, logger);
    }
  }

  static void _handleSocketException(
    BuildContext context,
    Logger logger,
  ) {
    logger.e('SocketExcepetion, check internet connection.');

    NotifController.showPopup(
      context: context,
      message: SL.of(context).networkRequestFailed,
      type: NotifType.oops,
    );
  }

  static void _handleFirebaseAuthException(
    BuildContext context,
    FirebaseAuthException e,
  ) {
    _log.e('${e.message}');

    final map = <String, String>{
      "wrong-password": SL.of(context).wrongPassword,
      "email-already-in-use": SL.of(context).emailAlreadyInUse,
      "weak-password": SL.of(context).weakPassword,
      "auth/user-not-found": SL.of(context).authUserNotFound,
      "network-request-failed": SL.of(context).networkRequestFailed,
      "requires-recent-login": SL.of(context).requiresRecentLogin,
    };

    NotifController.showPopup(
      context: context,
      message: map[e.code] ?? SL.of(context).unknownError,
      type: NotifType.oops,
    );
  }

  static void _handleUnkownError(
    BuildContext context,
    Object error,
    Logger logger,
  ) {
    logger.e(error.toString());

    NotifController.showPopup(
      context: context,
      message: SL.of(context).unknownError,
      type: NotifType.oops,
    );
  }
}

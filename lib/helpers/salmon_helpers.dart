import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  static Future<Uint8List?> pickImageFromSource(
    BuildContext context, {
    double? maxWidth = 512,
    double? maxHeight,
  }) async {
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

      final image = await ImagePicker().pickImage(
        source: imageSource,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image == null) {
        throw aborted;
      }

      return image.readAsBytes();
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  static Future<Uint8List?> pickImageFromGallery({
    double? maxWidth = 512,
    double? maxHeight,
  }) async {
    try {
      const aborted = SalmonSilentException(
          'image picking proccess terminated by the user');

      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image == null) {
        throw aborted;
      }

      return image.readAsBytes();
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  static Future<Uint8List?> pickImageFromCamera({
    double? maxWidth = 512,
    double? maxHeight,
  }) async {
    try {
      const aborted = SalmonSilentException(
          'image picking proccess terminated by the user');

      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image == null) {
        throw aborted;
      }

      return image.readAsBytes();
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  static Future<Uint8List?> pickVideoFromCamera() async {
    try {
      const aborted = SalmonSilentException(
          'image picking proccess terminated by the user');

      final image = await ImagePicker().pickVideo(source: ImageSource.camera);

      if (image == null) {
        throw aborted;
      }

      return image.readAsBytes();
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  static Future<List<Uint8List>?> pickImages({
    double? maxWidth = 512,
    double? maxHeight,
  }) async {
    try {
      const aborted = SalmonSilentException(
          'image picking proccess terminated by the user');

      final images = await ImagePicker()
          .pickMultipleMedia(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      )
          .then((images) {
        return images.map((e) async {
          return await e.readAsBytes();
        });
      });

      if (images.isEmpty) {
        throw aborted;
      }

      return await Future.wait(images);
    } catch (e) {
      _log.e(e.toString());
      return null;
    }
  }

  static Future<List<Uint8List>?> pickFiles() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result == null) {
        throw const SalmonSilentException(
            'file picking proccess terminated by the user');
      }

      final files = result.paths
          .map((path) async => await File(path!).readAsBytes())
          .toList();

      return await Future.wait(files);
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
      "user-not-found": SL.of(context).authUserNotFound,
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

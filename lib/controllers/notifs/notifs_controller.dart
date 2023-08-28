import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_anims.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/providers/current_user/current_user_provider.dart';
import 'package:salmon/theme/salmon_colors.dart';
import '../../models/enums/notif_type.dart';
import '../../models/notif_config.dart';

// ! must be a top level function [read more](https://firebase.flutter.dev/docs/messaging/usage#:~:text=Handling%20messages%20whilst,which%20requires%20initialization)
@pragma('vm:entry-point')
Future<void> _handleFcmBackgroundMessage(RemoteMessage message) async {
  SalmonHelpers.getLogger('NotifsController')
      .v('received a background cloud message:\n${message.toString()}');

  final RemoteNotification? notif = message.notification;
  if (notif != null) {
    NotifsController.show(
      id: DateTime.now().second,
      title: notif.title ?? 'We would like to hear your feedback',
      body: notif.body ?? 'feel free to let us know what you have on your mind',
    );
  }
}

class NotifsController {
  NotifsController(this.ref);
  final Ref ref;

  static final _log = SalmonHelpers.getLogger('NotifController');

  static Map<NotifType, NotifConfig> _notifConfigs(BuildContext context) => {
        NotifType.success: NotifConfig(
          color: SalmonColors.green,
          leading: Lottie.asset(
            SalmonAnims.success,
            repeat: false,
          ),
        ),
        NotifType.warning: NotifConfig(
          color: Theme.of(context).colorScheme.primary,
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

  static NotifConfig _getNotifConfig(BuildContext context, NotifType type) =>
      _notifConfigs(context)[type] ?? _notifConfigs(context)[NotifType.tip]!;

  static void showPopup({
    required BuildContext context,
    String? title,
    required String message,
    required NotifType type,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    title ??= switch (type) {
      NotifType.success => SL.of(context).success,
      NotifType.tip => SL.of(context).tip,
      NotifType.oops => SL.of(context).oops,
      NotifType.warning => SL.of(context).warning,
    };

    ScaffoldMessenger.maybeOf(context)?.removeCurrentSnackBar();

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: _getNotifConfig(context, type).color,
        dismissDirection: DismissDirection.horizontal,
        content: ListTile(
          leading: SizedBox(
            height: double.infinity,
            child: _getNotifConfig(context, type).leading,
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: SalmonColors.white),
          ),
          subtitle: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: SalmonColors.white.withOpacity(0.65)),
          ),
        ),
      ),
    );

    _log.v('''
Popup shown with details
  type: ${type.name},
  title: $title, 
  description: $message
''');
  }

  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const _notifDetails = NotificationDetails(
    //
    android: AndroidNotificationDetails(
      'main_channel',
      'General',
      importance: Importance.high,
      priority: Priority.high,
      color: SalmonColors.blue,
    ),

    //
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> init() async {
    try {
      if (Platform.isAndroid) {
        final isGranted = await _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestPermission() ??
            false;

        if (!isGranted) {
          await show(
            id: 372,
            title: 'Welcome to Salmon',
            body: 'feel free to explore what the we have to offer',
          );
        }
      } else if (Platform.isIOS) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }

      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const initializationSettingsIOS = DarwinInitializationSettings();

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      await _initCloudMessaging();

      _log.v('[NotifController] has been initialized');
    } catch (e) {
      _log.e(e.toString());
    }
  }

  /// firebase cloud messaging token
  static Future<String?> get fcmToken async =>
      await FirebaseMessaging.instance.getToken();

  static Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _notifDetails,
    );

    _log.v('''
local push notification has been shown
  title: $title
  body: $body
''');
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    _log.v('all notifications have been cancelled');
  }

  Future<void> _initCloudMessaging() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    // TODO deeplinking
    // final route =
    //     await FirebaseMessaging.instance.getInitialMessage().then((msg) {
    //   _log.v('inital cloud message:\n${msg.toString()}');
    //   return msg?.data['named-route'] as String?;
    // });
    // if (SalmonRoutes.validate(route ?? '')) {
    //   ref.read(routerProvider).goNamed(route!);
    // }

    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission();

      _log.v(
          'user\'s notifications permission status: ${settings.authorizationStatus}');
    }

    FirebaseMessaging.onMessage.listen(
      (message) {
        _log.v('received a foreground cloud message:\n${message.toString()}');
        final RemoteNotification? notif = message.notification;
        if (notif != null) {
          show(
            id: DateTime.now().second,
            title: notif.title ?? 'We would like to hear your feedback',
            body: notif.body ??
                'feel free to let us know what you have on your mind',
          );
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(_handleFcmBackgroundMessage);

    _log.v('Firebase Cloud-Messaging has been initialized');
  }

  static String generateTopicName(String name) => name
      .trim()
      .replaceAll(' ', '-')
      .replaceAll(RegExp(r"[^a-zA-Z0-9-]"), '')
      .toLowerCase();

  Future<bool?> checkTopicSubscription(String topic) async {
    try {
      final user = await ref.read(currentUserProvider.future);

      final isSubbed = user.topics?.contains(topic) ?? false;

      _log.v('''
topic ($topic) subscription status check: $isSubbed
''');

      return isSubbed;
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Future<void> manageTopicSubscription({
    required String topic,
    required bool subscribe,
  }) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      if (subscribe) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {
            'topics': FieldValue.arrayUnion([topic]),
          },
          SetOptions(merge: true),
        );
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      } else {
        await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {
            'topics': FieldValue.arrayRemove([topic]),
          },
          SetOptions(merge: true),
        );
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      }

      _log.v('''
topic ($topic) subscription status: $subscribe
''');
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
    }
  }

  static void showInDevPopup(BuildContext context) {
    NotifsController.showPopup(
      context: context,
      title: 'nope',
      message: 'in development 🥱',
      type: NotifType.tip,
    );
  }
}

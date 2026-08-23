// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // initialize
  Future<void> initNotification() async {
    // prevent re-initialization
    if (_isInitialized) {
      return;
    }

    // prepare android init settings
    const initSettingsAndroid = AndroidInitializationSettings('light_app_icon');

    // prepare ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // group together - init settings
    const initSetings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // finally, initialize the plugin
    await notificationsPlugin.initialize(settings: initSetings);

    final androidImplementation = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();

    _isInitialized = true;
  } // end method

  // notifications detail setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'light_app_icon',
      ),

      iOS: DarwinNotificationDetails(),
    );
  } // end method

  // show notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails(),
    );
  } // end method
} // end class

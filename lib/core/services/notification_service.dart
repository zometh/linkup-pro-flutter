import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static BuildContext? _routerContext;

  static void registerContext(BuildContext context) {
    _routerContext = context;
  }

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Notifications principales',
          channelDescription: 'Notifications importantes de LinkUp Pro',
          defaultColor: Colors.deepPurple,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
        ),
      ],
    );

    await _requestNotificationPermissions();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (receivedAction) {
        final route = receivedAction.payload?['route'];
        final id = receivedAction.payload?['id'];

        if (route != null && _routerContext != null) {
          _routerContext!.push('$route/${id ?? ''}');
        }
        return Future.value();
      },
      onNotificationCreatedMethod: (receivedNotification){
        // Handle notification creation
        return Future.value();
      },
      onNotificationDisplayedMethod: (receivedNotification) {
        // Handle notification display
        return Future.value();
      },
      onDismissActionReceivedMethod: (receivedNotification) {
        // Handle notification dismissal
        return Future.value();
      },
    );
  }

  static Future<void> _requestNotificationPermissions() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    debugPrint('🔔 Permissions notifications : ${settings.authorizationStatus}');
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    await _showAwesomeNotification(message);
  }

  static Future<void> _onMessageOpenedAppHandler(RemoteMessage message) async {
    final route = message.data['route'];
    final id = message.data['id'];
    if (route != null) _navigateToRoute(route, id);
  }

  static Future<void> _showAwesomeNotification(RemoteMessage message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ?? 'Notification',
        body: message.notification?.body ?? '',
        bigPicture: message.data['image'],
        notificationLayout: message.data['image'] != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        payload: {
          'route': message.data['route'] ?? '/',
          'id': message.data['id'] ?? '',
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN',
          label: 'Ouvrir',
        ),
        NotificationActionButton(
          key: 'CLOSE',
          label: 'Fermer',
          actionType: ActionType.DismissAction,
        ),
      ],
    );
  }

  static void _navigateToRoute(String route, String? id) {
    if (_routerContext == null) return;
    _routerContext!.push('$route/${id ?? ''}');
  }

  static Future<String?> getDeviceToken() async {
    return await _messaging.getToken();
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await _showAwesomeNotification(message);
  }
}

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';

import '../../features/login/data/auth_repository_implement.dart';

// la fonction qui gère les messages quand l'app est complètement éteinte.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.showAwesomeNotification(message);
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Utiliser une GlobalKey est plus sûr que de stocker le contexte
  static GlobalKey<NavigatorState>? navigatorKey;

  static Future<void> initialize(GlobalKey<NavigatorState> key) async {
    navigatorKey = key; // On sauvegarde la clé de navigation

    await Firebase.initializeApp();

    // 1. Configurer les canaux de notification (Le design)
    await AwesomeNotifications().initialize(
      null, // null = icône par défaut de l'app
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Notifications principales',
          channelDescription: 'Canal principal',
          defaultColor: Colors.deepPurple,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
    );

    // 2. Demander les permissions
    await _requestPermissions();

    // 3. Récupérer le token initial et écouter les changements
    String? token = await _messaging.getToken();
    if (token != null) _sendTokenToBackend(token);

    _messaging.onTokenRefresh.listen((newToken) {
      _sendTokenToBackend(newToken);
    });

    // 4. Écouter les messages Firebase
    // Quand l'app est en arrière-plan/tuée (défini tout en haut du fichier)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Quand l'app est ouverte devant les yeux de l'utilisateur
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showAwesomeNotification(message);
    });

    // 5. Gérer les clics sur les notifications (Awesome Notifications)
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  // Méthode appelée quand on clique sur la notification
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    final route = receivedAction.payload?['route'];
    //print(route);
    if (route != null && navigatorKey?.currentContext != null) {
      GoRouter.of(navigatorKey!.currentContext!).push(route);
    }
  }

  static Future<void> _requestPermissions() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // Crée l'affichage visuel de la notif
  static Future<void> showAwesomeNotification(RemoteMessage message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        // On priorise le titre dans 'notification', sinon on regarde dans 'data'
        title: translate(
          message.notification?.title!.tr() ?? message.data['title'],
        ),
        body: formatBody(message.notification?.body!.tr() ?? message.data['body']),
        // Si une image est envoyée dans les data
        bigPicture: message.data['image'],
        notificationLayout: message.data['image'] != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        // Payload utile pour la redirection
        payload: {'route': message.data['route'] ?? '/'},
        displayOnBackground: true,
        displayOnForeground: true,
        roundedBigPicture: true,
        // fullScreenIntent: true,
      ),
    );
  }

  static String translate(String key) => key.tr();
  static String formatBody(String data) {
    final parsedDatas = jsonDecode(data) as Map<String, dynamic>;
    final title = parsedDatas["title"] as String;
    return title.tr(
      namedArgs: {"name": parsedDatas["params"]["senderName"] as String},
    );
  }

  static void _sendTokenToBackend(String token) async {
    final db = GetIt.I<LocalDBService>();
    if (await db.isConnected()) {
      final authRepositoryImplements = GetIt.I<AuthRepositoryImplement>();

      await authRepositoryImplements.sendDeviceToken(token);
    }
  }
}

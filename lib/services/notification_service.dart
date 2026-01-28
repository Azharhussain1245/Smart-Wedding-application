// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'services/notification_service.dart';


// class NotificationService {
//   static final _notifications =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     tz.initializeTimeZones();

//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const initSettings =
//         InitializationSettings(android: androidSettings);

//     await _notifications.initialize(initSettings);
//   }

//   static Future<void> scheduleTaskNotification({
//     required int id,
//     required String title,
//     required DateTime scheduledDate,
//   }) async {
//     final tzDate = tz.TZDateTime.from(
//       scheduledDate,
//       tz.local,
//     );

//     await _notifications.zonedSchedule(
//       id,
//       'SmartWed Reminder',
//       title,
//       tzDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'tasks_channel',
//           'Task Reminders',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart'; // or wherever your MyApp is located

////////////////////////////////////////////////////////////
/// 🔔 NOTIFICATION SERVICE (UNCHANGED LOGIC)
////////////////////////////////////////////////////////////
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);
  }

  static Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required DateTime scheduledDate,
  }) async {
    final tzDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    await _notifications.zonedSchedule(
      id,
      'SmartWed Reminder',
      title,
      tzDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'tasks_channel',
          'Task Reminders',
          channelDescription: 'Reminder for wedding tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🚀 MAIN ENTRY POINT (UPDATED ONLY)
////////////////////////////////////////////////////////////
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await NotificationService.init();

  runApp(const MyApp());
}

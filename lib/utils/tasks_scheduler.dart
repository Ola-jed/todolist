import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todolist/models/task.dart';

Future<void> scheduleTask(Task taskToSchedule) async {
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final androidNotificationDetails =
      AndroidNotificationDetails('1', 'Todolist', channelDescription: 'Tasks from todolist app');
  final initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Todolist : ${taskToSchedule.title}',
      taskToSchedule.description,
      tz.TZDateTime.from(
              taskToSchedule.dateLimit, tz.getLocation('Africa/Porto-Novo'))
          .add(Duration(hours: 10)),
      NotificationDetails(android: androidNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

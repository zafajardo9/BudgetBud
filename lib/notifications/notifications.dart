import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:budget_bud/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../data/budget_goal_data.dart';

Future<void> createBudgetGoalNotification() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          notificationLayout: NotificationLayout.Default,
          body: 'BudgetBud will help you on Budgeting your Money!',
          title: '${Emojis.money_coin + Emojis.time_watch} Welcome!'));
}

////////////////////////////////////////////////////////////ANOTHER SAVING GOAL

Future<void> initNotifications() async {
  // Create an instance of the FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the plugin with the app icon
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Configure initialization settings for Android and iOS
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: null, // Add iOS settings if needed
  );

  // Initialize the plugin with the initialization settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Set the local time zone
  tz.initializeTimeZones();
  tz.setLocalLocation(
      tz.getLocation('Asia/Manila')); // Replace with your desired time zone ID
}

Future<void> scheduleBudgetGoalNotification(BudgetGoal goal) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Configure notification details
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'Schedule Goal Reminder',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Check if the goal is not accomplished
  if (!goal.accomplished) {
    // Get the local time zone
    tz.Location timeZone = tz.local;

    // Convert the goal's end date to TZDateTime
    tz.TZDateTime goalEndDate = tz.TZDateTime.from(goal.endDate, timeZone);

    // Calculate the time until the goal end date
    final Duration timeUntilGoalEnd =
        goalEndDate.difference(tz.TZDateTime.now(timeZone));

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Budget Goal Not Accomplished',
      'Your budget goal "${goal.budgetName}" has not been accomplished.',
      tz.TZDateTime.now(timeZone).add(timeUntilGoalEnd),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

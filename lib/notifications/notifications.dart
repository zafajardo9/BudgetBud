import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:budget_bud/util/utilities.dart';
import 'package:flutter/material.dart';

Future<void> createBudgetGoalNotification() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          notificationLayout: NotificationLayout.Default,
          body: 'BudgetBud will help you on Budgeting your Money!',
          title: '${Emojis.money_coin + Emojis.time_watch} Welcome!'));
}

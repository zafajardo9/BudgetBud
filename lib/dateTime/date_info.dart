class DateInfo {
  String getCurrentDay() {
    final now = DateTime.now();
    return now.day.toString();
  }

  String getCurrentWeekday() {
    final now = DateTime.now();
    final weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return weekdayNames[now.weekday - 1];
  }

  String getCurrentWeek() {
    final now = DateTime.now();

    final weekStartDate = now.subtract(Duration(days: now.weekday - 1));
    final weekEndDate = weekStartDate.add(Duration(days: 6));

    final startMonth = getCurrentMonthFromDate(weekStartDate);
    final endMonth = getCurrentMonthFromDate(weekEndDate);

    if (startMonth == endMonth) {
      return '$startMonth ${weekStartDate.day}-${weekEndDate.day}';
    } else {
      return '$startMonth ${weekStartDate.day} - $endMonth ${weekEndDate.day}';
    }
  }

  int getCurrentYear() {
    final now = DateTime.now();
    return now.year;
  }

  String getCurrentMonthFromDate(DateTime date) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return monthNames[date.month - 1];
  }
}

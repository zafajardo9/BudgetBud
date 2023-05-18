// to convert DateTime Object to a yyyymmdd format

String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month'; //'0' + month; used String interpolation, best way
  }
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  //combine
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

DateTime parseIso8601String(String iso8601String) {
  return DateTime.parse(iso8601String).toLocal();
}

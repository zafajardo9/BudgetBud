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

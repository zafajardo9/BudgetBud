String convertDateTimeToString(DateTime dateTime) {
  //yyyymmdd
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0' + month;
  }
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0' + day;
  }

  //final format
  String finalFormatDate = year + month + day;

  return finalFormatDate;
}

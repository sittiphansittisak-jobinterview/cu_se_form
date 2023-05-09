const List<String> _thaiMonthList = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];

String? thaiDateTime(DateTime? dateTime, {bool showDate = true, bool showTime = true}) {
  try {
    if (dateTime == null) return null;
    String date = '';
    String time = '';
    List<String> datetimeList = dateTime.toLocal().toString().split(" ");
    if (showDate) {
      List<String> dateList = datetimeList[0].split("-");
      int yearEN = int.parse(dateList[0]);
      date = '${int.parse(dateList[2])} ${_thaiMonthList[int.parse(dateList[1]) - 1]} ${(yearEN + 543).toString()}';
    }
    if (showTime) {
      if (showDate) {
        datetimeList[0] = datetimeList[1];
        time = " ";
      }
      List<String> timeList = datetimeList[0].split(":");
      time += 'เวลา ${int.parse(timeList[0])}:${timeList[1]} น.';
    }
    String result = date + time;
    return result.isEmpty ? null : result;
  } catch (e) {
    return null;
  }
}

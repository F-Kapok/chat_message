import 'package:intl/intl.dart';

class WechatDateFormat {
  static String format(int millisecondsSinceEpoch, {bool dayOnly = true}) {
    //当天日期
    DateTime now = DateTime.now();
    //传入的日期
    DateTime targetDate =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String prefix = "";
    if (now.year != targetDate.year) {
      prefix = DateFormat('yyyy年M月d日').format(targetDate);
    } else if (now.month != targetDate.month) {
      prefix = DateFormat('M月d日').format(targetDate);
    } else if (now.day != targetDate.day) {
      if (now.day - targetDate.day == 1) {
        prefix = '昨天';
      } else {
        prefix = DateFormat('M月d日').format(targetDate);
      }
    }
    if (prefix.isNotEmpty && dayOnly) {
      return prefix;
    }
    int targetHour = targetDate.hour;
    String returnTime = "";
    String suffix = DateFormat('h:mm').format(targetDate);
    if (targetHour >= 0 && targetHour < 6) {
      returnTime = '凌晨';
    } else if (targetHour >= 6 && targetHour < 8) {
      returnTime = '早晨';
    } else if (targetHour >= 8 && targetHour < 11) {
      returnTime = '上午';
    } else if (targetHour >= 11 && targetHour < 13) {
      returnTime = '中午';
    } else if (targetHour >= 13 && targetHour < 18) {
      returnTime = '下午';
    } else if (targetHour >= 18 && targetHour <= 23) {
      returnTime = '晚上';
    }
    return '$prefix $returnTime$suffix';
  }
}

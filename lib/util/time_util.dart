import 'package:time_machine/time_machine.dart';
import 'package:intl/intl.dart';
import '../index.dart';

class TimeUtil {
  static getUtcNow() {
    var now = Instant.now();
    return now.toString();
  }

  static getUtcTimestamp() {
    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
//    logger.d(now);
    return now;
  }

  static formatTime(dynamic time, int type, String format) {
    var oldTime;

    /// 1 为 utc 毫秒时间戳
    if (type == 1) {
      oldTime =
          DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();
    }
    var newFormat = DateFormat(format);
    String updatedDt = newFormat.format(oldTime);
    return updatedDt;
  }

  static lastSeen(int time) {
    String back = '';
    DateTime now = DateTime.now();
    DateTime oldTime;
    if (time == 0) {
      back = 'last seen a long time ago';
    } else {
      oldTime =
          DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();
      Duration difference = now.difference(oldTime);
      if (oldTime.isBefore(now)) {
        if (difference.inMinutes < 60) {
          if (difference.inMinutes <= 1) {
            back = 'last seen just now';
          } else {
            back = 'last seen ${difference.inMinutes} minutes ago';
          }
        } else if (difference.inMinutes > 60) {
          String hmStr = formatTime(time, 1, 'HH:mm');
          String mStr = formatTime(time, 1, 'MMM d');
          String yearStr = formatTime(time, 1, 'MMM dd, yyyy');
          if (oldTime.day == now.day && oldTime.month == now.month) {
            if (difference.inHours == 1 || difference.inHours == 0) {
              back = 'last seen ${difference.inHours} hour ago';
            } else {
              back = 'last seen ${difference.inHours} hours ago';
            }
          } else {
            if (oldTime.year == now.year) {
              back = 'last seen $mStr at $hmStr';
            } else {
              back = 'last seen $yearStr';
            }
          }
        }
      } else {
        String yearStr = formatTime(time, 1, 'MMM dd, yyyy');
        back = 'last seen $yearStr';
      }
    }
    return back;
  }

  static dialogTime(int time) {
    String back = '';
    DateTime now = DateTime.now();
    DateTime oldTime;
    if (time == 0) {
      back = '';
    } else {
      oldTime =
          DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();
//      Duration difference = now.difference(oldTime);
      String hmStr = formatTime(time, 1, 'HH:mm');
      String mStr = formatTime(time, 1, 'MMM d');
      String yearStr = formatTime(time, 1, 'MMM dd, yyyy');
      if (oldTime.isBefore(now)) {
        if (oldTime.year == now.year &&
            oldTime.month == now.month &&
            oldTime.day == now.day) {
          back = '$hmStr';
        } else {
          back = '$yearStr';
        }
      } else {
        if (oldTime.year == now.year) {
          back = '$mStr';
        } else {
          back = '$yearStr';
        }
      }
    }
    return back;
  }

  static chatDate(int time) {
    String back = '';
    DateTime now = DateTime.now();
    DateTime oldTime;
    if (time == 0) {
      back = '';
    } else {
      oldTime =
          DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();
      if (oldTime.isBefore(now) && oldTime.year == now.year) {
        String mStr = formatTime(time, 1, 'MMM d');
        back = '$mStr';
      } else {
        String yearStr = formatTime(time, 1, 'MMM dd, yyyy');
        back = '$yearStr';
      }
    }
    return back;
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartmove/models/User.dart';
import 'package:intl/intl.dart';

class AppGlobal
{
  static User userLoad;
  static final dateFormat = DateFormat("yyyy-MM-dd");
  static final timeFormat = DateFormat("HH:mm");
  static final dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

}
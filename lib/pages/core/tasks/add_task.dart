import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:random_string/random_string.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/KeyboardHideView.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';
import 'package:smartmove/services/constant_strings.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with TickerProviderStateMixin {
  bool _saving = false;

  TextEditingController titleInputController,
      descInputController,
      dateInputController,
      timeInputController;

  User userSave = User();
  SharedPref sharedPref = SharedPref();

  var dateFormatterBasedOnDevice;
  var dateFormatterBasedOnDeviceNEW;

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();

    ///todo: maybe standardize on one format
    Devicelocale.currentLocale.then((onValue) {
      dateFormatterBasedOnDevice = DateFormat.yMd(onValue);
      dateFormatterBasedOnDeviceNEW = DateFormat.yMd(onValue).add_Hm();
    });

    titleInputController = TextEditingController();
    descInputController = TextEditingController();
    dateInputController = TextEditingController();
    timeInputController = TextEditingController();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

      setState(() {
        AppGlobal.userLoad = user;
      });
    } catch (Exception) {}
  }

  Future<bool> _exitApp(BuildContext context) async {
    Navigator.pop(context, false);
    return false;
  }

  void navigationPage() {
    Navigator.pop(context, true);
  }

  void throwError(PlatformException error, BuildContext context) {
    setState(() {
      _saving = false;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error.message),
    ));
  }

  _saveTask(BuildContext context) {
    setState(() {
      _saving = true;
    });

    final randomValue = randomAlphaNumeric(30);

    DateTime scheduledNotificationDateTime = DateTime.parse(
        dateFormatterBasedOnDeviceNEW
            .parse(dateInputController.text.trim() +
                " " +
                timeInputController.text.trim())
            .toString());

    int _id =
        (scheduledNotificationDateTime.millisecondsSinceEpoch / 1000).round();

    Firestore.instance.collection("tasks").document(randomValue).setData({
      "uid": AppGlobal.userLoad.id,
      "title": titleInputController.text.toString().trim(),
      "description": descInputController.text.toString().trim(),
      "tdate": dateInputController.text.toString().trim(),
      "ttime": timeInputController.text.toString().trim(),
      "device_type": Platform.isAndroid ? "Android" : "iOS",
      "key": randomValue,
      "millisecond": scheduledNotificationDateTime.millisecondsSinceEpoch,
      "reminderId": _id,
      "status": 0
    }).then((result) {
      setState(() {
        _saving = false;
      });

      setNotification(scheduledNotificationDateTime);

      navigationPage();
    }).catchError((err) => throwError(err, context));
  }

  ///todo: migrate to FLN v3
  setNotification(DateTime scheduledNotificationDateTime) async {
    var android = AndroidNotificationDetails(
        taskChannelId, taskChannelName, taskChannelDescription, importance: Importance.Max, priority: Priority.Max);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    int _id =
        (scheduledNotificationDateTime.millisecondsSinceEpoch / 1000).round();
    await AppGlobal.flutterLocalNotificationsPlugin.schedule(
        _id,
        titleInputController.text.trim(),
        descInputController.text.trim(),
        scheduledNotificationDateTime,
        platform);
  }

  setNoti() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await AppGlobal.flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);

    print("=====setNoti====");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return KeyboardHideView(
              child: ModalProgressHUD(
                inAsyncCall: _saving,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SafeArea(
                        child: TileButton(
                          onTap: Navigator.of(context).pop,
                          icon: FontAwesomeIcons.times,
                          text: AppLocalizations.of(context).translate('tasks_add'),
                        ),
                      ),
                      Flex(
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(AppLocalizations.of(context).translate('tasks_name')),
                          TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              textCapitalization: TextCapitalization.sentences,
                              controller: titleInputController,
                              keyboardType: TextInputType.text,
                              autocorrect: true,
                              enableSuggestions: true,
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.center,
                              onChanged: (text) {},
                              focusNode: _titleFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _titleFocus, _descFocus);
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: DottedBorder(
                                    color: Colors.lightGreen,
                                    strokeWidth: 2,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(8),
                                    child: DateTimeField(
                                      controller: dateInputController,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context).translate('tasks_date'),
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                              Icons.calendar_today_rounded),
                                          iconSize: 15,
                                          onPressed: () {},
                                        ),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(0, 12, 0, 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                      format: dateFormatterBasedOnDevice,
                                      onShowPicker: (context, currentValue) {
                                        return showDatePicker(
                                            context: context,
                                            initialEntryMode: DatePickerEntryMode.input,
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            firstDate: DateTime.now()
                                                .add(Duration(days: -1)),
                                            lastDate: DateTime(2100));
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: DottedBorder(
                                    color: Colors.lightGreen,
                                    strokeWidth: 2,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(8),
                                    child: DateTimeField(
                                      controller: timeInputController,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context).translate('tasks_time'),
                                        prefixIcon: IconButton(
                                          icon: Icon(FontAwesomeIcons.clock),
                                          iconSize: 15,
                                          onPressed: () {},
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            0.0, 12.0, 0.0, 12.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                      ),
                                      format: AppGlobal.timeFormat,
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialEntryMode: TimePickerEntryMode.input,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue ?? DateTime.now()),
                                        );
                                        return DateTimeField.convert(time);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(AppLocalizations.of(context).translate('tasks_locale_desc')),
                          TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              textCapitalization: TextCapitalization.sentences,
                              controller: descInputController,
                              obscureText: false,
                              keyboardType: TextInputType.streetAddress,
                              enableSuggestions: true,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              textAlign: TextAlign.center,
                              onChanged: (text) {},
                              focusNode: _descFocus,
                              onFieldSubmitted: (term) {
                                _descFocus.unfocus();
                              }),
                        ],
                      ),

                      SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            AppLocalizations.of(context).translate('tasks_add'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            ///todo: maybe change to switch case
                            if (titleInputController.text.trim().isEmpty) {
                              BotToast.showText(
                                  text: AppLocalizations.of(context).translate('tasks_error1'));
                            } else if (dateInputController.text
                                .trim()
                                .isEmpty) {
                              BotToast.showText(text: AppLocalizations.of(context).translate('tasks_error2'));
                            } else if (timeInputController.text
                                .trim()
                                .isEmpty) {
                              BotToast.showText(text: AppLocalizations.of(context).translate('tasks_error3'));
                            } else if (descInputController.text
                                .trim()
                                .isEmpty) {
                              BotToast.showText(
                                  text: AppLocalizations.of(context).translate('tasks_error4'));
                            } else {
                              DateTime selectedDate = DateTime.parse(
                                  dateFormatterBasedOnDeviceNEW
                                      .parse(dateInputController.text.trim() +
                                          " " +
                                          timeInputController.text.trim())
                                      .toString());
                              DateTime currentDate = DateTime.now();

                              if (selectedDate.millisecondsSinceEpoch <=
                                  currentDate.millisecondsSinceEpoch) {
                                BotToast.showText(
                                    text: AppLocalizations.of(context).translate('tasks_error5'));
                              } else {
                                _saveTask(context);
                              }
                            }
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(20, 13, 20, 13),
                          splashColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.green[800]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/pages/core/main/main_page.dart';
//import 'package:smartmove/pages/core/search/search.dart';
import 'package:smartmove/pages/core/settings/settings_page.dart';
import 'package:smartmove/pages/core/tasks/tasks_page.dart';
import 'package:smartmove/pages/core/travel/travel_page.dart';
import 'package:smartmove/services/AppGlobal.dart';

//todo: consider making higher priority notification
//todo: delete search or maybe incorporate into travel page

PageController _pageController;
int _page = 0;

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';

  @override
  _HomePageState createState() => _HomePageState();

  showRecipesTab() {
    _pageController.jumpToPage(1);
  }
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    setState(() {
      _page = 0;
    });

    _initFlutterNotification();
    if (Platform.isIOS) {
      _notificationPermission();
    }
    initializeDateFormatting();
    print("============" +
        DateFormat.yMd().add_Hm().parse("4/14/2020 18:50").toString());
  }

  Future onSelectNotification(String payload) {
    try {
      /*showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Alert"),
          content: Text(payload),
        ));*/
    } catch (Exception) {}
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              /* Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );*/
            },
          )
        ],
      ),
    );
  }

  ///todo: migrate to FLN v3
  _initFlutterNotification() {
    AppGlobal.flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSettings = InitializationSettings(android, iOS);
    AppGlobal.flutterLocalNotificationsPlugin
        .initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  _notificationPermission() async {
    await AppGlobal.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///todo: implement this for android
  /*
  Future<void> showNotification(BuildContext context) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
    NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await AppGlobal.flutterLocalNotificationsPlugin.show(
      0,  // Notification ID
      titleInputController.text.trim(), // Notification Title
        descInputController.text.trim(), // Notification Body, set as null to remove the body
      platformChannelSpecifics,
      payload: 'New Payload', // Notification Payload
    );
  }*/

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            MainPage(),
            TasksPage(),
            TravelPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 15.0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: AppLocalizations.of(context).translate("appbar1")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_rounded),
                label: AppLocalizations.of(context).translate("appbar2")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_bus_rounded),
                label: AppLocalizations.of(context).translate("appbar3")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: AppLocalizations.of(context).translate("appbar4")
            ),
          ],
          currentIndex: _page,
          onTap: navigationTapped,
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async
  {
    //return false;
    return Future.value(true);
  }

}

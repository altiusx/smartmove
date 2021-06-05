import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/route.dart';
import 'package:smartmove/common_widgets/text_styles.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/pages/core/main/outstanding_tasks.dart';
import 'package:smartmove/pages/core/settings/mrt_map.dart';
import 'package:smartmove/pages/core/settings/review_favorites.dart';

import 'package:smartmove/pages/core/tasks/add_task.dart';
import 'package:smartmove/models/taskModel.dart';
import 'package:smartmove/common_widgets/strings.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';

List<TaskModel> lstTask = [];
List<TaskModel> lstMainTask = [];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPref sharedPref = SharedPref();

  TextEditingController searchInputController;

  bool showLoader = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    getTask();
  }

  getTask() async {
    lstTask.clear();
    lstMainTask.clear();

    if (this.mounted) {
      setState(() {
        showLoader = true;
      });
    }

    await Firestore.instance
        .collection("tasks")
        .where("uid", isEqualTo: AppGlobal.userLoad.id.toString())
        .where("status", isEqualTo: 0)
        .orderBy("tdate", descending: true)
        .orderBy("ttime", descending: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) async {
        if (mounted) {
          setState(() {
            lstTask.add(TaskModel.fromJson(f.data));
            lstMainTask.add(TaskModel.fromJson(f.data));
          });
        }
      });

      //Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        showLoader = false;
      });
    });
    //});
  }

  /*getTip() {
    StreamBuilder(
      stream: Firestore.instance.collection("tips").snapshots(),
      builder: (context, snapshot){
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              DocumentSnapshot tip = snapshot.data.documents[index];
              return ListTile(
                //leading: Text(tips['tip']),
                title: Text(tip['tip']),
                subtitle: Text(tip['tip2']),
              );
            },
        );
      },
    );
  }*/

  loadSharedPrefs() async {
    if (mounted) {
      try {
        User user = User.fromJson(await sharedPref.read("user"));

        setState(() {
          AppGlobal.userLoad = user;
        });
      } catch (Exception) {}
    }
  }

  void navigationTasksPage() {
    Navigator.of(context).push(_createOutstandingTasksRoute()).then((onValue) {
      loadSharedPrefs();
    });
  }

  //provides L-R-L transition animations
  Route _createOutstandingTasksRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          OutstandingTasks(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: [
            //for the title bar (name and pic)
            SafeArea(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (AppGlobal.userLoad.imagePath.isEmpty ||
                            AppGlobal.userLoad.imagePath == null)
                        ? Image(
                            image: AssetImage(
                                "assets/assetimages/ic_user_with_circle.png"),
                            height: 70,
                            width: 70,
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    NetworkImage(AppGlobal.userLoad.imagePath),
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        style: menuBar(context),
                        children: <TextSpan>[
                          TextSpan(text: _greeting()),
                          TextSpan(
                            text: AppGlobal.userLoad.name,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: ListView(
                children: [
                  //getTip(),
                  Container(
                    child: showLoader
                        ? Card(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(AppLocalizations.of(context)
                                      .translate('loading'))
                                ],
                              ),
                            ),
                          )
                        : Card(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: AppLocalizations.of(context)
                                              .translate('tip_header'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: _getRandomMessage(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //getTip(),
                                ],
                              ),
                            ),
                          ),
                  ),

                  Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate('outstanding1')),
                                TextSpan(
                                  text: lstTask.length.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate('outstanding2'))
                              ],
                            ),
                          ),
                          TileButton(
                            text: AppLocalizations.of(context)
                                .translate('outstanding3'),
                            icon: FontAwesomeIcons.listAlt,
                            onTap: () {
                              navigationTasksPage();
                            },
                          ),
                          TileButton(
                            text: AppLocalizations.of(context)
                                .translate('outstanding4'),
                            icon: FontAwesomeIcons.plus,
                            onTap: () {
                              _addTask();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate('menubus_init')),
                                TextSpan(
                                  text: Hive.box('favorites').length.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate('menubus1')),
                              ],
                            ),
                          ),
                          TileButton(
                            text: AppLocalizations.of(context).translate('menubus2'),
                            icon: FontAwesomeIcons.bus,
                            onTap: () => Routing.openRoute(
                                context, ReviewFavoritesPage()),
                          ),
                          TileButton(
                            text: AppLocalizations.of(context).translate('menubus3'),
                            icon: FontAwesomeIcons.train,
                            onTap: () =>
                                Routing.openRoute(context, MRTMapPage()),
                          ),
                          /*TileButton(
                            text: "View MRT Map",
                            icon: FontAwesomeIcons.train,
                            onTap: () =>
                                Routing.openRoute(context, MRTMapPage()),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRandomMessage() {
    Locale myLocale = Localizations.localeOf(context);
    ///todo: consider storing the strings in firebase? then read from there. see chinese.json files
    if (myLocale.toString() == "zh_SG") {
      return (Strings.tipsZh.toList()..shuffle()).first;
    }
    return (Strings.tipsEn.toList()..shuffle()).first;
  }

  _greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocalizations.of(context).translate("main_greeting1");
    }
    if (hour < 17) {
      return AppLocalizations.of(context).translate("main_greeting2");
    }
    return AppLocalizations.of(context).translate("main_greeting3");
  }

  void _addTask() {
    Navigator.of(context).push(_createAddTaskRoute()).then((onValue) {
      if (onValue == true) {
        getTask();
      }
    });
  }

  Route _createAddTaskRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddTask(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

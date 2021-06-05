import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/pages/core/tasks/edit_task.dart';
import 'package:smartmove/models/taskModel.dart';
import 'package:smartmove/pages/core/travel/services/url.dart';
import 'package:smartmove/services/AppGlobal.dart';

List<TaskModel> lstTask = [];
List<TaskModel> lstMainTask = [];

class OutstandingTasks extends StatefulWidget {
  @override
  _OutstandingTasksState createState() => _OutstandingTasksState();
}

class _OutstandingTasksState extends State<OutstandingTasks> {
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
        setState(() {
          lstTask.add(TaskModel.fromJson(f.data));
          lstMainTask.add(TaskModel.fromJson(f.data));
        });
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showLoader = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //width: MediaQuery.of(context).copyWith().size.width,
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: TileButton(
                      onTap: Navigator.of(context).pop,
                      icon: FontAwesomeIcons.times,
                      text: AppLocalizations.of(context)
                          .translate('outstanding_title'),
                    ),
                  ),
                  Expanded(
                      child: showLoader
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            )
                          : lstTask.length == 0
                              ? Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('tasks_nil'),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: lstTask.length,
                                  padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 10,
                                          margin: EdgeInsets.all(10),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 10, 0),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      lstTask[index].tdate,
                                                    ),
                                                    Text(
                                                      lstTask[index].ttime,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          _shareApp(index);
                                                        },
                                                        child: Platform.isIOS
                                                            ? Icon(
                                                                Icons.ios_share)
                                                            : Icon(
                                                                Icons.share)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  lstTask[index].title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)
                                                          .translate(
                                                              'tasks_location') +
                                                      lstTask[index]
                                                          .description,
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  height: 1,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 7, 0, 7),
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            _editTask(index);
                                                          },
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .solidEdit)),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      _locale(index),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      _addCal(index),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            deleteData(
                                                                context, index);
                                                          },
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .trash,
                                                            color: Colors.red,
                                                          )),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            FlatButton(
                                                              onPressed: () {
                                                                _completeTask(
                                                                    index);
                                                              },
                                                              child: Text(
                                                                  "Complete"),
                                                              color:
                                                                  Colors.green,
                                                              textColor:
                                                                  Colors.white,
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          0,
                                                                          20,
                                                                          0),
                                                              splashColor: Colors
                                                                  .lightGreenAccent,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    lstTask.clear();
    if (text.isEmpty) {
      setState(() {
        lstTask.addAll(lstMainTask);
      });
      return;
    }
    setState(() {
      lstMainTask.forEach((taskDetail) {
        if (taskDetail.title.toLowerCase().contains(text.toLowerCase()) ||
            taskDetail.description.toLowerCase().contains(text.toLowerCase()))
          lstTask.add(taskDetail);
      });
    });
  }

  _shareApp(int index) async {
    String shareText = "\n\nTask : " + lstTask[index].title;
    shareText += "\nLocation : " + lstTask[index].description;
    shareText +=
        "\nDate : " + lstTask[index].tdate + " " + lstTask[index].ttime;

    String txt = AppGlobal.userLoad.name + " has shared a task with you.....";

    Share.share(txt + shareText);
  }

  _locale(index) {
    return GestureDetector(
        child: Icon(FontAwesomeIcons.locationArrow),
        onTap: () => openMapString(lstTask[index].description));
  }

  _addCal(index) {
    Event event = Event(
      title: lstTask[index].title,
      description: lstTask[index].tdate + " " + lstTask[index].ttime,
      location: lstTask[index].description,

      ///todo: just testing, start date may need to change but formatting issues
      ///DateTime.parse(lstTask[index].tdate) shows invalid date format and replaceAll "/" with "" is just weird af
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 1)),
      allDay: false,
    );
    return GestureDetector(
        child: Icon(FontAwesomeIcons.calendar),
        onTap: () {
          Add2Calendar.addEvent2Cal(event);
        });
  }

  deleteData(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text(AppLocalizations.of(context).translate('tasks_remove1')),
            content:
                Text(AppLocalizations.of(context).translate('tasks_remove2')),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context).translate('no'),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Firestore.instance
                      .collection("tasks")
                      .document(lstTask[index].key)
                      .delete()
                      .then((onValue) {
                    setState(() {
                      AppGlobal.flutterLocalNotificationsPlugin
                          .cancel(lstTask[index].reminderId);
                      lstTask.removeAt(index);
                    });
                  }).catchError((e) {});
                },
                child: Text(
                  AppLocalizations.of(context).translate('yes'),
                ),
              ),
            ],
          );
        });
  }

  _completeTask(int index) async {
    setState(() {
      _saving = true;
    });

    Firestore.instance
        .collection("tasks")
        .document(lstTask[index].key)
        .updateData({"status": 1}).then((result) {
      setState(() {
        lstTask.removeAt(index);
        _saving = false;
      });
      BotToast.showText(
          text: AppLocalizations.of(context).translate('tasks_complete'));
    }).catchError((err) => throwError(err, context));
  }

  void throwError(PlatformException error, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error.message),
    ));
  }

  /*void _addTask() {
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
  }*/

  void _editTask(int index) {
    Navigator.of(context).push(_createEditTaskRoute(index)).then((onValue) {
      if (onValue) {
        getTask();
      }
    });
  }

  Route _createEditTaskRoute(int index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          EditTask(taskModel: lstTask[index]),
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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/KeyboardHideView.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/models/taskModel.dart';
import 'package:smartmove/services/AppGlobal.dart';

List<TaskModel> lstTask = [];
List<TaskModel> lstMainTask = [];

class CompletedTasksPage extends StatefulWidget {
  @override
  _CompletedTasksPageState createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  /*TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14.0,
  );

  TextStyle titleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle itemTitleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
  );

  TextStyle itemDescStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 15.0,
  );

  TextStyle itemTimeStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 13.0,
  );

  TextStyle itemEditStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
  );

  TextStyle itemDeleteStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 15.0,
  );

  TextStyle itemShareStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 13.0,
  );

  TextStyle noRecordFoundStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );*/

  TextEditingController searchInputController;

  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    getTask();
  }

  getTask() async {
    lstTask.clear();
    lstMainTask.clear();

    setState(() {
      showLoader = true;
    });

    await Firestore.instance
        .collection("tasks")
        .where("uid", isEqualTo: AppGlobal.userLoad.id.toString())
        .where("status", isEqualTo: 1)
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
    String shareText = "\n\nTitle : " + lstTask[index].title;
    shareText += "\nDescription : " + lstTask[index].description;
    shareText +=
        "\nDate : " + lstTask[index].tdate + " " + lstTask[index].ttime;

    String txt = AppGlobal.userLoad.name + " has shared a task with you.....";

    Share.share(txt + shareText);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardHideView(
        child: Column(
          children: <Widget>[
            SafeArea(
              //padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: TileButton(
                onTap: Navigator.of(context).pop,
                icon: FontAwesomeIcons.times,
                text: AppLocalizations.of(context)
                    .translate('tasks_completed'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextFormField(
                controller: searchInputController,
                enabled: lstMainTask.length > 0,
                keyboardType: TextInputType.text,
                maxLines: 1,
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (text) {
                  onSearchTextChanged(text);
                },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('tasksearchbar'),
                  contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                ),
                onFieldSubmitted: (term) {},
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
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 10,
                                  margin: EdgeInsets.all(10),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
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
                                                child: Platform.isIOS ? Icon(Icons.ios_share) : Icon(Icons.share)
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          lstTask[index].title,
                                        ),
                                        Text(
                                          "Located at:" +
                                              " " +
                                              lstTask[index].description,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Divider(
                                          thickness: 1,
                                          height: 1,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 7, 0, 7),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  deleteData(context, index);
                                                },
                                                child: Icon(FontAwesomeIcons.trash, color: Colors.red,)
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
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

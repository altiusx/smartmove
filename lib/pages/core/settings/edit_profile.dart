import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/KeyboardHideView.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/models/regex.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = "/editProfile";

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 16.0);

  bool _saving = false;
  bool passwordHide = true;
  TextEditingController nameInputController;

  User userSave = User();
  SharedPref sharedPref = SharedPref();

  File _image;
  String _uploadedFileURL = "";

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();

    nameInputController = TextEditingController();
    nameInputController.text = AppGlobal.userLoad.name;
  }

  final FocusNode _nameFocus = FocusNode();

  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

      setState(() {
        AppGlobal.userLoad = user;
        _uploadedFileURL = user.imagePath;
      });
    } catch (Exception) {}
  }

  Future chooseFile(BuildContext context) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });

      print('profiles/${Path.basename(_image.path)}');

      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('profiles/${Path.basename(_image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      uploadTask.onComplete.then((onValue) {
        setState(() {
          _saving = true;
        });

        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL = fileURL;
          });

          Firestore.instance
              .collection("users")
              .document(AppGlobal.userLoad.id)
              .updateData({
            "profilePhoto": _uploadedFileURL,
            "device_type": Platform.isAndroid ? "Android" : "iOS",
          }).then((result) {
            AppGlobal.userLoad.imagePath = _uploadedFileURL;
            sharedPref.save("user", AppGlobal.userLoad);

            setState(() {
              _saving = false;
            });
          }).catchError((err) => throwError(err, context));
        }).catchError((err) => throwError(err, context));
      }).catchError((err) {
        setState(() {
          _saving = false;
        });
      });
    }).catchError((err) {});
  }

  _changeProfile(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Scaffold.of(context).hideCurrentSnackBar();

    if (nameInputController.text.trim().isEmpty) {
      BotToast.showText(text: 'Please enter name');
    } else {
      setState(() {
        _saving = true;
      });

      Firestore.instance
          .collection("users")
          .document(AppGlobal.userLoad.id)
          .updateData({
        "name": nameInputController.text.toString().trim(),
        "device_type": Platform.isAndroid ? "Android" : "iOS",
      }).then((result) {
        AppGlobal.userLoad.name = nameInputController.text.toString().trim();
        sharedPref.save("user", AppGlobal.userLoad);

        setState(() {
          _saving = false;
        });

        Navigator.pop(context);
      }).catchError((err) => throwError(err, context));
    }
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

  Widget _nameField(context) {
    return TextFormField(
      obscureText: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        FilteringTextInputFormatter.allow(Regex.onlyCharacter)
      ],
      textCapitalization: TextCapitalization.words,
      controller: nameInputController,
      style: style,
      enableSuggestions: true,
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {},
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)
            .translate('login_prompt_name'),
        labelStyle: style,
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      ),
      focusNode: _nameFocus,
      onFieldSubmitted: (term) {
        _nameFocus.unfocus();
      },
    );
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
                          text: AppLocalizations.of(context)
                              .translate('edit_profile'),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          chooseFile(context);
                        },
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.center,
                                  child: (_uploadedFileURL.isEmpty ||
                                          _uploadedFileURL == null)
                                      ? Image(
                                          image: AssetImage(
                                              "assets/assetimages/ic_user_with_circle.png"),
                                          height: 150,
                                          width: 150,
                                        )
                                      : Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    _uploadedFileURL),
                                              )))),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                                  child: Icon(
                                    Icons.edit,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flex(
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: _nameField(context)),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('tasks_complete'),
                                style: style,
                              ),
                              onPressed: () {
                                _changeProfile(context);
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              padding: EdgeInsets.fromLTRB(20, 13, 20, 13),
                              splashColor: Colors.lightGreenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
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

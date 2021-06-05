import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/KeyboardHideView.dart';
import 'package:smartmove/common_widgets/text_styles.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/home_page.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/models/regex.dart';
import 'package:smartmove/pages/signin/sign_in_page.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';
import 'package:smartmove/services/constant_strings.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/registerPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;

  bool _saving = false;

  bool passwordHide = true;
  bool passwordHide2 = true;

  TextEditingController nameInput,
      emailInput,
      passwordInput,
      confirmPasswordInput;

  User userSave = User();
  SharedPref sharedPref = SharedPref();

  File _image;
  String _uploadedFileURL = "";

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 20000), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    passwordHide = true;
    passwordHide2 = true;

    nameInput = TextEditingController();
    emailInput = TextEditingController();
    passwordInput = TextEditingController();
    confirmPasswordInput = TextEditingController();
  }

  _fieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ModalProgressHUD(
            inAsyncCall: _saving,
            child: KeyboardHideView(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SafeArea(
                        child: TileButton(
                          onTap: () => openSignInPage(),
                          icon: FontAwesomeIcons.times,
                          text: AppLocalizations.of(context)
                              .translate('signup_line1'),
                        ),
                      ),
                      Flex(
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _profilePicture(context),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: _nameField(context)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: _emailField(context)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: _passwordField(context)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: _confirmPasswordField(context)),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: _registerButton(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
          );
        },
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  _register(BuildContext context) async {
    setState(() {
      _saving = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);

    uploadTask.onComplete.then((onValue) {
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
        });
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailInput.text.toString().trim(),
                password: passwordInput.text.toString().trim())
            .then((currentUser) => Firestore.instance
                .collection("users")
                .document(currentUser.user.uid)
                .setData({
                  "uid": currentUser.user.uid,
                  "name": nameInput.text.toString().trim(),
                  "email": emailInput.text.toString().trim(),
                  "profilePhoto": _uploadedFileURL,
                  "user_type": "Normal",
                  "device_type": Platform.isAndroid ? "Android" : "iOS",
                })
                .then((result) => onSuccess(currentUser.user))
                .catchError((err) => throwError(err, context)))
            .catchError((err) => throwError(err, context));
      }).catchError((err) {
        setState(() {
          _saving = false;
        });
      });
    }).catchError((err) => throwError(err, context));
  }

  void onSuccess(FirebaseUser user) {
    setState(() {
      _saving = false;
    });

    userSave.id = user.uid;
    userSave.name = nameInput.text.toString().trim();
    userSave.email = emailInput.text.toString().trim();
    userSave.loginType = "Normal";
    userSave.imagePath = _uploadedFileURL;

    sharedPref.save("user", userSave);
    sharedPref.saveBool(isLogin, true);
    sharedPref.save(isLoginType, "Normal");

    setState(() {
      AppGlobal.userLoad = userSave;
    });

    openHomePage();
  }

  void throwError(PlatformException error, BuildContext context) {
    setState(() {
      _saving = false;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error.message),
    ));
  }

  void openHomePage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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
    ));
  }

  void openSignInPage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }

  Widget _profilePicture(context) {
    return GestureDetector(
      onTap: () {
        chooseFile();
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: _image != null
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover, image: FileImage(_image))))
                    : Image(
                        image: AssetImage(
                            "assets/assetimages/ic_user_with_circle.png"),
                        height: 120,
                        width: 120,
                      )),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Icon(
                  Icons.edit_outlined,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameField(context) {
    return TextFormField(
      obscureText: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        FilteringTextInputFormatter.allow(Regex.onlyCharacter)
      ],
      textCapitalization: TextCapitalization.words,
      controller: nameInput,
      style: fieldsTextStyle(context),
      enableSuggestions: true,
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {},
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('login_prompt_name'),
        labelStyle: fieldsTextStyle(context),
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      ),
      focusNode: _nameFocus,
      onFieldSubmitted: (term) {
        _fieldFocus(context, _nameFocus, _emailFocus);
      },
    );
  }

  Widget _emailField(context) {
    return TextFormField(
      controller: emailInput,
      obscureText: false,
      style: fieldsTextStyle(context),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      enableSuggestions: true,
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        labelText: AppLocalizations.of(context).translate('login_prompt1'),
        labelStyle: fieldsTextStyle(context),
      ),
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        _fieldFocus(context, _emailFocus, _passwordFocus);
      },
    );
  }

  Widget _passwordField(context) {
    return TextFormField(
      controller: passwordInput,
      obscureText: passwordHide,
      style: fieldsTextStyle(context),
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      enableSuggestions: true,
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        labelText: AppLocalizations.of(context).translate('login_prompt2'),
        labelStyle: fieldsTextStyle(context),
        suffixIcon: IconButton(
          icon: Icon(
            passwordHide ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              passwordHide = !passwordHide;
            });
          },
        ),
      ),
      focusNode: _passwordFocus,
      onFieldSubmitted: (value) {
        _fieldFocus(context, _passwordFocus, _confirmPasswordFocus);
      },
    );
  }

  Widget _confirmPasswordField(context) {
    return TextFormField(
      controller: confirmPasswordInput,
      obscureText: passwordHide2,
      style: fieldsTextStyle(context),
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      enableSuggestions: true,
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        labelText:
            AppLocalizations.of(context).translate('login_prompt2_confirm'),
        labelStyle: fieldsTextStyle(context),
        suffixIcon: IconButton(
          icon: Icon(
            passwordHide2 ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              passwordHide2 = !passwordHide2;
            });
          },
        ),
      ),
      focusNode: _confirmPasswordFocus,
      onFieldSubmitted: (value) {
        _confirmPasswordFocus.unfocus();
      },
    );
  }

  Widget _registerButton(context) {
    return RaisedButton(
      child: Text(
        AppLocalizations.of(context).translate('signup_button'),
        style: buttonTextStyle(context),
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());

        ///todo: consider changing to switch case
        if (_image == null) {
          BotToast.showText(
              text: AppLocalizations.of(context).translate('warning_profile'));
        } else if (nameInput.text.trim().isEmpty) {
          BotToast.showText(
              text: AppLocalizations.of(context).translate('warning_name'));
        } else if (emailInput.text.trim().isEmpty) {
          BotToast.showText(
              text: AppLocalizations.of(context).translate('warning_email1'));
        } else if (!Regex.email.hasMatch(emailInput.text.trim())) {
          BotToast.showText(
              text: AppLocalizations.of(context).translate('warning_email2'));
        } else if (passwordInput.text.trim().isEmpty) {
          BotToast.showText(
              text:
                  AppLocalizations.of(context).translate('warning_password1'));
        } else if (passwordInput.text.trim().length < 8) {
          BotToast.showText(
              text:
                  AppLocalizations.of(context).translate('warning_password2'));
        } else if (confirmPasswordInput.text.trim().isEmpty) {
          BotToast.showText(
              text: AppLocalizations.of(context)
                  .translate('warning_password_confirm'));
        } else if (confirmPasswordInput.text
                .trim()
                .compareTo(passwordInput.text.trim()) !=
            0) {
          BotToast.showText(
              text: AppLocalizations.of(context)
                  .translate('warning_password_confirm_err'));
        } else {
          _register(context);
        }
      },
      color: Colors.green,
      padding: EdgeInsets.fromLTRB(20, 13, 20, 13),
      splashColor: Colors.lightGreenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(color: Colors.black),
      ),
    );
  }
}

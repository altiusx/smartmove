import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/KeyboardHideView.dart';
import 'package:smartmove/common_widgets/text_styles.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/home_page.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/models/regex.dart';
import 'package:smartmove/pages/signin/register_page.dart';
import 'package:smartmove/pages/signin/social_sign_in_button.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';
import 'package:smartmove/services/constant_strings.dart';

///todo: tweak again for bigger devices... may need to adopt mediaquery

class SignInPage extends StatefulWidget {
  static const String routeName = '/signIn';
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isInternet = false;
  bool _saving = false;
  bool passwordHide = true;

  TextEditingController emailInput, passwordInput;
  TextEditingController passwordResetInput;

  User userSave = User();
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();

    passwordHide = true;

    emailInput = TextEditingController();
    passwordInput = TextEditingController();
    passwordResetInput = TextEditingController();

    _checkInternet();

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          isInternet = true;
        });
        print("Connected to cellular network");
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isInternet = true;
        });
        print("Connected to wifi network");
      } else {
        setState(() {
          isInternet = false;
        });
        print("No internet connection");
      }
    });
  }

  _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isInternet = true;
      });
      print("Connected to cellular network");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isInternet = true;
      });
      print("Connected to wifi network");
    } else {
      setState(() {
        isInternet = false;
      });
      print("No internet connection");
    }
  }

  _fieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Builder(
        builder: (BuildContext context) {
          return ModalProgressHUD(
            inAsyncCall: _saving,
            child: KeyboardHideView(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SafeArea(
                        child: Text(
                          AppLocalizations.of(context).translate('login_line1'),
                          style: signInGreeting(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 50),
                      Flex(
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: _emailField(context)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: _passwordField(context)),
                          SizedBox(
                            height: 10.0,
                          ),
                          _passwordReset(context),
                          SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: _signInButton(context),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: _googleSignInButton(context),
                              ),
                            ],
                          ),
                          SizedBox(height: 50.0),
                          TileButton(
                            onTap: () {
                              openSignUp();
                            },
                            text: AppLocalizations.of(context)
                                .translate('login_line3'),
                            icon: FontAwesomeIcons.userCircle,
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

  Widget _emailField(context) {
    return TextFormField(
      controller: emailInput,
      obscureText: false,
      style: fieldsTextStyle(context),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      enableSuggestions: false,
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {},
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('login_prompt1'),
        labelStyle: fieldsTextStyle(context),
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
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
      //cursorColor
      autocorrect: false,
      enableSuggestions: false,
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (text) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
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
        _passwordFocus.unfocus();
      },
    );
  }

  Widget _passwordReset(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          passwordResetInput.text = "";
        });
        showDialog(
            context: context,
            builder: (BuildContext context2) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  height: 240,
                  width: MediaQuery.of(context).copyWith().size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate('login_prompt1'),
                          style: fieldsTextStyle(context),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: passwordResetInput,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          enableSuggestions: true,
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.done,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (text) {},
                          decoration: InputDecoration(
                            hintText: "example@domain.com",
                            contentPadding:
                                EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        RaisedButton(
                          child: Text(AppLocalizations.of(context)
                              .translate('login_button')),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (passwordResetInput.text.trim().isEmpty) {
                              BotToast.showText(
                                  text: AppLocalizations.of(context)
                                      .translate('warning_email1'));
                            } else if (!Regex.email
                                .hasMatch(passwordResetInput.text.trim())) {
                              BotToast.showText(
                                  text: AppLocalizations.of(context)
                                      .translate('warning_email2'));
                            } else {
                              _forgotPassword(context);
                            }
                          },
                          color: Colors.green,
                          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          splashColor: Colors.lightGreenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Text(AppLocalizations.of(context).translate('login_line2')),
    );
  }

  Widget _signInButton(context) {
    return RaisedButton(
      child: Text(
        AppLocalizations.of(context).translate('login_button'),
        style: buttonTextStyle(context),
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());

        if (emailInput.text.trim().isEmpty) {
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
        } else {
          _login(context);
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

  Widget _googleSignInButton(context) {
    return SocialSignInButton(
      assetName: 'images/google-logo.png',
      text: AppLocalizations.of(context).translate('login_button_google'),
      color: Colors.grey[500],
      textColor: Colors.black,
      onPressed: () {
        if (!isInternet) {
          print("Device is not connected to the Internet");
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("You are not connected to the Internet."),
          ));
        } else {
          _signInWithGoogle(context);
        }
      },
    );
  }

  Future<void> _forgotPassword(BuildContext context) async {
    setState(() {
      _saving = true;
    });

    FirebaseAuth.instance
        .sendPasswordResetEmail(
            email: passwordResetInput.text.toString().trim())
        .then((value) {
      setState(() {
        _saving = false;
      });
      Navigator.pop(context);
      BotToast.showText(
          text: AppLocalizations.of(context).translate('warning_pwreset'));
    }).catchError((err) => throwError(err, context));
  }

  _login(BuildContext context) async {
    setState(() {
      _saving = true;
    });

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailInput.text.toString().trim(),
            password: passwordInput.text.toString().trim())
        .then((currentUser) => onSuccess(currentUser.user))
        .catchError((err) => throwError(err, context));
  }

  void onSuccess(FirebaseUser user) async {
    var document = Firestore.instance.collection('users').document(user.uid);
    document.get().then((document) {
      print("================" + document['name']);

      setState(() {
        _saving = false;
      });

      print("============Complete=============");

      userSave.id = user.uid;
      userSave.name = document['name'];
      userSave.imagePath = document['profilePhoto'];
      userSave.email = emailInput.text.toString().trim();
      userSave.loginType = "Normal";

      sharedPref.save("user", userSave);
      sharedPref.saveBool(isLogin, true);
      sharedPref.save(isLoginType, "Normal");

      setState(() {
        AppGlobal.userLoad = userSave;
      });
      openHomePage();
    });
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _saving = true;
    });

    googleSignIn.signIn().then((googleSignInAccount) {
      googleSignInAccount.authentication
          .then((googleSignInAuthentication) async {
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final AuthResult authResult =
            await _auth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);

        Firestore.instance
            .collection("users")
            .document(user.uid)
            .setData({
              "uid": user.uid,
              "name": user.displayName,
              "email": user.email,
              "user_type": "Google",
              "device_type": Platform.isAndroid ? "Android" : "iOS",
              "profilePhoto": user.photoUrl,
            })
            .then((result) => onGoogleSuccess(user))
            .catchError((err) => throwError(err, context));
      }).catchError((onError) {
        setState(() {
          _saving = false;
        });
      });
    }).catchError((onError) {
      setState(() {
        _saving = false;
      });
    });
  }

  void onGoogleSuccess(FirebaseUser user) async {
    userSave.id = user.uid;
    userSave.name = user.displayName;
    userSave.email = user.email;
    userSave.loginType = "Google";
    userSave.imagePath = user.photoUrl;

    sharedPref.save("user", userSave);
    sharedPref.saveBool(isLogin, true);
    sharedPref.save(isLoginType, "Google");

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

  void openSignUp() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
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
    ));
  }
}

/*
Why underscore (_private)? Private means the object is only usable within the file.
Private also means that we can only have one instance of a class.
every time we call a value that is a future (e.g. FirebaseAuth) -> await
Use futures for async functions, use async to mark asynchronous methods
Use await to suspend execution until Future returns a value
when you declare a method with 1 or more await -> async
dart.dev/codelabs/async-await
*/

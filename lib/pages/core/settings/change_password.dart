import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/KeyboardHideView.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';

class ChangePassword extends StatefulWidget {
  //static const String routeName = "/changePassword";
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  bool _saving = false;
  bool passwordHide = true;

  TextEditingController pwInputController,
      newPwInputController,
      cfmNewPwInputController;

  User userSave = User();
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();

    loadSharedPrefs();

    pwInputController = TextEditingController();
    newPwInputController = TextEditingController();
    cfmNewPwInputController = TextEditingController();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _pwFocus = FocusNode();
  final FocusNode _newPwFocus = FocusNode();
  final FocusNode _cfmNewPwFocus = FocusNode();

  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

      setState(() {
        AppGlobal.userLoad = user;
      });
    } catch (Exception) {}
  }

  _changePassword(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Scaffold.of(context).hideCurrentSnackBar();

    if (pwInputController.text.trim().isEmpty) {
      BotToast.showText(text: AppLocalizations.of(context).translate('warning_password1'));
    } else if (newPwInputController.text.trim().isEmpty) {
      BotToast.showText(text: AppLocalizations.of(context).translate('warning_password3'));
    } else if (cfmNewPwInputController.text.trim().isEmpty) {
      BotToast.showText(text: AppLocalizations.of(context).translate('warning_password_confirm'));
    } else if (newPwInputController.text
            .trim()
            .compareTo(cfmNewPwInputController.text.trim()) !=
        0) {
      BotToast.showText(text: AppLocalizations.of(context).translate('warning_password_confirm_err'));
    } else {
      setState(() {
        _saving = true;
      });

      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: AppGlobal.userLoad.email,
              password: pwInputController.text.toString().trim())
          .then((currentUser) {
        _onChangePassword(context);
      }).catchError((err) => throwError(err, context));
    }
  }

  _onChangePassword(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.updatePassword(newPwInputController.text.trim()).then((_) {
      setState(() {
        _saving = false;
      });
      BotToast.showText(text: AppLocalizations.of(context).translate('success_password'));
      Navigator.pop(context);
    }).catchError((error) {
      setState(() {
        _saving = false;
      });
      BotToast.showText(text: AppLocalizations.of(context).translate('fail_password'));
    });
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

  Widget _passwordFields(context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Text(AppLocalizations.of(context).translate('warning_password1')),
            TextFormField(
              controller: pwInputController,
              obscureText: passwordHide,
              keyboardType: TextInputType.visiblePassword,
              maxLines: 1,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onChanged: (text) {},
              focusNode: _pwFocus,
              onFieldSubmitted: (value) {
                _fieldFocusChange(context, _pwFocus, _newPwFocus);
              },
            ),
            SizedBox(
              height: 40,
            ),
            Text(AppLocalizations.of(context).translate('warning_password3')),
            TextFormField(
              controller: newPwInputController,
              obscureText: passwordHide,
              keyboardType: TextInputType.visiblePassword,
              maxLines: 1,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onChanged: (text) {},
              focusNode: _newPwFocus,
              onFieldSubmitted: (value) {
                _fieldFocusChange(context, _newPwFocus, _cfmNewPwFocus);
              },
            ),
            SizedBox(
              height: 40,
            ),
            Text(AppLocalizations.of(context).translate('warning_password_confirm')),
            TextFormField(
              controller: cfmNewPwInputController,
              obscureText: passwordHide,
              keyboardType: TextInputType.visiblePassword,
              maxLines: 1,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              onChanged: (text) {},
              focusNode: _cfmNewPwFocus,
              onFieldSubmitted: (value) {
                _cfmNewPwFocus.unfocus();
              },
            ),
          ],
        ));
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
                          text: AppLocalizations.of(context).translate('edit_password'),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            _passwordFields(context),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                child: Text(AppLocalizations.of(context).translate('edit_password'),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Montserrat")),
                                onPressed: () {
                                  _changePassword(context);
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(20, 13, 20, 13),
                                splashColor: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ],
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

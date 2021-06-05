import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/route.dart';
import 'package:smartmove/common_widgets/text_styles.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/pages/core/settings/change_password.dart';
import 'package:smartmove/pages/core/settings/edit_profile.dart';
import 'package:smartmove/pages/core/settings/mrt_map.dart';
import 'package:smartmove/pages/core/settings/review_favorites.dart';
import 'package:smartmove/pages/core/settings/theme_toggle.dart';
import 'package:smartmove/pages/core/settings/tutorial_simplified.dart';
import 'package:smartmove/pages/signin/sign_in_page.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/services/constant_strings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() {
    return _SettingsPageState();
  }
}

///todo: sign out doesn't function properly when the phone language is set to chinese.
///for now, the alertdialog will be removed.

class _SettingsPageState extends State<SettingsPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  SharedPref sharedPref = SharedPref();

  TextStyle itemTitleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
  );
  TextStyle itemDescStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14.0,
  );

  TextStyle titleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle nameStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  TextStyle emailStyle = TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);

  TextEditingController nameInputController;
  bool _saving = false;
  bool _showChangePasswordBlock = false;

  @override
  void initState() {
    super.initState();

    nameInputController = TextEditingController();
    _showChangePasswordBlock =
        AppGlobal.userLoad.loginType == "Normal" ? true : false;
  }

  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

      setState(() {
        AppGlobal.userLoad = user;
      });
    } catch (Exception) {}
  }

  void navigationWelcomePage() {
    Navigator.of(context).pushReplacement(_createWelcomeRoute());
  }

  Route _createWelcomeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, -1.0);
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

  Future<void> signOutGoogle() async {
    /*final didRequestGoogleSignOut = await PlatformAlertDialog(
      title: "Sign out",
      content: "Are you sure you want to sign out?",
      defaultActionText: "Sign out",
      cancelActionText: "Cancel",
    ).show(context);

    if (didRequestGoogleSignOut == true) {*/
      googleSignIn.signOut();
      print("User Sign Out");
      navigationWelcomePage();
    //}
  }

  ///todo: remove or review platformalertdialog
  Future<void> signOutNormal() async {
    /*final didRequestSignOut = await PlatformAlertDialog(
      title: "Sign out",
      content: "Are you sure you want to sign out?",
      defaultActionText: "Sign out",
      cancelActionText: "Cancel",
    ).show(context);

    if (didRequestSignOut == true) {*/
      FirebaseAuth.instance.signOut();
      print("User Sign Out");
      navigationWelcomePage();
    //}
  }

  /*void navigationChangePasswordPage() {
    Navigator.of(context).push(_createChangePasswordRoute());
  }

  Route _createChangePasswordRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChangePassword(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }*/

  void navigationChangeProfilePage() {
    Navigator.of(context).push(_createChangeProfileRoute()).then((onValue) {
      loadSharedPrefs();
    });
  }

  //provides L-R-L transition animations
  Route _createChangeProfileRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EditProfile(),
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
        child: Center(
          child: Column(
            children: <Widget>[
              SafeArea(
                child: Text(
                  AppLocalizations.of(context)
                      .translate('appbar4'),
                  style: menuBar(context),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: MediaQuery.of(context).copyWith().size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 5, 10),
                      child: Row(
                        children: <Widget>[
                          (AppGlobal.userLoad.imagePath.isEmpty ||
                                  AppGlobal.userLoad.imagePath == null)
                              ? Image(
                                  image: AssetImage(
                                      "assets/assetimages/ic_user_with_circle.png"),
                                  height: 55,
                                  width: 55,
                                )
                              : Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          AppGlobal.userLoad.imagePath),
                                    ),
                                  ),
                                ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppGlobal.userLoad.name,
                                  style: nameStyle,
                                ),
                                Text(
                                  AppGlobal.userLoad.email,
                                  style: emailStyle,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          //color: Colors.blueGrey,
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                            child: TileButton(
                              onTap: () {
                                navigationChangeProfilePage();
                              },
                              text: AppLocalizations.of(context)
                                  .translate('edit_profile'),
                              icon: Icons.tag_faces_outlined,
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TileButton(
                                    text: AppLocalizations.of(context)
                                        .translate('edit_password'),
                                    icon: Icons.devices,
                                    onTap: () => Routing.openRoute(
                                        context, ChangePassword()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                            child: ThemeToggleList(),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                            child: TileButton(
                              text: AppLocalizations.of(context)
                                  .translate('view_favorites'),
                              icon: FontAwesomeIcons.star,
                              onTap: () => Routing.openRoute(
                                  context, ReviewFavoritesPage()),
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                            child: TileButton(
                              text: AppLocalizations.of(context)
                                  .translate('view_tutorial'),
                              icon: FontAwesomeIcons.stickyNote,
                              onTap: () => Routing.openRoute(
                                  context, TutorialSimplified()),
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                            child: TileButton(
                              text: AppLocalizations.of(context)
                                  .translate('view_mrt'),
                              icon: FontAwesomeIcons.train,
                              onTap: () =>
                                  Routing.openRoute(context, MRTMapPage()),
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                            child: TileButton(
                              text: AppLocalizations.of(context)
                                  .translate('sign_out'),
                              icon: Icons.power_settings_new_rounded,
                              onTap: () {
                                sharedPref.saveBool(isLogin, false);
                                User user = User();
                                sharedPref.save("user", user);
                                AppGlobal.flutterLocalNotificationsPlugin
                                    .cancelAll();
                                if (AppGlobal.userLoad.loginType
                                        .compareTo("Normal") ==
                                    0) {
                                  signOutNormal();
                                } else {
                                  signOutGoogle();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

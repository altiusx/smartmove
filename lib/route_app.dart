import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/status_bar_color.dart';

import 'app_localizations.dart';
import 'package:smartmove/common_widgets/bounce_scroll.dart';
import 'package:smartmove/common_widgets/theme.dart';
import 'package:smartmove/home_page.dart';
import 'package:smartmove/models/theme_enum.dart';
import 'package:smartmove/pages/signin/register_page.dart';
import 'package:smartmove/pages/signin/sign_in_page.dart';
import 'package:smartmove/splashview.dart';
import 'package:smartmove/tutorial.dart';

//chinese (zh) config

class RouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, box, widget) {
          final theme = box.get('theme', defaultValue: ThemeEnum.light);
          //check if this is the first time using the app
          final settingsBox = Hive.box('settings');
          bool firstLaunch =
              settingsBox.get('first_launch', defaultValue: true);

          //show instructions if first launch, if not splashview.
          //Home page will NOT work. getter name called on null error.
          Widget home = firstLaunch ? Tutorial() : SplashView();

          ThemeData darkTheme;
          ThemeData regTheme;

          //set the darktheme to dark only if following system theme
          if (theme == ThemeEnum.system) {
            darkTheme = appDarkTheme;
            regTheme = appLightTheme;
          } else {
            regTheme = theme == ThemeEnum.light ? appLightTheme : appDarkTheme;
          }

          return BotToastInit(
            child: MaterialApp(

              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
                supportedLocales: [
                  const Locale('en', 'SG'),
                  const Locale('zh', 'SG'),
                ],
                // Returns a locale which will be used by the app
                localeResolutionCallback: (locale, supportedLocales) {
                  // Check if the current device locale is supported
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  // If the locale of the device is not supported, use the first one
                  // from the list (English, in this case).
                  return supportedLocales.first;
                },

                title: 'Smartmove',
                debugShowCheckedModeBanner: false,
                darkTheme: darkTheme,
                theme: regTheme,
                home: Builder(
                  builder: (BuildContext context) {
                    return ScrollConfiguration(
                      behavior: BounceScrollBehavior(),
                      child: _buildHome(context, home),
                    );
                  },
                ),
                navigatorObservers: [
                  BotToastNavigatorObserver()
                ],
                routes: <String, WidgetBuilder>{
                  SignInPage.routeName: (BuildContext context) => SignInPage(),
                  RegisterPage.routeName: (BuildContext context) =>
                      RegisterPage(),
                  HomePage.routeName: (BuildContext context) => HomePage(),
                }),
          );
        });
  }

  Widget _buildHome(BuildContext context, Widget home) {
    setStatusBarColor(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, widget) {
        return home;
      },
    );
  }
}

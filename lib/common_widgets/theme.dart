import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

final ThemeData appLightTheme = _buildLightTheme();
final ThemeData appDarkTheme = _buildDarkTheme();

///will eventually adopt this

TextTheme _buildTextTheme(TextTheme base, Color primaryColor, {bool dark = false}) {
  double em = Values.em;

  return base.copyWith(
    // title: base.title.copyWith(
    //   fontWeight: FontWeight.w900,
    //   fontSize: 1.8 * em,
    //   letterSpacing: 0.7,
    //   color: Colors.black,
    // ),

    // maybe only change title to Rubik>
    headline6: GoogleFonts.rubik(
      textStyle: base.headline6.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 1.7 * em,
        letterSpacing: 0.7,
        // color for lighter white so that it's not too hard on the eyes
        color: dark ? Color(0xccFFFFFF) : Colors.black,
      ),
    ),

    // bus stop names
    headline4: base.headline4.copyWith(
      fontWeight: FontWeight.w700,
      color: dark ? Colors.white70 : Colors.black87,
      fontSize: em,
    ), // bus stop code
    headline3: base.headline3.copyWith(
      color: dark ? Colors.white60 : Colors.black54,
      fontSize: 0.8 * em,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    // bus numbers
    headline2: base.headline3.copyWith(
      color: dark ? Colors.white70 : Colors.black87,
      fontSize: 0.9 * em,
      fontWeight: FontWeight.w600,
    ),
    // time in min
    headline1: base.headline2.copyWith(
      color: dark ? Colors.white70 : Colors.black87,
      fontSize: 0.85 * em,
      fontWeight: FontWeight.w400,
    ),

    // buttons
    button: GoogleFonts.rubik(
      textStyle: base.button.copyWith(
        color: primaryColor,
        fontSize: 0.85 * em,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),

    // bottom sheet text for confirmations?
    bodyText1: base.bodyText1.copyWith(
      fontSize: em,
      fontWeight: FontWeight.w500,
      color: dark ? Colors.white70 : Colors.black87,
    ),

    // default font
    bodyText2: base.bodyText2.copyWith(
      fontSize: em,
      fontWeight: FontWeight.w400,
      color: dark ? Colors.white70 : Colors.black87,
    ),
  );
}

Color primaryColor = Colors.indigo;
Color primaryColorDark = Colors.indigo[400];

// so that there are no lines above/below expansiontile
Color dividerColor = Colors.transparent;

// for timings not available box
Color errorColor = Colors.red;

// for better back transition
PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    accentColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    toggleableActiveColor: primaryColor,
    dividerColor: dividerColor,
    errorColor: errorColor,
  );

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme, primaryColor),
    pageTransitionsTheme: _pageTransitionsTheme,
  );
}

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    accentColor: primaryColorDark,
    scaffoldBackgroundColor: Color(0xFF121212),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    toggleableActiveColor: primaryColor,
    dividerColor: dividerColor,
    errorColor: errorColor,
  );

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme, primaryColor, dark: true),
    pageTransitionsTheme: _pageTransitionsTheme,
  );
}

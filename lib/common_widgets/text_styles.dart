import 'package:flutter/material.dart';

TextStyle bodyTextStyle(BuildContext context, bool dark) =>
    Theme.of(context).textTheme.bodyText2.copyWith(
          color: dark ? Color(0xffaaaaaa) : Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        );

TextStyle titleTextStyle(BuildContext context, bool dark) =>
    Theme.of(context).textTheme.headline6.copyWith(
          color: dark ? Colors.white : Colors.black,
        );

TextStyle buttonTextStyle(context) =>
    Theme.of(context).textTheme.bodyText2.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        );
TextStyle doneButtonTextStyle(context) =>
    Theme.of(context).textTheme.bodyText2.copyWith(
          color: Colors.white70,
          fontWeight: FontWeight.w700,
        );

TextStyle signInGreeting(context) =>
    Theme.of(context).textTheme.headline6.copyWith(
          fontFamily: "Montserrat",
          fontSize: 20.0,
        );

TextStyle menuBar(context) =>
    Theme.of(context).textTheme.headline5.copyWith(
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    );

TextStyle fieldsTextStyle(context) =>
    Theme.of(context).textTheme.bodyText2.copyWith(
          fontSize: 16.0,
        );

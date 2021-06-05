import 'package:flutter/material.dart';

class KeyboardHideView extends StatelessWidget {
  final Widget child;

  KeyboardHideView({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child:this.child,
    );
  }
}
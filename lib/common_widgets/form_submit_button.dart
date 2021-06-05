import 'package:flutter/material.dart';
import 'package:smartmove/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.green,
          borderRadius: 8.0,
          onPressed: onPressed,
        );
}

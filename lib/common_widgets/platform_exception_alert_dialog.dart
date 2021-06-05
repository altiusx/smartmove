import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:smartmove/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
      title: title,
      content: _message(exception),
      defaultActionText: 'OK'
  );

  static String _message(PlatformException exception) {
    if (exception.message == "FIRFirestoreErrorDomain") {
      if (exception.code == 'Error 7') {
        return 'Missing or insufficient permissions';
      }
    }
    return _errors[exception.code] ?? exception.message;
  } //find a message that corresponds to the error code below

  static Map<String, String> _errors = {
    ///'ERROR_INVALID_CREDENTIAL' : ''
    'ERROR_USER_NOT_FOUND' : 'This user does not exist.',
    'ERROR_INVALID_EMAIL' : 'The email address is not formatted correctly.',
    'ERROR_EMAIL_ALREADY_IN_USE' : 'There is already an account created with this email.',
    'ERROR_WRONG_PASSWORD': 'The password is incorrect or invalid.',
  };
}

/*We can reuse this dialog to show any errors from firebase! even outside this project
We only need 4 lines of code to show one:
PlatformExceptionAlertDialog(
        title: 'Sign in failure',
        exception: e,
      ).show(context);
 */
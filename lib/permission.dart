import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/route.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/common_widgets/title_text.dart';
import 'package:smartmove/pages/core/travel/location_permission.dart';
import 'package:smartmove/pages/core/travel/themes/page_template.dart';
import 'package:smartmove/pages/core/travel/themes/travel_button.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';
import 'package:smartmove/splashview.dart';

class PermissionRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      children: <Widget>[
        Column(
          children: <Widget>[
            TitleText(title: AppLocalizations.of(context).translate('tut_permissions1')),
            Spacing(height: Values.marginBelowTitle),
            MarkdownBody(
                data:
                AppLocalizations.of(context).translate('tut_permissions2')),
            Spacing(height: Values.marginBelowTitle),
            _RequestPermissionButton(),
            Spacing(height: Values.marginBelowTitle),
            _OpenSettingsButton(),
          ],
        ).sliverToBoxAdapter(),
      ],
    ).scaffold();
  }
}

class _RequestPermissionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TravelButton(
      text: AppLocalizations.of(context).translate('login_button'),
      onTap: () async {
        var status = await LocationPermsProvider.requestPerm();

        if (status == PermissionStatus.granted) {
          print("Location permission given");
          BotToast.showText(
              text: "Thank you for giving permissions!",
              contentColor: Theme.of(context).accentColor);

          var settingsBox = Hive.box('settings');
          settingsBox.put('first_launch', false);

          Routing.openFullScreenDialog(context, SplashView());
        } else {
          print("Location permission NOT GIVEN");

          // should not be able to leave this screen if no location permissions given
          BotToast.showText(
              text: "Location permissions required for app!",
              contentColor: Theme.of(context).errorColor);
        }
      },
    );
  }
}

class _OpenSettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TravelButton(
        text: "Open location settings",
        onTap: () {
          LocationPermsProvider.openSettings();
        },
        color: Colors.grey,
      ),
    );
  }
}

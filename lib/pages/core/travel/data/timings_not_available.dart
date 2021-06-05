import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/common_widgets/strings.dart';
import 'package:smartmove/pages/core/travel/themes/bottom_sheet_template.dart';
import 'package:smartmove/pages/core/travel/themes/travel_button.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';
import 'package:styled_widget/styled_widget.dart';

class TimingsNotAvailable extends StatelessWidget {
  final List services;
  TimingsNotAvailable({this.services});

  @override
  Widget build(BuildContext context) {
    String displayString = "";
    for (var s in services) {
      displayString += "$s, ";
    }

    // remove the last comma and space because AttEntIon tO deTaIL
    displayString = displayString.substring(0, displayString.length - 2);

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          bottom: Values.marginBelowTitle,
          left: Values.busServiceTilePadding,
          right: Values.busServiceTilePadding,
        ),
        padding: EdgeInsets.all(Values.busServiceTilePadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Values.borderRadius * 0.8),
            color: Theme.of(context).errorColor.withOpacity(Values.containerOpacity)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('no_op'),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).errorColor,
                  ),
                ).padding(bottom: 5),
                // CustomIconButton(
                //   icon: FontAwesomeIcons.info,
                //   size: Theme.of(context).textTheme.body2.fontSize,
                //   color: Theme.of(context).errorColor,
                // )
              ],
            ),
            Text(
              displayString,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).errorColor,
              ),
            ).alignment(Alignment.topLeft)
          ],
        ),
      ),
      onTap: () => showBottomSheet(context),
    );
  }

  showBottomSheet(BuildContext context) => bottomSheetTemplate(
    context,
    children: <Widget>[
      MarkdownBody(data: Strings.timingsNotAvailableInfo),
      Spacing(height: 20),
      TravelButton(
        iconData: FontAwesomeIcons.check,
        text: "Okay",
        color: Theme.of(context).primaryColor,
        onTap: () => closeBottomSheet(context),
      ).width(120).alignment(Alignment.bottomRight)
    ],
  );
}

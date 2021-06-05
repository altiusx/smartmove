import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class TravelBackButton extends StatelessWidget {
  // true if the page is a cupertino full screen dialog (mrt page)
  // so the chevron points downwards, and text is "done" instead of "back"
  final bool fullScreen;
  final bool x;
  TravelBackButton({this.fullScreen = false, this.x = false});

  @override
  Widget build(BuildContext context) {
    final IconData icon = x
        ? FontAwesomeIcons.times
        : (fullScreen
            ? FontAwesomeIcons.chevronDown
            : FontAwesomeIcons.chevronLeft);
    final String text = x
        ? ""
        : (fullScreen
            ? AppLocalizations.of(context).translate('tasks_complete')
            : AppLocalizations.of(context).translate('back'));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(1000.0),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(Values.containerOpacity - 0.05),
              borderRadius: BorderRadius.circular(1000.0)),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Padding(
                // if has the x, not padding
                padding: x ? EdgeInsets.all(0.0) : EdgeInsets.only(right: 10.0),
                child: Icon(icon, size: 15),
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/tile_button.dart';
import 'package:smartmove/models/theme_enum.dart';
import 'package:smartmove/pages/core/travel/themes/tile_colors.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';
import 'package:smartmove/theme.dart';

// had to convert this to stateful so it rebuilds itself
class ThemeToggleList extends StatefulWidget {
  @override
  _ThemeToggleListState createState() => _ThemeToggleListState();
}

class _ThemeToggleListState extends State<ThemeToggleList> {
  @override
  Widget build(BuildContext context) {
    return TileButton(
      text: AppLocalizations.of(context).translate('edit_theme'),
      icon: FontAwesomeIcons.moon,
      children: <Widget>[
        _option(context, AppLocalizations.of(context).translate('light'),
            ThemeEnum.light),
        _option(context, AppLocalizations.of(context).translate('dark'),
            ThemeEnum.dark),
        _option(context, AppLocalizations.of(context).translate('system'),
            ThemeEnum.system),
      ],
    );
  }

  Widget _option(BuildContext context, String text, ThemeEnum themeEnum) =>
      InkWell(
        borderRadius: BorderRadius.circular(Values.borderRadius / 2),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Values.marginBelowTitle,
              vertical: Values.marginBelowTitle / 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Values.borderRadius / 2),
            color: ThemeService.getThemeEnum() == themeEnum
                ? Theme.of(context).primaryColor
                : TileColors.busServiceTile(context),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: Values.em * 0.8,
                  // change font weight depending on which theme is selected
                  fontWeight: ThemeService.getThemeEnum() == themeEnum
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: ThemeService.getThemeEnum() == themeEnum
                      ? Colors.white70
                      : Theme.of(context).textTheme.bodyText2.color,
                ),
          ),
        ),
        onTap: () =>
            // rebuild widget
            setState(() => ThemeService.setTheme(context, themeEnum)),
      );
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/pages/core/travel/providers/page_rebuilder.dart';
import 'package:smartmove/pages/core/travel/services/rename_favorites.dart';
import 'package:smartmove/pages/core/travel/themes/bottom_sheet_template.dart';
import 'package:smartmove/pages/core/travel/themes/travel_button.dart';

class RenameFavoritesBottomSheets {
  static bs(context, code, name) {
    String currentName = RenameFavoritesService.getName(code);
    // if there area already is a current name, keep that here
    TextEditingController controller =
    TextEditingController(text: currentName == null ? "" : currentName);
    return bottomSheetTemplate(
      context,
      children: <Widget>[
        MarkdownBody(data: AppLocalizations.of(context).translate('rename_bottom_sheet1')
            + "\n\n" +AppLocalizations.of(context).translate('rename_bottom_sheet2')
            + "\n\n**$name** ($code)."),
        Spacing(height: 15),
        TextField(
          decoration: InputDecoration(
            hintText: name,
          ),
          controller: controller,
        ),
        Spacing(height: 15),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TravelButton(
              text: AppLocalizations.of(context).translate('dismiss'),
              iconData: FontAwesomeIcons.times,
              color: Colors.red,
              onTap: () => closeBottomSheet(context),
            ),
            TravelButton(
              text: AppLocalizations.of(context).translate('tasks_complete'),
              iconData: FontAwesomeIcons.check,
              onTap: () {
                String newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  print("Changing name");
                  RenameFavoritesService.rename(context, code, newName);
                } else {
                  print("Empty string provided, resetting rename");
                  RenameFavoritesService.deleteRename(code);
                }

                // rebuild stop overview page to reflect rename
                closeBottomSheet(context);
                Provider.of<PageRebuilderProvider>(context, listen: false).rebuild();
              },
            ),
          ],
        ),

      ],
    );
  }
}

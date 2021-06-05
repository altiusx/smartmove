import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/pages/core/travel/providers/favorites.dart';
import 'package:smartmove/pages/core/travel/themes/page_template.dart';

import 'favorites_list.dart';

class AllFavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      showBackButton: true,
      children: [
        FavoritesBusStopList(
          title:
          "${AppLocalizations.of(context).translate('favorites_bar')} (${FavoritesProvider.getNoFavorites()})",
          iconData: FontAwesomeIcons.heart,
          simplified: false,

          // not required here, just set it to 0
          favoritesNotShown: 0,
        ),
      ],
    ).scaffold();
  }
}
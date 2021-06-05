import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/pages/core/travel/data/bus_stop.dart';
//import 'package:smartmove/common_widgets/strings.dart';
import 'package:smartmove/pages/core/travel/providers/favorites.dart';
import 'package:smartmove/pages/core/travel/themes/error_container.dart';
import 'package:smartmove/pages/core/travel/themes/page_template.dart';
import 'package:smartmove/pages/core/travel/themes/rename_fav_bottom_sheet.dart';
import 'package:smartmove/pages/core/travel/themes/tile_colors.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class ReviewFavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FavoritesProvider.getFavorites(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData)
            return PageTemplate(
              showBackButton: true,
              children: [
                Spacing(height: 10).sliver(),
                MarkdownBody(
                  data: AppLocalizations.of(context).translate('rename_favorites_prompt'),
                ).sliverToBoxAdapter(),
                Spacing(height: 20).sliver(),

                if (snapshot.data.isEmpty) ...[
                  ErrorContainer(
                    text: AppLocalizations.of(context).translate('no_favorites')
                  ).sliverToBoxAdapter(),
                  Spacing(height: 20).sliver(),
                ],

                for (var bs in snapshot.data)
                // Text('bus stop fav').sliverToBoxAdapter()
                  GestureDetector(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: Values.marginBelowTitle),
                        child: _busStopTile(context, bs)),
                    onTap: () => _changeDisplayNameBottomSheet(context, bs.code, bs.name),
                  ).sliverToBoxAdapter(),

                // text below
                MarkdownBody(
                  data: AppLocalizations.of(context).translate('rename_favorites_prompt2'),
                ).sliverToBoxAdapter(),

                // display all favorites
              ],
            );
          else
            return Text(AppLocalizations.of(context).translate('loading'));
        },
      ),
    );
  }

  _changeDisplayNameBottomSheet(BuildContext context, String code, String name) =>
  RenameFavoritesBottomSheets.bs(context, code, name);

  Widget _busStopTile(BuildContext context, BusStop bs) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: Values.busStopTileHorizontalPadding,
      vertical: Values.busStopTileVerticalPadding,
    ),
    decoration: BoxDecoration(
      color: TileColors.busStopExpansionTile(context),
      borderRadius: BorderRadius.circular(Values.borderRadius),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "${bs.name}",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Text(
          "${bs.code}",
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    ),
  );
}

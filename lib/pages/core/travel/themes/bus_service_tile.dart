import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/common_widgets/route.dart';
import 'package:smartmove/pages/core/search/service/service_page.dart';
import 'package:smartmove/pages/core/travel/data/bus_arrival.dart';
import 'package:smartmove/pages/core/travel/providers/favorites.dart';
import 'package:smartmove/pages/core/travel/themes/tile_colors.dart';
import 'package:smartmove/pages/core/travel/themes/transit_colors.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class BusServiceTile extends StatelessWidget {
  final String code;
  final String service;
  final BusArrival busArrival;
  BusServiceTile({this.code, this.service, this.busArrival});

  @override
  Widget build(BuildContext context) {
    // the load can be SEA, SDA, or LSD (green, orange, red)
    Map loadColors = {
      "SEA": TransitColors.seats,
      "SDA": TransitColors.standing,
      "LSD": TransitColors.limited,
    };

    final FavoritesProvider favoritesProvider =
    Provider.of<FavoritesProvider>(context, listen: true);
    bool isFavorite = FavoritesProvider.alreadyInFavorites(code, service);

    ///todo: maybe change it to tap to like instead of slidable
    return Slidable(
      closeOnScroll: true,
      key: ObjectKey(service),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        _actionTemplate(
          context,

          // show different icon and color if it's in favorite
          isFavorite ? FontAwesomeIcons.heartBroken : FontAwesomeIcons.heart,
          isFavorite ? Theme.of(context).errorColor : Theme.of(context).accentColor,

          // below function adds or remove favorites depending on if it's already
          // favorited
              () => favoritesProvider.addToFavorite(context, code, service),
        )
      ],
      child: Container(
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(Values.busStopTileHorizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () => Routing.openRoute(context, ServicePage(service: service)),
                    child: Text(
                      service,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      for (var nextBus in busArrival.nextBuses)
                        Text(
                          nextBus.timeInMinutes ?? '-',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: loadColors[nextBus.load],

                              // bold text if it has arrived
                              fontWeight: nextBus.timeInMinutes == "Arr"
                                  ? FontWeight.w900
                                  : FontWeight.w400),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          borderRadius: BorderRadius.circular(Values.borderRadius * 0.8),
          // onTap: () => ConfirmationBottomSheets.confirmAction(context, code, service),
          onTap: () => Routing.openRoute(
            context,
            ServicePage(service: service),
          ),

        ),
        margin: EdgeInsets.only(
          left: Values.pageHorizontalPadding,
          right: Values.pageHorizontalPadding,
          bottom: Values.pageHorizontalPadding,
        ),
        decoration: BoxDecoration(
          color: TileColors.busServiceTile(context),
          borderRadius: BorderRadius.circular(Values.borderRadius * 0.8),
        ),
      ),
    );
  }

  Widget _actionTemplate(
      BuildContext context,
      IconData icon,
      Color color,
      Function action,
      ) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          left: Values.pageHorizontalPadding,
          right: Values.pageHorizontalPadding,
          bottom: Values.pageHorizontalPadding,
        ),
        decoration: BoxDecoration(
          // color: TileColors.busServiceTile(context),
          color: color,
          borderRadius: BorderRadius.circular(Values.borderRadius * 0.8),
        ),
        padding: EdgeInsets.all(Values.marginBelowTitle),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      onTap: action,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smartmove/common_widgets/route.dart';
import 'package:smartmove/pages/core/search/bus_stops/bus_stop_overview.dart';
import 'package:smartmove/pages/core/travel/data/mrt_stations.dart';
import 'package:smartmove/pages/core/travel/themes/tile_colors.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class BusStopButton extends StatelessWidget {
  const BusStopButton({@required this.code, @required this.name, @required this.mrtStations});
  final String code;
  final String name;
  final List mrtStations;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Values.marginBelowTitle / 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(Values.borderRadius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Values.busStopTileHorizontalPadding,
            vertical: Values.busStopTileVerticalPadding / 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Values.borderRadius),
            color: TileColors.busServiceTile(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      // "namenamenamenamenamenamename",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (mrtStations.isNotEmpty) MRTStations(stations: mrtStations),
                  ],
                ),
              ),

              // The ID's should always be there
              Expanded(
                flex: 0,
                child: InkWell(
                  // onLongPress: () => openMap(lon, lat),
                  child: Text(
                    code,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () => Routing.openRoute(context, StopOverviewPage(code: code)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/pages/core/travel/themes/bus_stop_button.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class ServiceRoute extends StatelessWidget {
  const ServiceRoute({Key key, @required this.route}) : super(key: key);
  final Map route;

  @override
  Widget build(BuildContext context) {

    print(route['stops']);

    List<Widget> children = [
      // spacing at top
      Spacing(height: Values.marginBelowTitle),

      Text(
        route["name"].trim(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: Values.em * 1.5),
      ),

      for (var busStop in route["stops"])
        BusStopButton(
          code: busStop["code"],
          name: busStop["name"],
          mrtStations: busStop["mrt_stations"],
        ),

      // spacing at end of route
      Spacing(height: Values.marginBelowTitle),
    ];

    return Column(children: children).sliverToBoxAdapter();
  }
}

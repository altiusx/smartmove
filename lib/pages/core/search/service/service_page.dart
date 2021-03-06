import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/common_widgets/title_text.dart';
import 'package:smartmove/pages/core/search/service/service_route.dart';
import 'package:smartmove/pages/core/travel/loading_screen.dart';
import 'package:smartmove/pages/core/travel/providers/bus_service_provider.dart';
import 'package:smartmove/pages/core/travel/themes/page_template.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class ServicePage extends StatelessWidget {
  final String service;
  ServicePage({this.service});

  final Map serviceTypes = {
    "0": "Loop",
    "1": "One-way",
    "2": "Two-way",
  };

  // gets the routes for the service provided
  Future getRoutes(context) async {
    String servicesJsonString = await rootBundle.loadString('assets/services.json');
    Map serviceData = json.decode(servicesJsonString)[service];

    Map stopData = await Provider.of<BusServiceProvider>(context, listen: false).getAllStopsMap();

    /*
    Changing route array from <int>[] to <Map>[]
    with code, name, mrt_stations
    */
    for (var route in serviceData["routes"]) {
      List newStops = [];
      for (var stopNo in route["stops"]) {
        print(stopData[stopNo]);
        newStops.add(
          {
            "code": stopNo,
            "name": stopData[stopNo]["name"],
            "mrt_stations": stopData[stopNo]["mrt_stations"],
          },
        );
      }

      route["stops"] = newStops;
    }

    return serviceData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRoutes(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return PageTemplate(
          showBackButton: true,
          children: [
            TitleText(title: "Bus $service").sliverToBoxAdapter(),
            if (snapshot.hasData)
              Text(serviceTypes[snapshot.data["type"]]).sliverToBoxAdapter(),
            Spacing(
              height: Values.marginBelowTitle,
            ).sliver(),

            // all the services
            if (snapshot.hasData)

            // looping through the routes
              for (var route in snapshot.data["routes"]) ServiceRoute(route: route)
            else
              LoadingText(text: "Getting bus data ...").sliverToBoxAdapter()
          ],
        ).scaffold();
      },
    );
  }
}

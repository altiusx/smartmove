import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/common_widgets/title_text.dart';
import 'package:smartmove/pages/core/travel/bus_stop_expansion_tile.dart';
import 'package:smartmove/pages/core/travel/data/mrt_stations.dart';
import 'package:smartmove/pages/core/travel/providers/bus_service_provider.dart';
import 'package:smartmove/pages/core/travel/providers/page_rebuilder.dart';
import 'package:smartmove/pages/core/travel/services/url.dart';
import 'package:smartmove/pages/core/travel/themes/page_template.dart';
import 'package:smartmove/pages/core/travel/themes/rename_fav_bottom_sheet.dart';
import 'package:smartmove/pages/core/travel/themes/travel_button.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';
import 'package:smartmove/pages/core/search/bus_stops/stop_services_overview.dart';

class StopOverviewPage extends StatelessWidget {
  final String code;
  StopOverviewPage({this.code});

  @override
  Widget build(BuildContext context) {
    // here just to rebuild page on stop rename
    final PageRebuilderProvider pageRebuilderProvider =
    Provider.of<PageRebuilderProvider>(context, listen: true);

    return Scaffold(
      body: FutureBuilder(
        future: _getStopData(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String name = snapshot.data['name'];
            String road = snapshot.data['road'];
            List services = snapshot.data['services'];
            List mrtStations = snapshot.data['mrt_stations'];
            double lat = snapshot.data['coords']['lat'];
            double lon = snapshot.data['coords']['lon'];

            return PageTemplate(
              showBackButton: true,
              children: [
                // name of bus stop
                TitleText(
                  title: name,
                ).sliverToBoxAdapter(),

                Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  // road and stop code
                  Text("$road – $code"),

                  if (mrtStations.isNotEmpty) ...[
                    Spacing(height: Values.marginBelowTitle),
                    MRTStations(
                      stations: mrtStations,
                    ),
                  ],

                  Spacing(height: Values.marginBelowTitle * 1.5),

                  // // showing all services
                  StopServicesOverview(
                    services: services,
                  ),

                  Spacing(height: Values.marginBelowTitle * 2),
                  // button to allow rename
                  TravelButton(
                    text: AppLocalizations.of(context).translate('rename'),
                    iconData: FontAwesomeIcons.edit,
                    // onTap: () => RenameFavoritesService.rename(context, code, newName),
                    onTap: () => RenameFavoritesBottomSheets.bs(context, code, name),
                  ),

                  Spacing(height: Values.marginBelowTitle),

                  // // showing directions
                  TravelButton(
                    text: AppLocalizations.of(context).translate('directions'),
                    fill: true,
                    iconData: FontAwesomeIcons.directions,
                    onTap: () => openMap(lon, lat),
                  ),

                  Spacing(height: Values.marginBelowTitle * 1.5),

                  // // timings panel
                  // Text("Bus arrival timings:"),
                  BusStopExpansionPanel(
                    name: name,
                    code: code,
                    services: services,
                    initiallyExpanded: true,

                    // don't show mrt stations even if there are a view, because they're shown above
                    mrtStations: [],

                    // tapping on the ID should NOT OPEN a new version of the same page
                    opensStopOverviewPage: false,
                  ),
                ]).sliverToBoxAdapter()
              ],
            );
          } else {
            return Text('Loading');
          }
        },
      ),
    );
  }

  _getStopData(context) async {
    Map stopData =
    (await Provider.of<BusServiceProvider>(context, listen: false).getAllStopsMap())[code];

    // print(stopData);
    return stopData;
  }
}

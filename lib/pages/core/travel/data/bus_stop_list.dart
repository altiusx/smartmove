import 'package:flutter/material.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/common_widgets/title_text.dart';
import 'package:smartmove/pages/core/travel/bus_stop_expansion_tile.dart';
import 'package:smartmove/common_widgets/strings.dart';
import 'package:smartmove/pages/core/travel/loading_screen.dart';
import 'package:smartmove/pages/core/travel/providers/bus_service_provider.dart';
import 'package:smartmove/pages/core/travel/themes/error_container.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class BusStopList extends StatelessWidget {
  final String title;
  final IconData iconData;
  //final Widget busWidget;

  /*
  This widget is used for NEAR ME and all the favorites
  on the main page, we can see NEAR ME and a simplified favorites view.
    - simplified favorites view only shows the favorites buses in under their bus stops
      if the user is near that bus stop

  all favorites are only shown on the tap of a button
  */

  // 'near' and 'favorites'
  BusStopList({this.title, this.iconData});

  @override
  Widget build(BuildContext context) {
    // only require widget rebuilding for favorites for the favorites list
    // required to add/remove bus services

    return FutureBuilder(
      // get stops near me or favorites
      future: Provider.of<BusServiceProvider>(context, listen: false).getNearestStops(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Widget> children = <Widget>[
          if (snapshot.hasData)
            if (snapshot.data.isNotEmpty)
              for (var busStop in snapshot.data)
                BusStopExpansionPanel(
                  name: busStop.name,
                  code: busStop.code,
                  services: busStop.services,
                  initiallyExpanded: false,
                  position: busStop.position,
                  mrtStations: busStop.mrtStations,
                )
            else
            // no stops near me
              ...[
                Spacing(height: Values.marginBelowTitle),
                ErrorContainer(text: Strings.noStopsNearby),
              ]
          else
          // placeholder widgets while stops are loading
            ...[
              Spacing(height: Values.marginBelowTitle),
              LoadingText(text: AppLocalizations.of(context).translate('bus_stop_location')),
            ]
        ];

        // TODO: find a way to put a slight animation
        // so users can see each bus stop being "added" nicely
        // heading (near me/favorites)

        // bus stop tile list
        // column needed because otherwise widgets disappear before being scrolled away

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleText(
              title: title,
              iconData: iconData,
              //busWidget: busWidget,
            ),
            ...children,
          ],
        ).sliverToBoxAdapter();
      },
    );
    // }
  }
// each tile has a top margin (15)
}

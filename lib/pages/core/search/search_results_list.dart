import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/pages/core/search/bus_stops/bus_stop_result_tile.dart';
import 'package:smartmove/pages/core/search/providers/search_provider.dart';
import 'package:smartmove/pages/core/travel/themes/tile_colors.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchProvider searchProvider = Provider.of<SearchProvider>(context);

    List searchResults = searchProvider.getSearchResults();

    // show nearest stops if no search term
    // if (searchResults.isEmpty) searchProvider.getNearestBusStopSearchResults(context);

    return Column(
      children: <Widget>[
        // if (searchResults.isEmpty) LoadingText(text: "Start searching ..."),
        // if (searchResults.isEmpty) nothingSearched(context),
        for (var busStop in searchResults)
        // Text("A search result will come here.")
          BusStopSearchResultTile(
            name: busStop.name,
            code: busStop.code,
            mrtStations: busStop.mrtStations,
          ),
      ],
    );
  }

  Widget nothingSearched(BuildContext context) => Container(
      decoration: BoxDecoration(color: TileColors.busStopExpansionTile(context)),
      child: Text("You haven't searched for anything"));
}

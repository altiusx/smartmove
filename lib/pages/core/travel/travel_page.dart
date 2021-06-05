import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:smartmove/app_localizations.dart';
//import 'package:smartmove/common_widgets/route.dart';
//import 'package:smartmove/app_localizations.dart';
//import 'package:smartmove/common_widgets/text_styles.dart';
import 'package:smartmove/models/quick_actions.dart';
//import 'package:smartmove/pages/core/search/search.dart';
import 'package:smartmove/pages/core/travel/data/bus_stop_list.dart';
import 'package:smartmove/pages/core/travel/favorites_list.dart';
import 'package:smartmove/pages/core/travel/providers/favorites.dart';
import 'loading_screen.dart';
import 'themes/travel_button.dart';
import 'themes/values.dart';
import 'providers/bus_service_provider.dart';
import 'providers/location.dart';
import 'themes/page_template.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/spacing.dart';
//import '../../../common_widgets/strings.dart';
import 'providers/page_rebuilder.dart';

class TravelPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // this is there to rebuild the home page when required (reloading)
    final PageRebuilderProvider pageRebuilderProvider =
        Provider.of<PageRebuilderProvider>(context, listen: true);

    // slide to refresh
    // RefreshController _refreshController = RefreshController(initialRefresh: false);

    ///todo: find to see how to make this work on iOS
    if (Platform.isAndroid) {
      QuickActions quickActions = QuickActions();
      setupQA(context, quickActions);
    }

    /*Route _searchRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      );
    }

    void navigationSearchPage() {
      Navigator.of(context).push(_searchRoute());
    }*/

    return FutureBuilder(
      future: getHomeWidgets(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                // wait for the function to execute
                await _refresh(context);
                // then return
                return;
              },
              child: PageTemplate(
                children: snapshot.data,
              ),
            ),
            /*floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigationSearchPage();
              },
              child: Icon(FontAwesomeIcons.search),
              backgroundColor: Colors.pink,
            ),*/
          );
        } else
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(Values.pageHorizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LoadingText(text: AppLocalizations.of(context).translate('location_search')),
                ],
              ),
            ),

          );
      },
    );
  }

  Future<List<Widget>> getHomeWidgets(context) async {
    Widget nearMe = BusStopList(
      title: AppLocalizations.of(context).translate('near_me_bar'),
      iconData: FontAwesomeIcons.locationArrow,
      //busWidget: reloadButton(context).sliverToBoxAdapter(),
    );

    // if there are no favorites (in simplified favorites view), the favorites heading should display something else.
    // it can also be tweaked such that the favorites heading be displayed under near me (original design)
    // if there are in SFV, put favorites at the top

    List<Widget> widgetOrder = [
      simplifiedFavoritesView(context),
      Spacing(height: 40).sliver(),
      nearMe,
      Spacing(height: 20).sliver(),
      reloadButton(context).sliverToBoxAdapter(),
    ];

    List favorites =
        await FavoritesProvider.getFavorites(context, simplified: true);
    if (favorites.isEmpty) {
      // even if the SF list is empty, there may be bus stops which are not near us. That's why
      // we check if the list is empty, then check the ACTUAL amount of favorites
      // if it's more than 0, it means that it's not showing

      // so just to make it clear to the user, display a message:
      // You have 3 favorites, which are not near you.

      var noFavorites =
          (await FavoritesProvider.getFavorites(context, simplified: false))
              .length;
      widgetOrder = [
        simplifiedFavoritesView(context, favoritesNotShown: noFavorites),
        Spacing(height: 20).sliver(),
        nearMe,
        Spacing(height: 20).sliver(),
        reloadButton(context).sliverToBoxAdapter(),
      ];
    }
    return widgetOrder;
  }

  Widget simplifiedFavoritesView(BuildContext context, {int favoritesNotShown = 0}) =>
      FavoritesBusStopList(
        title: AppLocalizations.of(context).translate('favorites_bar'),
        iconData: FontAwesomeIcons.solidHeart,
        simplified: true,
        favoritesNotShown: favoritesNotShown,
      );

  Widget reloadButton(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TravelButton(
            color: Colors.green,
            text: AppLocalizations.of(context).translate('update_location'),
            iconData: FontAwesomeIcons.locationArrow,
            onTap: () async {
              _refresh(context);
            },
          ),
        ],
      );

  Future _refresh(BuildContext context) async {
    BotToast.showText(text: AppLocalizations.of(context).translate('location_search'));
    // reload getting of location and bus stops nearby
    await Provider.of<LocationServicesProvider>(context, listen: false)
        .getLocation(context, reload: true);

    // getting new bus stops
    await Provider.of<BusServiceProvider>(context, listen: false)
        .getNearestStops(context, reload: true);

    // rebuilding home
    Provider.of<PageRebuilderProvider>(context, listen: false).rebuild();

    BotToast.showText(text: AppLocalizations.of(context).translate('location_search_complete'));
  }
}

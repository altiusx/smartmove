import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/models/theme_enum.dart';
import 'package:smartmove/pages/core/travel/location_permission.dart';
import 'package:smartmove/pages/core/travel/providers/bus_service_provider.dart';
import 'package:smartmove/pages/core/travel/providers/favorites.dart';
import 'package:smartmove/pages/core/travel/providers/location.dart';
import 'package:smartmove/pages/core/travel/providers/page_rebuilder.dart';
import 'package:smartmove/route_app.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ThemeEnumAdapter());

  await Hive.openBox('settings');
  await Hive.openBox('favorites');

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ///todo: double check to see if these need to be changed
        ChangeNotifierProvider<PageRebuilderProvider>(
            create: (_) => PageRebuilderProvider()),
        ChangeNotifierProvider<LocationServicesProvider>(
            create: (_) => LocationServicesProvider()),
        ChangeNotifierProvider<BusServiceProvider>(
            create: (_) => BusServiceProvider()),
        ChangeNotifierProvider<FavoritesProvider>(
            create: (_) => FavoritesProvider()),
        //ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ChangeNotifierProvider<LocationPermsProvider>(
            create: (_) => LocationPermsProvider()),
      ],

      ///todo: refer to route_app file and make the changes
      child: RouteApp(),
    );
  }
}

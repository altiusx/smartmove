import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../location_permission.dart';

///todo: investigate location issues (maybe make user accept permissions at splashscreen!)

class LocationServicesProvider extends ChangeNotifier {
  // converting it to changeNotifier class so location only has to be retrieved once
  Position _position;
  //= null;

  // reload is to force get a new location
  Future<Position> getLocation(BuildContext context, {reload: false}) async {
    if (_position != null && !reload) {
      // Location already there so no need to get it again
      return _position;
    } else {
      // Getting location for the first time
      try {
        ///note: best = 5-7s load time, medium is near instant
        _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
        return _position;
      } catch (e) {
        // request location if not given
        await LocationPermsProvider.requestPerm();
        BotToast.showText(
            text: "Please go to settings to enable location access.", contentColor: Colors.red);
      }
    }
  }

  Future<double> distanceBetween(Position point1, Position point2) {
    return Geolocator().distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }
}

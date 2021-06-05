import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PageRebuilderProvider extends ChangeNotifier {
  void rebuild() {
    // print("Rebuilding page");
    notifyListeners();
  }

  // to save the location between travel page rebuilds
  Position _position;
  set position(Position val) {
    _position = val;
    notifyListeners();
  }

  get position => _position;
}

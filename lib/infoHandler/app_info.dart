
import 'package:flutter/cupertino.dart';
import 'package:users_app/models/directions.dart';

import '../models/trip.dart';

class AppInfo extends ChangeNotifier
{

  String _myString = '';

  String get myString => _myString;

  set myString(String value) {
    _myString = value;
    notifyListeners(); // Thông báo cho người nghe về sự thay đổi
  }

  Directions? userPickUpLocation, userDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
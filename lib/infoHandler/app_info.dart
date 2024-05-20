
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

  double searchLocationContainerHeight = 320;
  double waitingResponseFromDriverUIContainerHeight = 0;
  double assignedDriverContainerHeight = 0;
  Directions? userPickUpLocation, userDropOffLocation;

  Trip? userTrip;
  void updateUserTripCode(Trip trip)
  {
    userTrip = trip;
    notifyListeners();
    if(trip.code == 'trip.Picking')
    {
      updateAssignedLocation(300);
      updateSearchLocation(0);
      updateWaitingLocation(0);
    }
  }
  void updateSearchLocation(double d){
    searchLocationContainerHeight = d;
    notifyListeners();
  }
  void updateWaitingLocation(double d){
    waitingResponseFromDriverUIContainerHeight = d;
    notifyListeners();
  }
  void updateAssignedLocation(double d){
    assignedDriverContainerHeight = d;
    notifyListeners();
  }

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
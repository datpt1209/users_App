import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation
{
  LatLng? originLatLng;
  LatLng? destinationLaLng;
  String? originAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;

  UserRideRequestInformation({
    this.originLatLng,
    this.destinationLaLng,
    this.originAddress,
    this.destinationAddress,
    this.rideRequestId,
    this.userName,
    this.userPhone,
  });
}
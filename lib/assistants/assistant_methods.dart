/*
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/global/map_key_dart.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/user_model.dart';
import '../models/direction_details_info.dart';

class AssistantMethods
{
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    String humanReadableAddress="";
   var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

   if(requestResponse != "Error Occurred, Failed. No Response.")
   {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

     Directions userPickUpAddress = Directions();
     userPickUpAddress.locationLatitude = position.latitude;
     userPickUpAddress.locationLongitude = position.longitude;
     userPickUpAddress.locationName = humanReadableAddress;

     Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
   }
   return humanReadableAddress;
  }


  static void readCurrentOnlineUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);
    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
       userModelCurrentInfo =  UserModel.fromSnaphot(snap.snapshot);
      }
    });
  }
  static void readCurrentOnlineUserInfo_API() async
  {
    //Read user online with API
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng origionPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapkey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error Occurred, Failed. No Response.")
    {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.duration_value! / 1000) * 0.1;

    //USD
    double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;

    return double.parse(totalFareAmount.toStringAsFixed(1));
  }

  //  HTTP Request notification
  // Header {
  // 'Content-Type': 'application/json',
  //     'Authorization': cloudMessagingServerToken,
  // }
  // Body
  // {
  //   "notification":{
  //       "body":"Hello, You have a new RideRequest",
  //       "title":"InDriver Clone App"
  //     },
  //     "priority": "high",
  //     "data": {
  //         "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //         "id": "1",
  //         "status":"done",
  //         "rideRequestId": requestId
  //     },
  //     "to":token
  // }

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async
  {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification =
    {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification =
    {
      "body":"Destination Address:, \n$destinationAddress.",
      "title":"New Trip Request"
    };
    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status":"done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      "to": deviceRegistrationToken
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
    print(headerNotification);
    print(officialNotificationFormat);

  }
}*/

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/global/map_key_dart.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/additional_service.dart';
import 'package:users_app/models/directions.dart';
import '../models/direction_details_info.dart';
import '../models/user_api.dart';

class AssistantMethods
{
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress="";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occurred, Failed. No Response.")
    {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }

  Future<void> readAdditionalServices() async
  {
    var response = await http.get(Uri.parse('http://209.38.168.38/trip/additional-services/get/all'));
    print("Additional Service::::::::${response.body}");
    if(response.statusCode == 200){
      additionalServices =  additionalServicesFromJson(response.body);
    }else{
      Fluttertoast.showToast(msg: "Error Occurred during Read additional Services");
      throw Exception('Failed to Read Read additional Services');
    }
  }

  Future<void> readCurrentOnlineUserInfo_API() async
  {
    int id = currentUser_API?.id as int;
    var response = await http.get(Uri.parse('http://209.38.168.38/account/api/v1/customer/${id}'));
    if(response.statusCode == 200){
      currentUser_API_Info =  UserModel_API.fromJsonInfo(jsonDecode(response.body) as Map<String, dynamic>);
      print("userModel_APICurrentInfo?::::::: ${currentUser_API_Info?.fullName}");
    }else{
      Fluttertoast.showToast(msg: "Error Occurred during Read Current information");
      throw Exception('Failed to Read current information');
    }
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng origionPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error Occurred, Failed. No Response.")
    {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {

    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.duration_value! / 1000) * 0.1;

    //USD
    double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;

    return double.parse(totalFareAmount.toStringAsFixed(1));
  }

  /* HTTP Request notification
  Header {
  'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
  }
  Body
  {
    "notification":{
        "body":"Hello, You have a new RideRequest",
        "title":"InDriver Clone App"
      },
      "priority": "high",
      "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status":"done",
          "rideRequestId": requestId
      },
      "to":token
  }
  * */

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async
  {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification =
    {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification =
    {
      "body":"Destination Address:, \n$destinationAddress.",
      "title":"New Trip Request"
    };
    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status":"done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      "to": deviceRegistrationToken
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
    print(headerNotification);
    print(officialNotificationFormat);

  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/additional_service.dart';
import 'package:users_app/models/driver.dart';
import 'package:users_app/models/message.dart';
import 'package:users_app/models/user_api.dart';
import 'package:users_app/models/user_model.dart';
import 'package:users_app/models/vehicle.dart';
import '../models/direction_details_info.dart';
import '../models/trip.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
UserModel_API? currentUser_API;
late UserModel_API? currentUser_API_Info;
List dList = [];
List<AdditionalService> additionalServices = [];//driverKeys Info List

Message? message;
Driver? currentDriver;
Trip? currentTrip;
Vehicle? currentVehicle;
DirectionDetailsInfo? tripDirectionDetailsInfo;

String? chosenDriverId = "";

String cloudMessagingServerToken = "key=AAAA73ey5uI:APA91bFPit-b79DqNm_0ahG4ac2gLCePhomEYeS_UnnKICNyVe5vk4wit5UPZU9Jp4iAvvfGaBEGBc4qDLXx67SUmjBusrHy4Nza3h4M7UbXcVM7yv5_ICrFo_5Aw818cvHqQolES1BV";

String userDropOffAddress = "";
String userPickUpAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String messageString = "Successfully found the driver";
List<String> addServices = [];
String selectedServices = "";

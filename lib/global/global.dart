import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_api.dart';
import 'package:users_app/models/user_model.dart';

import '../models/direction_details_info.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
UserModel_API? currentUser_API;
UserModel_API? userModel_APICurrentInfo;
List dList = [];//driverKeys Info List

DirectionDetailsInfo? tripDirectionDetailsInfo;

String? chosenDriverId = "";

String cloudMessagingServerToken = "key=AAAA73ey5uI:APA91bFPit-b79DqNm_0ahG4ac2gLCePhomEYeS_UnnKICNyVe5vk4wit5UPZU9Jp4iAvvfGaBEGBc4qDLXx67SUmjBusrHy4Nza3h4M7UbXcVM7yv5_ICrFo_5Aw818cvHqQolES1BV";

String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
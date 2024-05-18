/*
import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/search_places_screen.dart';
import 'package:users_app/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:users_app/models/car_type.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:users_app/widgets/progress_dialog.dart';
import '../assistants/geofire_assistant.dart';
import '../assistants/request_assistant.dart';
import '../infoHandler/app_info.dart';
import '../models/active_nearby_available_drivers.dart';


class MainScreen extends StatefulWidget
{
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newgoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  List<String> carTypeList = [];
  String? selectedCarType;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 280;
  double waitingResponseFromDriverUIContainerHeight = 0;
  double assignedDriverContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "your Name";
  String userEmail= "Your Email";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];

  DatabaseReference? referenceRideRequest;

  String driverRideStatus = "Driver is Coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;
  String userRideRequestStatus = "";
  bool requestPositionInfo = true;

  blackThemegoogleMap()
  {
    newgoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async
  {
    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newgoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    print("this is your address " + humanReadableAddress);

    initializeGeoFireListener();
  }

  @override
  void initState()
  {
    super.initState();
    checkIfPermissionAllowed();
    AssistantMethods.readCurrentOnlineUserInfo();
    getCarType();
  }

  saveRideRequestInformation()
  {
    //1. save the RideRequest Information
    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push();//id

    var originLocation = Provider.of<AppInfo>(context, listen:false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen:false).userDropOffLocation;

    Map originLocationMap =
    {
      //"key": value
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };
    Map destinationLocationMap =
    {
      //"key": value
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),
    };

    Map userInformationMap =
    {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time":DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);
    tripRideRequestInfoStreamSubscription = referenceRideRequest!.onValue.listen((eventSnap)
    {
      if(eventSnap.snapshot.value == null)
      {
        return;
      }
      if((eventSnap.snapshot.value as Map)["car_details"] != null)
      {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["driverPhone"] != null)
      {
        setState(() {
          driverPhone = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["driverName"] != null)
      {
        setState(() {
          driverName = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }
      if((eventSnap.snapshot.value as Map)["status"] != null)
      {
        userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"];
      }

      if((eventSnap.snapshot.value as Map)["driverLocation"] != null)
      {
        double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
        double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

        LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);
        //Status = accepted
        if(userRideRequestStatus == "accepted")
        {
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        }
        //Status = arrived
        if(userRideRequestStatus == "arrived")
        {
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }
        //Status = ontrip
        if(userRideRequestStatus == "ontrip")
        {
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }
      }
    });
    onlineNearByAvailableDriversList = GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  getCarType() async
  {
    String jsonString = '[{"id": 1, "name": "4 cho", "capacity": 1, "is_deleted": "false"},{"id": 1, "name": "4 cho","capacity": 1, "is_deleted": "false"}]';
    var json = jsonDecode(jsonString);
    List<CarType> carType = carTypeFromJson(jsonString) as List<CarType>;
    // for(int i = 0; i< carType.length; i++)
    // {
    //   carTypeList.add(carType[i].name.toString());
    // }
    carType.forEach(await (element)=>{carTypeList.add(element.name.toString())});
    var nameJson = carType[1].name.toString();
    print('JSON::' + nameJson);
    print('Jsooo:::' + carTypeList.toString());
    // String getCarTypeUrl = 'https://effective-space-couscous-7rrrrqrv6g9hp9vx-8000.app.github.dev/cartypes';
    // var requestResponse = await RequestAssistant.receiveRequest(getCarTypeUrl);
    // print(requestResponse);

  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;

      LatLng userPickUpPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpPosition,
      );
      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Driver is Coming :: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;

      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(dropOffLocation!.locationLatitude!, dropOffLocation!.locationLongitude!);

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDestinationPosition,
      );
      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Going towards Destination :: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async
  {
    //no active driver available
    if(onlineNearByAvailableDriversList.length == 0)
    {
      //cancel/delete the RideRequest Information
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(msg: "No Online Nearest Driver Available. Search Again after some time, Restarting App Now.");

      Future.delayed(const Duration(milliseconds: 4000), ()
      {
        SystemNavigator.pop();
      });

      return;
    }

    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    var response = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SelectNearestActiveDriversScreen(referenceRideRequest: referenceRideRequest)));
    if(response == "driverChose")
    {
      FirebaseDatabase.instance.ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once()
          .then((snap)
      {
            if(snap.snapshot.value != null)
            {
               //send notification to that specific driver
              sendNotificationToDriverNow(chosenDriverId!);

              //Display Waiting Response from a Driver
              showWaitingResponseFromDriverUI();

                          //Response from a Driver
              FirebaseDatabase.instance.ref()
                  .child("drivers")
                  .child(chosenDriverId!)
                  .child("newRideStatus")
                  .onValue.listen((eventSnapshot)
              {
                //1 Driver has cancel the rideRequest :: Push notification
                //(newRideStatus == idle)
                if(eventSnapshot.snapshot.value == "idle")
                {
                  Fluttertoast.showToast(msg: "The driver has cancel your request. Please choose another driver.");

                  Future.delayed(const Duration(microseconds: 3000), ()
                      {
                        Fluttertoast.showToast(msg: "Restart App Now");
                        SystemNavigator.pop();
                      });
                }

                //2. Driver has accepted the rideRequest::Push notification
                //(newRideStatus == accepted)
                if(eventSnapshot.snapshot.value == "accepted")
                {
                  //Design and display UI driver information
                  showUIForAssignedDriverInfo();

                }
              });
            }
            else
            {
              Fluttertoast.showToast(msg: "This driver do not exist. Try again");
            }
      });
    }
  }

  showUIForAssignedDriverInfo()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverUIContainerHeight = 0;
      assignedDriverContainerHeight = 250;
    });
  }

  showWaitingResponseFromDriverUI()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverUIContainerHeight = 240;
    });
  }

  sendNotificationToDriverNow(String chosenDriverId)
  {
    //assign /Set rideRequestId to newRideStatus in Driver Parent node for chosen driver
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId!)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //automate the push notification service
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token").once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        //send notification to that specific driver
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send Notification Now
        AssistantMethods.sendNotificationToDriverNow(
            deviceRegistrationToken,
            referenceRideRequest!.key.toString(),
            context
        );
        Fluttertoast.showToast(msg: "Notification sent Successfully");
      }
      else
      {
        Fluttertoast.showToast(msg: "Please chose another driver.");
        return;
      }
    });

  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for(int i=0; i<onlineNearestDriversList.length; i++)
    {
      await ref.child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot)
      {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }


  @override
  Widget build(BuildContext context)
  {

    createActiveNearByDriverIconMarker();
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 270,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [

          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newgoogleMapController = controller;

              //for black theme google map
              blackThemegoogleMap();

              setState(() {
                bottomPaddingOfMap = 245;
              });
              locateUserPosition();
            },
          ),

          //custom hamburger button drawer
          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: ()
              {
                if(openNavigationDrawer)
                {
                  sKey.currentState!.openDrawer();
                }
                else
                {
                  //restart-refresh-minimize app programmatically
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.black54,

                ),
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(microseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          DropdownButton(
                            iconSize: 26,
                            dropdownColor: Colors.white,
                            hint: const Text(
                              "Please choose Car Type",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              ),
                            ),
                            value: selectedCarType,
                            onChanged: (newValue)
                            {
                              setState(() {
                                selectedCarType = newValue.toString();
                              });
                            },
                            items: carTypeList.map((car){
                              return DropdownMenuItem(
                                child:Text(
                                  car,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                value:car,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      //from
                      Row(
                        children: [
                          const Icon(Icons.add_location_alt_outlined, color: Colors.grey,),
                          const SizedBox(width:12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickUpLocation != null
                                    ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,40) + "..."
                                    :"Not getting location"
                                ,
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),

                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),


                      //to
                      GestureDetector(
                        onTap: () async
                        {
                          //search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c) => SearchPlacesScreen()));

                          if(responseFromSearchScreen == "obtainedDropoff")
                          {
                            setState(() {
                              openNavigationDrawer = false;
                            });
                            //draw routes - draw polyline
                            await drawPolyLineFromOriginDestination();
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.add_location_alt_outlined, color: Colors.grey,),
                            const SizedBox(width:12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                      ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : "Where to go?",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 16,),

                      ElevatedButton(
                        child: const Text(
                          "Request a Ride",
                        ),
                        onPressed: ()
                        {
                          if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null)
                          {
                            saveRideRequestInformation();
                          }
                          else
                          {
                            Fluttertoast.showToast(msg: "Please select destination location");
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          //UI for waiting response Driver
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: waitingResponseFromDriverUIContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText(
                          'Waiting for Response \n from Driver',
                          duration: const Duration(seconds: 6),
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(fontSize: 30.0, color:Colors.white, fontWeight: FontWeight.bold),
                        ),
                        ScaleAnimatedText(
                          'Please wait,..',
                          duration: const Duration(seconds: 10),
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(fontSize: 32.0, color:Colors.white, fontFamily: 'Canterbury'),
                        ),
                      ],
                    ),
                  ),
                ),
              )),

          //UI for assigned response Driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status of ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    //driver vehicle details
                    Text(
                      driverCarDetails,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),

                    //driver name
                    Text(
                      driverName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    //call driver button
                    Center(
                      child: ElevatedButton.icon(
                          onPressed: ()
                          {
                            //call Driver
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          icon: const Icon(
                            Icons.phone_android,
                            color: Colors.black54,
                            size: 18,
                          ),
                          label: const Text(
                            "Call Driver",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

  Future<void> drawPolyLineFromOriginDestination() async
  {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
    );
    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    print("these are point = ");
    print (directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPoyPointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();
    if(decodedPoyPointsResultList.isNotEmpty)
    {
      decodedPoyPointsResultList.forEach((PointLatLng pointLatLng)
      {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.purpleAccent,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoOrdinatesList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude)
      );
    }
    else if(originLatLng.latitude > destinationLatLng.latitude) 
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude)
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newgoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng,65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);

    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);

    });
  }

  initializeGeoFireListener()
  {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack)
            {
        //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDriver);
            if(activeNearbyDriverKeysLoaded == true)
            {
              displayActiveDriversOnUsersMap();
            }
            break;

        //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

        //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

        //display those online/active drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap()
  {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for(ActiveNearbyAvailableDrivers eachDriver in GeoFireAssistant.activeNearbyAvailableDriversList)
      {
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver"+eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker()
  {
    if(activeNearbyIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png").then((value)
      {
        activeNearbyIcon = value;
      });
    }
  }
}
*/


import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/search_pickup_place.dart';
import 'package:users_app/mainScreens/search_places_screen.dart';
import 'package:users_app/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:users_app/models/car_type.dart';
import 'package:users_app/models/user_api.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:users_app/widgets/progress_dialog.dart';
import '../assistants/geofire_assistant.dart';
import '../infoHandler/app_info.dart';
import '../models/active_nearby_available_drivers.dart';
import 'package:http/http.dart' as http;

import '../push_notifications/push_notification_system.dart';


class MainScreen extends StatefulWidget
{
  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
{
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  late Future<List<CarType>> carTypeList;
  CarType? selectedCarType;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 320;
  double waitingResponseFromDriverUIContainerHeight = 0;
  double assignedDriverContainerHeight = 0;
  int? tripFare;

  String? idTrip;

  Position? userCurrentPosition;
  Position? userPickUpPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "your Name";
  String userEmail= "Your Email";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];

  DatabaseReference? referenceRideRequest;

  String driverRideStatus = "Driver is Coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;
  String userRideRequestStatus = "";
  bool requestPositionInfo = true;
  String? selectedPaymentMethod;

  blackThemegoogleMap()
  {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  readUserRideRequestInformation(RemoteMessage remoteMessage, BuildContext context)
  {
    var jsonString = remoteMessage.data['data'].toString();
    final Map<String, dynamic> parsed = json.decode(jsonString);
    var trip = Trip.fromJson(parsed);

    if(trip.code == "trip.Picking")
    {
      var message = trip.messageObject!;
      print("Driver Information::::::::::${message.driver.name} - ${message.driver.phone}");
      // double originLong = double.parse(origination['longitude']);
      showUIForAssignedDriverInfo();

    }
    else
    {
      var message = trip.message!;
      print("This is Message:::::::::${message}");
      Fluttertoast.showToast(msg: "The driver has cancel your request. Please choose another driver.");
      // double originLong = double.parse(origination['longitude']);
    }


    // var originAddress = remoteMessage.data['pickingAddress'].toString();
    // var origination =jsonDecode(remoteMessage.data["origin"].toString());
    // double originLat = double.parse(origination['latitude']);
    // double originLong = double.parse(origination['longitude']);
    //
    // var destinationAddress = remoteMessage.data['destinationAddress'].toString();
    // var destination =jsonDecode(remoteMessage.data["destination"].toString());
    // double destinationLat = double.parse(destination['latitude']);
    // double destinationLong = double.parse(destination['longitude']);
    //
    // UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
    // userRideRequestDetails.originLatLng = LatLng(originLat, originLong);
    // userRideRequestDetails.originAddress = originAddress;
    // userRideRequestDetails.destinationAddress = destinationAddress;
    // userRideRequestDetails.destinationLaLng = LatLng(destinationLat, destinationLong);
    //
    // print("this is latitude::::::::::${originAddress}");

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => NotificationDialogBox(
    //       userRideRequestDetails: userRideRequestDetails,
    //     ),
    // );
  }



  Future<List<CarType>> getCarTypeList() async {
    final response = await http.get(Uri.parse("http://209.38.168.38/vehicle/vehicle-types"));
    final carTypeList = carTypeFromJson(response.body);
    return carTypeList;
  }


  void dropdownCarType(CarType? selectedValue){
    if(selectedValue is CarType){
      setState(() {
        selectedCarType = selectedValue;
      });
    }
  }
  void dropdownPaymentMethod(String? selectedValue){
    if(selectedValue is String){
      setState(() {
        selectedPaymentMethod = selectedValue;
      });
    }
  }

  Future<UserModel_API?> readCurrentUserInformation1() async {
    final response = await http.get(Uri.parse("http://209.38.168.38/account/api/v1/customer/${currentUser_API?.id}"));
    currentUser_API_Info = UserModel_API.fromJsonInfo(jsonDecode(response.body) as Map<String,dynamic>);
    return currentUser_API_Info;
  }

  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    print("this is your address " + humanReadableAddress);
    userName = currentUser_API_Info!.fullName!;
    userEmail = currentUser_API_Info!.mobilePhone!;

    initializeGeoFireListener();
  }

  saveRideRequestInformation()
  async {
    //1. save the RideRequest Information
    var originLocation = Provider.of<AppInfo>(context, listen:false).userPickUpLocation;
    var destinationLocation =Provider.of<AppInfo>(context, listen:false).userDropOffLocation;

    Map customer =
    {
      "id": currentUser_API_Info!.id.toString(),
      "name": currentUser_API_Info!.fullName.toString(),
      "phone": currentUser_API_Info!.mobilePhone.toString(),
      "rank": "NORMAL",
      "type": "customer",
    };
    Map destination =
    {
      //"key": value
      "address": destinationLocation!.locationName.toString(),
      "coordinate": [destinationLocation.locationLongitude,destinationLocation.locationLatitude]
    };

    Map pickup =
    {
      //"key": value
      "address": originLocation!.locationName.toString(),
      "coordinate": [originLocation.locationLongitude,originLocation.locationLatitude],
    };

    Map requester =
    {
      "id": currentUser_API_Info!.id.toString(),
      "name": currentUser_API_Info!.fullName.toString(),
      "phone": currentUser_API_Info!.mobilePhone.toString(),
      "rank": "NORMAL",
      "type": "customer",
    };

    Map rideRequest =
    {
      "additional_services":[],
      "customer": customer,
      "destination": destination,
      "distance": tripDirectionDetailsInfo!.distance_value! / 1000,
      "id": idTrip,
      "pickup": pickup,
      "price": tripFare,
      "request_time": DateTime.now().toString(),
      "request_type": "ORDINARY",
      "requester":requester,
      "vehicle_type":selectedCarType!.id,
    };

    print("Ride request:::::::: ${json.encode(rideRequest)}");

    var body = json.encode(rideRequest);
    var response = await http.post(Uri.parse('http://209.38.168.38/trip/customer/book/customer'),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("THIS IS RIDE REQUEST RESPONSE::::::: ${response.body}");

    if(response.statusCode == 201){
      var responseDecode = jsonDecode(response.body);
     print("This response BOOK XE:::::::::::::${responseDecode['code'] as String}");
     showWaitingResponseFromDriverUI();
    }else{
      Fluttertoast.showToast(msg: "Error Occurred during Booking");
      throw Exception('Failed to call Driver');
    }

    //   if((eventSnap.snapshot.value as Map)["driverLocation"] != null)
    //   {
    //     double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
    //     double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());
    //
    //     LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);
    //     //Status = accepted
    //     if(userRideRequestStatus == "accepted")
    //     {
    //       updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
    //     }
    //     //Status = arrived
    //     if(userRideRequestStatus == "arrived")
    //     {
    //       setState(() {
    //         driverRideStatus = "Driver has Arrived";
    //       });
    //     }
    //     //Status = ontrip
    //     if(userRideRequestStatus == "ontrip")
    //     {
    //       updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
    //     }
    //   }
    // });
    //onlineNearByAvailableDriversList = GeoFireAssistant.activeNearbyAvailableDriversList;
    //searchNearestOnlineDrivers();
  }
  calculateFare()
  async {
    //1. save the RideRequest Information
    var originLocation = Provider.of<AppInfo>(context, listen:false).userPickUpLocation;
    var destinationLocation =Provider.of<AppInfo>(context, listen:false).userDropOffLocation;

    Map customer =
    {
      "id": currentUser_API_Info!.id.toString(),
      "name": currentUser_API_Info!.fullName.toString(),
      "phone": currentUser_API_Info!.mobilePhone.toString(),
      "rank": "NORMAL",
      "type": "customer",
    };
    Map destination =
    {
      //"key": value
      "address": destinationLocation!.locationName.toString(),
      "coordinate": [destinationLocation.locationLongitude,destinationLocation.locationLatitude]
    };

    Map pickup =
    {
      //"key": value
      "address": originLocation!.locationName.toString(),
      "coordinate": [originLocation.locationLongitude,originLocation.locationLatitude],
    };

    Map rideRequest =
    {
      "additional_services":[],
      "customer": customer,
      "destination": destination,
      "distance": tripDirectionDetailsInfo!.distance_value! / 1000,
      "pickup": pickup,
      "request_type": "ORDINARY",
      "vehicle_type":selectedCarType!.id,

    };
    print("Ride request:::::::: ${json.encode(rideRequest)}");

    var body = json.encode(rideRequest);
    var response = await http.post(Uri.parse('http://209.38.168.38/trip/customer/estimate/customer'),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("THIS IS RIDE REQUEST RESPONSE::::::: ${response.body}");

    if(response.statusCode == 201){
      var responseDecode = jsonDecode(response.body);
      setState(() {
        tripFare = responseDecode['result'];
        idTrip = responseDecode['trip_id'];
      });
    }else{

      Fluttertoast.showToast(msg: "Error Occurred during Estimate FARE");
      throw Exception('Failed to Estimate FARE');
    }
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;
      LatLng userPickUpPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpPosition,
      );
      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Driver is Coming :: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;

      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(dropOffLocation!.locationLatitude!, dropOffLocation.locationLongitude!);

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDestinationPosition,
      );
      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Going towards Destination :: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async
  {
    //no active driver available
    if(onlineNearByAvailableDriversList.length == 0)
    {
      //cancel/delete the RideRequest Information
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(msg: "No Online Nearest Driver Available. Search Again after some time, Restarting App Now.");

      Future.delayed(const Duration(milliseconds: 4000), ()
      {
        SystemNavigator.pop();
      });

      return;
    }

    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    var response = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SelectNearestActiveDriversScreen(referenceRideRequest: referenceRideRequest)));
    if(response == "driverChose")
    {
      FirebaseDatabase.instance.ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
        {
          //send notification to that specific driver
          sendNotificationToDriverNow(chosenDriverId!);

          //Display Waiting Response from a Driver
          showWaitingResponseFromDriverUI();

          //Response from a Driver
          FirebaseDatabase.instance.ref()
              .child("drivers")
              .child(chosenDriverId!)
              .child("newRideStatus")
              .onValue.listen((eventSnapshot)
          {
            //1 Driver has cancel the rideRequest :: Push notification
            //(newRideStatus == idle)
            if(eventSnapshot.snapshot.value == "idle")
            {
              Fluttertoast.showToast(msg: "The driver has cancel your request. Please choose another driver.");

              Future.delayed(const Duration(microseconds: 3000), ()
              {
                Fluttertoast.showToast(msg: "Restart App Now");
                SystemNavigator.pop();
              });
            }

            //2. Driver has accepted the rideRequest::Push notification
            //(newRideStatus == accepted)
            if(eventSnapshot.snapshot.value == "accepted")
            {
              //Design and display UI driver information
              showUIForAssignedDriverInfo();

            }
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "This driver do not exist. Try again");
        }
      });
    }
  }

  showUIForAssignedDriverInfo()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverUIContainerHeight = 0;
      assignedDriverContainerHeight = 250;
    });
  }

  showWaitingResponseFromDriverUI()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverUIContainerHeight = 240;
    });
  }

  sendNotificationToDriverNow(String chosenDriverId)
  {
    //assign /Set rideRequestId to newRideStatus in Driver Parent node for chosen driver
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //automate the push notification service
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token").once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        //send notification to that specific driver
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send Notification Now
        AssistantMethods.sendNotificationToDriverNow(
            deviceRegistrationToken,
            referenceRideRequest!.key.toString(),
            context
        );
        Fluttertoast.showToast(msg: "Notification sent Successfully");
      }
      else
      {
        Fluttertoast.showToast(msg: "Please chose another driver.");
        return;
      }
    });

  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for(int i=0; i<onlineNearestDriversList.length; i++)
    {
      await ref.child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot)
      {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }

  readCurrentCustomerInformation() async
  {
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }


  @override
  void initState()
  {
    super.initState();
    checkIfPermissionAllowed();
    readCurrentUserInformation1();
    //AssistantMethods.readCurrentOnlineUserInfo_API();
    //getCarType();
    readCurrentCustomerInformation();
    carTypeList = getCarTypeList();
  }

  @override
  Widget build(BuildContext context)
  {
    createActiveNearByDriverIconMarker();
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 270,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [

          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //for black theme google map
              blackThemegoogleMap();
              setState(() {
                bottomPaddingOfMap = 330;
              });
              locateUserPosition();
            },
          ),

          //custom hamburger button drawer
          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: ()
              {
                if(openNavigationDrawer)
                {
                  sKey.currentState!.openDrawer();
                }
                else
                {
                  //restart-refresh-minimize app programmatically
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.black54,

                ),
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(microseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      //select CarType
                      Row(
                        children: [
                          FutureBuilder<List<CarType>>(
                              future: carTypeList,
                              builder: (context,snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                else if (snapshot.hasError) {
                                  return const Text('Error loading data');
                                }
                                else if (!snapshot.hasData) {
                                  return const Text('No data available');
                                }
                                else {
                                  final carTypeList = snapshot.data!;
                                  return DropdownButton(iconSize: 20,
                                      dropdownColor: Colors.transparent,
                                      hint: const Text(
                                        "Please choose Car Type",
                                        style: TextStyle(

                                            color: Colors.grey
                                        ),
                                      ),
                                      value: selectedCarType,
                                      items: carTypeList.map((carType) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            carType.name,
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                          value: carType,
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          selectedCarType = val;
                                        });
                                      });
                                }
                              }),
                        ],
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      //select payment method
                      Row(
                        children: [
                          DropdownButton(
                            iconSize: 20,
                            dropdownColor: Colors.transparent,
                            hint: const Text(
                              "Please choose Payment method",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              ),
                            ),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey
                            ),
                            value: selectedPaymentMethod,
                            onChanged: dropdownPaymentMethod,
                            items: const [
                              DropdownMenuItem(child: Text("Cash"), value:"Cash"),
                              DropdownMenuItem(child: Text("ATM"), value:"ATM"),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      //select pick up address
                      GestureDetector(
                        onTap: () async
                        {
                          //search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c) => Search_pickup_place()));

                          if(responseFromSearchScreen == "obtainedPickUp")
                          {
                            var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
                            var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
                            CameraPosition cameraPosition = CameraPosition(target: originLatLng, zoom: 14);
                            newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.add_location_alt_outlined, color: Colors.grey,),
                            const SizedBox(width:12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "From",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userPickUpLocation != null
                                      ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,10) + "..."
                                      : "Where are you?",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      //select drop off address
                      GestureDetector(
                        onTap: () async
                        {
                          //search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c) => SearchPlacesScreen()));

                          if(responseFromSearchScreen == "obtainedDropoff")
                          {
                            setState(() {
                              openNavigationDrawer = false;
                            });
                            //draw routes - draw polyline

                            await drawPolyLineFromOriginDestination();
                            await calculateFare();
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.add_location_alt_outlined, color: Colors.grey,),
                            const SizedBox(width:12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                      ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : "Where to go?",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    //Fare
                      Row(
                        children: [
                          const Icon(Icons.monetization_on_outlined, color: Colors.grey,),
                          const SizedBox(width:12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Fare",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                tripFare != null? tripFare.toString(): "",
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10,),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      ElevatedButton(
                        child: const Text(
                          "Request a Ride",
                        ),
                        onPressed: ()
                        {
                          if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null)
                          {
                            saveRideRequestInformation();
                          }
                          else
                          {
                            Fluttertoast.showToast(msg: "Please select destination location");
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          //UI for waiting response Driver
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: waitingResponseFromDriverUIContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText(
                          'Waiting for Response \n from Driver',
                          duration: const Duration(seconds: 6),
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(fontSize: 30.0, color:Colors.white, fontWeight: FontWeight.bold),
                        ),
                        ScaleAnimatedText(
                          'Please wait,..',
                          duration: const Duration(seconds: 10),
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(fontSize: 32.0, color:Colors.white, fontFamily: 'Canterbury'),
                        ),
                      ],
                    ),
                  ),
                ),
              )),

          //UI for assigned response Driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status of ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    //driver vehicle details
                    Text(
                      driverCarDetails,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),

                    //driver name
                    Text(
                      driverName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    //call driver button
                    Center(
                      child: ElevatedButton.icon(
                          onPressed: ()
                          {
                            //call Driver
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          icon: const Icon(
                            Icons.phone_android,
                            color: Colors.black54,
                            size: 18,
                          ),
                          label: const Text(
                            "Call Driver",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

  Future<void> drawPolyLineFromOriginDestination() async
  {

    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
    );
    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    print("these are point = ");
    print (directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPoyPointsResultList = pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();
    if(decodedPoyPointsResultList.isNotEmpty)
    {
      for (var pointLatLng in decodedPoyPointsResultList) {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.purpleAccent,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoOrdinatesList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude)
      );
    }
    else if(originLatLng.latitude > destinationLatLng.latitude)
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude)
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng,65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);

    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);

    });
  }

  initializeGeoFireListener()
  {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack)
            {
        //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDriver);
            if(activeNearbyDriverKeysLoaded == true)
            {
              displayActiveDriversOnUsersMap();
            }
            break;

        //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

        //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

        //display those online/active drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }
      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap()
  {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for(ActiveNearbyAvailableDrivers eachDriver in GeoFireAssistant.activeNearbyAvailableDriversList)
      {
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver"+eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker()
  {
    if(activeNearbyIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png").then((value)
      {
        activeNearbyIcon = value;
      });
    }
  }
}


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class NotificationCancelTrip extends StatefulWidget
{
  NotificationCancelTrip();

  @override
  State<NotificationCancelTrip> createState() => _NotificationCancelTripState();
}

class _NotificationCancelTripState extends State<NotificationCancelTrip>
{
  TextEditingController reasonTextEditingController = TextEditingController();

  CancelTrip() async
  {

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),

          color: Colors.grey[800],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14,),
            Image.asset("images/car_logo.png", width: 160,),
            const SizedBox(height: 10,),
            //title
            const Text(
              "Cancel Trip",
              style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.grey
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            //address origin destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  TextField(
                    controller: reasonTextEditingController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Colors.grey
                    ),
                    decoration: const InputDecoration(
                      labelText: "Mobile Phone",
                      hintText: "Mobile phone",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle:  TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      labelStyle:TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            //buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: ()
                    {
                      //cancel the rideRequest
                      Navigator.pop(context);

                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: ()
                    {
                      //accept the rideRequest
                      //acceptRideRequest(context);
                    },
                    child: Text(
                      "Ok".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // acceptRideRequest(BuildContext context)
  // async {
  //   if(widget.code == 'trip.Done')
  //   {
  //     Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
  //   }
  //   else
  //   {
  //     await confirmPayment();
  //     Navigator.pop(context);
  //   }
  //
  // }
  cancelRideRequest(BuildContext context)
  async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Cance trip, Please wait...",);
        }
    );

    var body = json.encode("");
    var response = await http.post(Uri.parse('http://209.38.168.38/account/api/v1/login'),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    if(response.statusCode == 200){
      Fluttertoast.showToast(msg: "Login Successfully with CustomerID: ");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login");
      throw Exception('Failed to login with Driver');
    }
  }


}
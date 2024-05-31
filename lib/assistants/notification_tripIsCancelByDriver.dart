
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../splashScreen/splash_screen.dart';

class NotificationTripIsCancelByCustomer extends StatefulWidget
{
  NotificationTripIsCancelByCustomer();

  @override
  State<NotificationTripIsCancelByCustomer> createState() => _NotificationTripIsCancelByCustomerState();
}

class _NotificationTripIsCancelByCustomerState extends State<NotificationTripIsCancelByCustomer>
{

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

            const SizedBox(height: 10,),

            const Divider(
              height: 2,
              thickness: 2,
            ),

            //address origin destination
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    "The driver has canceled the trip, Please rebook another trip!",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
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
                      backgroundColor: Colors.green,
                    ),
                    onPressed: ()
                    {
                      Fluttertoast.showToast(msg: "Trip has cancel");
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
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
}
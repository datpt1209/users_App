import 'dart:async';
import 'package:flutter/material.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/mainScreens/main_screen.dart';
import '../global/global.dart';

class MySplashScreen extends StatefulWidget
{
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen>
{

  startTimer(){
  /*  fAuth.currentUser != null ?  AssistantMethods.readCurrentOnlineUserInfo() : null;
    Timer( const Duration(seconds: 5), () async
    {
      if(await fAuth.currentUser != null)
      {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
      }
      else
        {
          //send user to home screen
          Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
        }

    });*/

    Timer( const Duration(seconds: 5), () async
    {
       messageString = "Search Driver Successfully";
       addServices = [];
       selectedServices = "";
      if(currentUser_API != null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));
      }
      else
      {
        //send user to home screen
        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),

              const SizedBox(height: 10,),

              const Text(
                "Uber & inDriver Clone App",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

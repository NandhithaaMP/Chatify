import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampark/constant/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../api/apis.dart';
import 'home_Screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 10),() {
      callNextReplacement(context, Login_Screen());
      if(APIs.auth.currentUser!=null){

        log("\nUser -----------         :${APIs.auth.currentUser}");
        callNextReplacement(context, Home_Screen());
      }
      else{
        callNextReplacement(context, Login_Screen());
      }
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(child: Lottie.asset("assets/lottie/chat_bubble.json")),
        
          Text("Talk Anytime, Anywhere! 💛")
        ],
      ),
    );
  }
}

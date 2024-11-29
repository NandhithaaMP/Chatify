import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampark/constant/constants.dart';
import 'package:sampark/sampark_screens/home_Screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../api/apis.dart';
import '../constant/refactors.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  _handleGoogleBtnClick(){
    //for showing progress bar
    Dialogs.showProgressBar(context);

  _signInWithGoogle().then((user) {

    //for hiding progress bar
    Navigator.pop(context);
    if(user!=null){
      log("User :${user.user}");
      log("UserAdditionalInfo : ${user.additionalUserInfo}");
      callNextReplacement(context, Home_Screen());
    }

  },);
  }
  Future<UserCredential?> _signInWithGoogle() async {
    try{
      
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    }
    catch(e){
      print("\n_signInWithGoogle $e");
      Dialogs.showSnackbar(context, "Something went wrong (Check internet)");
      return null;


    }
  }

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatify"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 80,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Lottie.asset("assets/lottie/chat_bubble.json"),
          ),
          Stack(
            children: [
              Positioned(


                  child: SizedBox(
                    width: width/1.2,
                    height: height/15,
                    child: ElevatedButton.icon(

                        onPressed: () {
                          _handleGoogleBtnClick();
                          },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                        icon: Image.asset("assets/images/google.png",scale: 25),
                        label: RichText(text: TextSpan(
                            style: TextStyle(color: Colors.blue.shade600,fontSize: 15),
                          children: [
                            TextSpan(text: "Sign in with "),
                            TextSpan(text: "Google",style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold)),
                          ]

                        ),

                        )
                    ),
                  )
              ),
          ]

          )
        ],
      )
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sampark/api/apis.dart';

class Home_Screen extends StatelessWidget {
  const Home_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatify"),
        leading: Icon(Icons.home),
        actions: [
          IconButton(onPressed: () {
            
          }, icon: Icon(Icons.search) ),
          IconButton(onPressed: () {

          }, icon: Icon(Icons.more_vert) )
        ],

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        
      },
      child: Icon(Icons.add_comment,color: Colors.white,),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}

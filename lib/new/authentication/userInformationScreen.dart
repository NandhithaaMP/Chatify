import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:provider/provider.dart';

import '../../provider/authenticationProvider.dart';
import '../constants/constant.dart';
import '../models/userModel.dart';
import '../utilities/globalMethods.dart';


class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {

  final TextEditingController nameController=TextEditingController();


  @override
  void initState() {
    super.initState();

    // Add listener to reset the state when the user types
    nameController.addListener(() {
      final authProvider = context.read<AuthenticationProvider>();
      if (authProvider.hasAttempted) {
        authProvider.resetState(); // Reset to show the "Continue" button again
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final  authProvider=context.watch<AuthenticationProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("User Information"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 51,
                    backgroundColor: Colors.black12,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:AssetImage("assets/images/user_icon.jpg") ,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                            size: 20,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 30,),
            TextField(
              controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                    labelText: "Enter your name",
                  border: OutlineInputBorder(),

                ),
            ),
              SizedBox(height: 30,),

              if(authProvider.isButtonVisible)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade100,

                    ),
                    onPressed: () {
                      bool isNameValid=nameController.text.isNotEmpty;
                      authProvider.manageCircularProgress(isNameValid);
                    },

                    child: Text("Continue")
                ),

              // Show loading indicator or result after the button is pressed

              if(authProvider.isLoading)
                CircularProgressIndicator()//show circularprogress indicator

              else if(authProvider.hasAttempted)// Show icons only after attempt

                authProvider.isSuccessful?
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check,color: Colors.white,),
                ):

                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.clear,color: Colors.white,),
                )
            ],
          ),
        ),
      ),
    );
  }
  void saveUserDataToFireStore()async{

    final authProvider=context.read<AuthenticationProvider>();

    UserModel userModel=UserModel(
        uid: authProvider.uid!,
        name: nameController.text.trim(),
        phoneNumber: authProvider.phoneNumber!,
        image: "",
        token: "",
        aboutMe: "Hey there,I am using sampark",
        lastSeen: "",
        createdAt: "",
        isOnline: true,
        friendsUIDs: [],
        friendRequestsUIDs: [],
        sentFriendRequestsUIDs: []
    );
    authProvider.saveUserDataToFirestore(
        userModel: userModel,
        onSuccess:(){
          Navigator.of(context).pushReplacementNamed(Constants.homeScreen);
        },
        onFail:() async {
          await Future.delayed(Duration(seconds: 2));
          showSnackBar(context, "Failed to save user data");
        }
    );
  }

}





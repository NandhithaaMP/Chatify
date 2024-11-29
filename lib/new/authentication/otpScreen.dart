import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'package:sampark/provider/authenticationProvider.dart';
import 'package:provider/provider.dart';

import '../constants/constant.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final pcontroller=TextEditingController();
  final focusNode=FocusNode();
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    //get the arguments

    final args=ModalRoute.of(context)!.settings.arguments as Map;
    final verificationId=args[Constants.verificationId] as String;
    final phoneNumber=args[Constants.phoneNumber] as String;

    final authProvider=context.watch<AuthenticationProvider>();

    final defaultPinTheme=PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.openSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
        border: Border.all(
          color: Colors.transparent
        )
      )
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(

              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40,),
                Text("Verification",style: GoogleFonts.openSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
                Text("Enter the 6 -digit code sent the number",style: GoogleFonts.openSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),),
                Text(phoneNumber,style: GoogleFonts.openSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),),
                SizedBox(height: 40,),
                SizedBox(
                  height: 50,
                    child: Pinput(
                      length: 6,
                      controller: pcontroller,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      onCompleted: (pin) {
                        setState(() {
                          otpCode=pin;
                        });
                        
                        //verify the otp code

                        verifyOTPCode(
                            verificationId: verificationId,
                            otpCode: otpCode!
                        );
                        
                        
                      },
                      
                      focusedPinTheme: defaultPinTheme.copyWith(
                        height: 68,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                          border: Border.all(
                            color: Colors.deepPurple
                          )

                        ),


                      ),
                      errorPinTheme: defaultPinTheme.copyWith(
                        height: 68,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.red
                          )
                        )
                      ),
                    ),
                ),
                SizedBox(height: 30,),
                authProvider.isLoading
                    ? CircularProgressIndicator()
                    :  SizedBox.shrink(),

                authProvider.isSuccessful
                    ?Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle
                  ),child: Icon(Icons.check,color: Colors.white,),
                ):SizedBox.shrink(),


                authProvider.isLoading
                ? SizedBox.shrink():

                Text("Didn\'t recive the code?",style: GoogleFonts.openSans(fontSize: 16),),
                SizedBox(height: 10,),

                authProvider.isLoading
                    ? SizedBox.shrink():

                TextButton(onPressed: () {

                  //resend otp code

                }, child: Text("Resend Code",style: GoogleFonts.openSans(fontSize: 18,fontWeight: FontWeight.w600),))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOTPCode({
    required String verificationId ,
    required String otpCode,

  })async {

    final authProvider=context.read<AuthenticationProvider>();
    authProvider.verifyOTPCode(
        verificationId: verificationId,
        otpCode: otpCode,
        context: context,
        onSuccess:() async {
          //1.check if user exists in firestore

          bool userExists=await authProvider.checkUserExists();
          if(userExists){

            //2.if user exists

            //get user information from firestore
            await authProvider.getUserDataFromFirestore();

            //save user information to provider//shared prefereance

            await authProvider.saveUserDataToSharedPreferences();

          // , navigate to home screen

            navigate(userExists:true);
          }else{
            //3.if user doesnt exist,navigate to user information screen
            // Navigator.of(context).pushNamed(Constants.UserInformationScreen);
            navigate(userExists:false);
          }

        }
    );

  }

  void navigate({required bool userExists}) {
    if(userExists){
      //navigate to home  and remove all prevoius routes
      Navigator.pushNamedAndRemoveUntil(context, Constants.homeScreen, (route) => false,);
    }
    else{
      //navigate to user information screen

      Navigator.pushNamed(context, Constants.UserInformationScreen);
    }
  }
}

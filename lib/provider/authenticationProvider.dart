
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../new/constants/constant.dart';
import '../new/models/userModel.dart';
import '../new/utilities/globalMethods.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccessful = false;
  String? _uid;
  String? _phoneNumber;
  UserModel? _userModel;

  bool get isLoading => _isLoading;
  bool get isSuccessful => _isSuccessful;
  String? get uid => _uid;
  String? get phoneNumber => _phoneNumber;
  UserModel? get userModel => _userModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  //check if user exists
  Future<bool> checkUserExists()async{
    DocumentSnapshot documentSnapshot=await db.collection(Constants.users).doc(_uid).get();
    if(documentSnapshot.exists){
      return true;
    }
    else{
      return false;
    }
  }

  //get user data from firestore
  Future<void> getUserDataFromFirestore()async{
    DocumentSnapshot documentSnapshot=await db.collection(Constants.users).doc(_uid).get();
    _userModel=UserModel.fromMap(documentSnapshot.data() as Map<String,dynamic>);
    notifyListeners();
  }

//Save user data to shared preferances

  Future<void> saveUserDataToSharedPreferences()async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences.setString(Constants.userModel,jsonEncode(userModel!.toMap()));
  }

//get data from shared preferences

  Future<void>getUserDataFromSharedPreferences()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String userModelString=sharedPreferences.getString(Constants.userModel)??"";
    _userModel=UserModel.fromMap(jsonDecode(userModelString));
    _uid=_userModel!.uid;
    notifyListeners();
  }



  //Sign in with phone number

  Future<void> signInWithPhooneNumber(
      {
        required String phoneNumber,
        required BuildContext context
      }) async {
    _isLoading = true;
    notifyListeners();
    await _auth.verifyPhoneNumber(

      phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async{
        print("mklll");
        await _auth.signInWithCredential(credential).then((value) async{
          print("hhhhhhh");

          _uid=value.user!.uid;
          _phoneNumber=value.user!.phoneNumber;
          _isSuccessful=true;
          _isLoading=false;
          notifyListeners();
          print("ttttttt");
        },);
        },
        verificationFailed: (FirebaseAuthException e) {
          _isSuccessful=false;
          _isLoading =false;
          notifyListeners();
          showSnackBar(context, e.toString());
          print("Error");

        },
        codeSent: (String verificationId, int? resendToken) async {
           _isLoading=false;
            notifyListeners();
            // navigate to otp Screen
                       print("Navigation to otp screen");
          Navigator.pushNamed(context, Constants.otpScreen,arguments: {
            Constants.verificationId:verificationId,
            Constants.phoneNumber:phoneNumber
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {

        },
    );
  }


    bool _isButtonVisible=true;
    bool get isButtonVisible=>_isButtonVisible;

    bool _hasAttempted=false;
    bool get hasAttempted=>_hasAttempted;

  Future<void> manageCircularProgress(bool isNameValid)async{
    _isLoading=true;
    _isButtonVisible=false;// Hide button when action starts
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));

    _isSuccessful=isNameValid;
    _isLoading=false;
    _hasAttempted=true;// Indicate the user has attempted
    notifyListeners();
  }
  void resetState(){
    _isButtonVisible=true;
    _hasAttempted=false;
    _isSuccessful=false;
    notifyListeners();
  }


  Future<void> verifyOTPCode({
    required String verificationId ,
    required String otpCode,
    required BuildContext context,
    required Function onSuccess
  })async {

    _isLoading=true;
    notifyListeners();

    final credential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);

    await _auth.signInWithCredential(credential).then((value)async {
      _uid=value.user!.uid;
      _phoneNumber=value.user!.phoneNumber;
      _isSuccessful=true;
      _isLoading=false;
      onSuccess();
      notifyListeners();

    },).catchError((e){
      _isSuccessful=false;
      _isLoading=false;
      notifyListeners();
      showSnackBar(context, e.toString());
    });

  }


  void saveUserDataToFirestore({required UserModel userModel,required Function onSuccess,required Function onFail})async{
    _isLoading=true;
    notifyListeners();

    userModel.lastSeen=DateTime.now().microsecondsSinceEpoch.toString();
    userModel.createdAt=DateTime.now().microsecondsSinceEpoch.toString();

    _userModel=userModel;
    _uid=userModel.uid;

    // save user data to firestore
    await db.collection(Constants.users).doc(userModel.uid).set(userModel.toMap());

    _isLoading=false;
    onSuccess();
    notifyListeners();
  }

}





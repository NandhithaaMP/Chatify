import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampark/provider/authenticationProvider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController=TextEditingController();
  Country selectedCountry = Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'India',
    example: 'India',
    displayName: 'India',
    displayNameNoCountryCode: 'IN',
    e164Key: '',
  );
  @override
  void dispose(){
    phoneNumberController.dispose();
     super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // AuthenticationProvider chatPro = Provider.of<AuthenticationProvider>(context, listen: false);
    // AuthenticationProvider authProvider=Provider.of<AuthenticationProvider>(context,listen: true);
    final  authProvider=context.watch<AuthenticationProvider>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie/chat_bubble.json",
                width: 200, height: 200),
            DefaultTextStyle(
              style: GoogleFonts.alumniSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    'SAMPARK',
                    speed: Duration(milliseconds: 300), // Adjust typing speed
                  ),
                ],
                totalRepeatCount: 20,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Add your phone number will send you a code to verify",
              style: GoogleFonts.alumniSans(fontSize: 15, color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),

            TextFormField(
              controller: phoneNumberController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              textInputAction:TextInputAction.done,
              onChanged: (value) {
                setState(() {
                  phoneNumberController.text=value;
                });
              },
              decoration: InputDecoration(
                counterText: "",
                hintText: "Phone Number",
                hintStyle: GoogleFonts.openSans(fontSize: 16,fontWeight: FontWeight.w500),
                prefixIcon:Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          // countryListTheme: CountryListThemeData(
                          //   bottomSheetHeight: 400
                          // ),

                          onSelect: (Country country) {
                              setState(() {
                                selectedCountry=country;
                              });
                          },
                      );
                    },
                    child:Text(
                      // selectedCountry.phoneCode,
                      "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                      style: GoogleFonts.openSans(fontSize: 16,fontWeight:FontWeight.w500),
                    ) ,
                  ),
                ),
                suffixIcon:phoneNumberController.text.length >9
                    ? authProvider.isLoading
                    ? const CircularProgressIndicator():


                InkWell(
                  onTap: () {
                    //sign in with phone number
                    authProvider.signInWithPhooneNumber(
                        phoneNumber: "+${selectedCountry.phoneCode}${phoneNumberController.text}",
                        context: context);
                  },
                  child: Container(
                    height:20 ,
                    width: 20,
                    margin:EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                     shape: BoxShape.circle
                    ),
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ) :null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode=false;

  //get the saved theme mode
  void getThemedMode(){
    final savedThemeMode=AdaptiveTheme.getThemeMode();
    //check if the saved theme mode is dark
    if(savedThemeMode==AdaptiveThemeMode.dark){
      setState(() {
        isDarkMode=true;
      });
    }
    else{
      setState(() {
        isDarkMode=false;
      });
    }
  }
  @override

  void initState(){
    getThemedMode();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child:Card(
                child: SwitchListTile(
                  title: const Text("Change theme"),
                  secondary: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode?Colors.white:Colors.black
                    ),
                    child: Icon(
                      isDarkMode?Icons.nightlight_round:Icons.wb_sunny_rounded,
                      color: isDarkMode?Colors.black:Colors.white,
                    ),
                  ),
                  value: isDarkMode,
                  onChanged: (value) {
                    //set the isdarkmode to the value
                    setState(() {
                      isDarkMode=value;
                    });
                    //check the value is true
                    if(value){
                      //set the theme mode to dark
                      AdaptiveTheme.of(context).setDark();
                    }
                    else{
                      AdaptiveTheme.of(context).setLight();
                    }
                  },
                ),
              )
          )
        ],
      ),
    );
  }
}

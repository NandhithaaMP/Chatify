import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

callNextReplacement(var context,var className){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => className,));
}
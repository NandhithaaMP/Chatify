import 'package:flutter/cupertino.dart';

callNextPushNamed(var context,var routeName){
  Navigator.pushNamed(context, routeName);
}
callNext(var context,var routeName){
  Navigator.push(context, routeName);
}
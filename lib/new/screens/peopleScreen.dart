import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeoplesScreen extends StatefulWidget {
  const PeoplesScreen({super.key});

  @override
  State<PeoplesScreen> createState() => _PeoplesScreenState();
}

class _PeoplesScreenState extends State<PeoplesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Peoples"),
      ),
    );
  }
}

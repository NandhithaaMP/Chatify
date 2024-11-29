import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/authenticationProvider.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  final nameController = TextEditingController();

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
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 100),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  labelText: "Enter your name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Show button only if it's visible
              if (authProvider.isButtonVisible)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade100,
                  ),
                  onPressed: () {
                    bool isNameValid = nameController.text.isNotEmpty;
                    authProvider.manageCircularProgress(isNameValid);
                  },
                  child: Text("Continue"),
                ),

              // Show loading indicator or result after the button is pressed
              if (authProvider.isLoading)
                CircularProgressIndicator()
              else if (authProvider.hasAttempted) // Show icons only after attempt
                authProvider.isSuccessful
                    ? CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                )
                    : CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}


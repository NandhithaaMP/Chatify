import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:sampark/new/screens/peopleScreen.dart';


import '../utilities/assets_manager.dart';
import 'chatsListScreen.dart';
import 'groupsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex=0;
  final PageController pageController=PageController(initialPage: 0);
  
  final List<Widget> pages=[
    ChatListScreen(),
    GroupsScreen(),
    PeoplesScreen()

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SAMPARK"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              // backgroundImage: AssetImage(AssetsManager.userImage),
              backgroundColor: Colors.deepOrangeAccent,
            ),
          )
        ],
      ),
      body: PageView(

        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex=index;
          });
        },
        children: pages
      ),

      bottomNavigationBar:
          BottomNavigationBar(
              items:
                  [
                  BottomNavigationBarItem(
                       icon: Icon(CupertinoIcons.chat_bubble_2),
                      label: "Chats"
                  ),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.group),
                      label: "Groups"
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.globe),
                      label: "People"
                    )
                  ],
            currentIndex: currentIndex,
            onTap: (index) {
                pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              setState(() {
                currentIndex=index;
              });
              print("index:$currentIndex");
            },
          ),

    );
  }
}

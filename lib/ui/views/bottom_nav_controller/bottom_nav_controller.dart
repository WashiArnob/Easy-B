import 'package:app_by_washi/ui/views/bottom_nav_controller/home.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/message.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/notification.dart';
import 'package:flutter/material.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {

  int _currentIndex = 0;
  final _pages = [
    HomeScreen(),
    NotificationScreen(),
    MessageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.deepPurpleAccent,
        backgroundColor: Colors.lightBlueAccent,
        currentIndex: _currentIndex,
        onTap: (int index){
          _currentIndex = index;
          setState(() {

          });

        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home', backgroundColor: Colors.black54,),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Notifications', backgroundColor: Colors.black54,),
          BottomNavigationBarItem(icon: Icon(Icons.message_rounded), label: 'Messages', backgroundColor: Colors.black54,),

        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}

import 'dart:async';
import 'package:app_by_washi/ui/views/authentications/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _setupAnimation();
  }

  void _startTimer() {
    Timer(Duration(seconds: 4), () {
      Get.to(() => Login());
    });
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              'assets/logos/Easy_B_logo-white.png',
              width: 400,
            ),
          ),
        ),
      ),
    );
  }
}




















// import 'dart:async';
// import 'package:app_by_washi/ui/views/authentications/login.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     Timer(Duration(seconds: 3), () {
//       // Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
//       Get.to(()=>Login());
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent,
//       body: Center(
//         child: Image(
//           image: AssetImage('assets/logos/Easy_B_logo-white.png'),
//           width: 400,
//         ),
//       ),
//     );
//   }
// }

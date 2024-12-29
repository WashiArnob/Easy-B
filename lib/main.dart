import 'package:app_by_washi/ui/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy B',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent) ),
      ),
      initialRoute: splash,
      getPages: getPages,
     // home: SplashScreen()
    );
  }
}

//git repo update =
// git add .
// git commit -m"commit-msg"
// git push -u origin main

// git repo add =
// git init
// git status (optional)
// git add .
// git status (optional)
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/WashiArnob/My-App.git
// git push -u origin main



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

//new task
//1.home page e weekly and daily sell total show korate hobe- done
//2.home page e order collection er recent data show korate hobe -done
//3.add button e click korle daily data show korabe -done
//4.sell details page e daily/weekly/monthly data total shoho show korate hobe -done
//5.drawer screen e shop er name firebase theke show korate hobe-done
//6.edit shop profile screen e shop er photo update korte hobe-done


// {
//   "project_info": {
//     "project_number": "55915551582",
//     "project_id": "app-by-washi",
//     "storage_bucket": "app-by-washi.appspot.com"
//   },
//   "client": [
//     {
//       "client_info": {
//         "mobilesdk_app_id": "1:55915551582:android:ffac9856960e0580970dcf",
//         "android_client_info": {
//           "package_name": "com.example.app_by_washi"
//         }
//       },
//       "oauth_client": [
//         {
//           "client_id": "55915551582-l4eak0si7ngabq9rvqaufcduubkvlu3f.apps.googleusercontent.com",
//           "client_type": 3
//         }
//       ],
//       "api_key": [
//         {
//           "current_key": "AIzaSyCF89T3wm71t7MjaYRKgJsmcMM9XE-iRmk"
//         }
//       ],
//       "services": {
//         "appinvite_service": {
//           "other_platform_oauth_client": [
//             {
//               "client_id": "55915551582-l4eak0si7ngabq9rvqaufcduubkvlu3f.apps.googleusercontent.com",
//               "client_type": 3
//             }
//           ]
//         }
//       }
//     }
//   ],
//   "configuration_version": "1"
// }
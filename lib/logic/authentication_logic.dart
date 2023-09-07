

import 'package:app_by_washi/ui/views/drawer_screen/dashboard.dart';
import 'package:app_by_washi/ui/views/authentications/login.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/bottom_nav_controller.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

registration(emailAddress,password)async{
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    var authCredential=credential.user;
    if(authCredential!.uid.isNotEmpty){
      Get.to(()=>Login());
    }


  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}


login(emailAddress,password)async{
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
    );
    var authCredential=credential.user;
    if(authCredential!.uid.isNotEmpty){
      Get.to(()=>DashboardBusiness());
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } catch (e) {
    print(e);
  }
}


 logOut()async{
  try{
    await FirebaseAuth.instance.signOut().then((value) => Get.to(Login()));
  }catch (e) {
    print(e);
  }
 }
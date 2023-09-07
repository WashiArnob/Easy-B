import 'package:app_by_washi/constant/appColors.dart';
import 'package:app_by_washi/logic/authentication_logic.dart';
import 'package:app_by_washi/ui/custom_widgets/custom_text.dart';
import 'package:app_by_washi/ui/custom_widgets/custom_textfield.dart';
import 'package:app_by_washi/ui/style/styles.dart';
import 'package:app_by_washi/ui/views/drawer_screen/dashboard.dart';
import 'package:app_by_washi/ui/views/authentications/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formkey= GlobalKey<FormState>();
  String? passwordError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),


            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Image.asset(
                    'assets/logos/easy_b_logo.png',
                    width: 120,
                  ),
                  SizedBox(height: 30,),
                  boldText('Business Account log in', AppColor.darkColor),
                  SizedBox(height: 50,),

                  // TextButton(
                  //   onPressed: () {},
                  //   child: Text(
                  //     'Or switch to Customer Login',
                  //     style: TextStyle(
                  //         color: AppColor.blueColor,
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  customTextField(emailController, 'Enter Email', 'Enter Valid Email',TextInputType.text,(String? value){
                    if(value!.isEmpty){
                      return "This field can't be empty";
                    }
                  }
                  ),

                  AppStyle.bigSpacer,

                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(1.0), // Set the desired opacity value here
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.circular(12),

                      ),
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      errorText: passwordError,

                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onChanged: (String value) {
                      if (value.isEmpty) {
                        setState(() {
                          passwordError = "This field can't be empty";
                        });
                      } else {
                        setState(() {
                          passwordError = null;
                        });
                      }
                    },
                  ),

                  // customTextField(passwordController, 'Password', 'Enter your password',TextInputType.text,
                  //     (String? value){
                  //   if(value!.isEmpty){
                  //     return "This field can't be empty";
                  //   }
                  // }),

                  AppStyle.bigSpacer,

                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()){
                              login(emailController.text, passwordController.text);
                            }else{
                              Get.snackbar('Warning', 'All the fields are required');
                            }
                            setState(() {
                              emailController.clear();
                              passwordController.clear();
                            });
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardBusiness()));
                          },
                          child: Text(
                            'LogIn',
                            style: TextStyle(color: AppColor.whiteColor, fontSize: 25),
                          ))),

                  AppStyle.bigSpacer,

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(
                            color: AppColor.blueColor, fontSize: 15),
                      ),
                    ),
                  ),

                  AppStyle.smallSpacer,

                  RichText(
                      text: TextSpan(
                          text: 'Don\'t have any account? ',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          children: [
                        TextSpan(
                            text: ' Sign Up',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:AppColor.blueColor),

                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupBusiness()))),
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Row(children: [
//   Expanded(child:  customTextField(emailContoller, '', ''),),
//
//   Expanded(child:  customTextField(passwordContoller, '', ''),),
// ],),
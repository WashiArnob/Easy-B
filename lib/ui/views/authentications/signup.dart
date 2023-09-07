import 'package:app_by_washi/constant/appColors.dart';
import 'package:app_by_washi/logic/authentication_logic.dart';
import 'package:app_by_washi/ui/custom_widgets/custom_text.dart';
import 'package:app_by_washi/ui/custom_widgets/custom_textfield.dart';
import 'package:app_by_washi/ui/style/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupBusiness extends StatefulWidget {
  const SignupBusiness({Key? key}) : super(key: key);

  @override
  _SignupBusinessState createState() => _SignupBusinessState();
}

class _SignupBusinessState extends State<SignupBusiness> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController nidController = TextEditingController();
  final TextEditingController tinController = TextEditingController();
  final TextEditingController shopnameController = TextEditingController();
  final TextEditingController shoptypeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Initial Selected Value
  String dropdownvalue = 'Shop Type';
  String dropdownvaluenationality = 'Select Country';

  // List of items in our dropdown menu
  var items = [
    'Shop Type',
    'Grocery Shop',
    'Medicine Shop',
    'Restaurant',
    'Chicken Shop',
    'Fruit Shop',
  ];

  var n_items = [
    'Select Country',
    'Bangladesh'
    'India',
    'Japan',
    'U.S.A',
    'China',
    'Korea',
  ];

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formkey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      ),
                    ),
                    Container(
                        child: boldText(
                            'Sign Up Business Account', AppColor.darkColor)),
                    TextButton(
                        onPressed: () {},
                        child: boldText('Or switch to Customer Sign Up',
                            AppColor.blueColor)),
                    customTextField(nameController, 'Enter Name',
                        'Enter Full Name', TextInputType.text, (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                    }),
                    AppStyle.smallSpacer,
                    Row(
                      children: [
                        Expanded(
                            child: customTextField(
                                usernameController,
                                'enter UserName',
                                'Enter UserName',
                                TextInputType.text, (String? value) {
                          if (value!.isEmpty) {
                            return "This field can't be empty";
                          }
                        })),
                        AppStyle.horizontallySpace,
                        Expanded(
                            child: customTextField(
                                dateofbirthController,
                                'Date of Birth',
                                'Enter Date of Birth',
                                TextInputType.text, (String? value) {
                          if (value!.isEmpty) {
                            return "This field can't be empty";
                          }
                        })),
                      ],
                    ),
                    AppStyle.smallSpacer,
                    customTextField(
                        emailController,
                        'Enter Email',
                        'Enter Valid Email',
                        TextInputType.text, (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                      if (!value.contains(RegExp(r'\@'))) {
                        return 'enter a valid email address';
                      }
                    }),
                    AppStyle.smallSpacer,
                    customTextField(
                        passwordController,
                        'Password',
                        'Enter your password',
                        TextInputType.text, (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                    }),
                    AppStyle.smallSpacer,
                    customTextField(
                        confirmPasswordController,
                        'Confirm Password',
                        'Confirm your password',
                        TextInputType.text, (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                    }),
                    AppStyle.smallSpacer,
                    Row(
                      children: [
                        Expanded(
                          child: customTextField(
                              phoneController,
                              'Phone',
                              'Enter Your Phone Number',
                              TextInputType.phone, (String? value) {
                            if (value!.isEmpty) {
                              return "This field can't be empty";
                            }
                          }),
                        ),
                        AppStyle.horizontallySpace,
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(2.0),
                          height: 60,
                          //  width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black54),
                            color: Colors.grey.shade200,
                          ),

                          child: Center(
                            child: DropdownButtonFormField(
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              value: dropdownvaluenationality,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              validator: (value) => value == 'Select Country'
                                  ? 'field required'
                                  : null,
                              // Array list of items
                              items: n_items.map((String n_items) {
                                return DropdownMenuItem(
                                  value: n_items,
                                  child: Center(child: Text(n_items)),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? new_n_Value) {
                                setState(() {
                                  dropdownvaluenationality = new_n_Value!;
                                });
                              },
                            ),
                          ),
                        ))
                      ],
                    ),
                    AppStyle.smallSpacer,
                    Row(
                      children: [
                        Expanded(
                            child: customTextField(
                                nidController,
                                'NID',
                                'Enter Your NID',
                                TextInputType.text, (String? value) {
                          if (value!.isEmpty) {
                            return "This field can't be empty";
                          } else if (value.length < 11) {
                            return 'Please enter valid nid number';
                          }
                        })),
                        AppStyle.horizontallySpace,
                        Expanded(
                            child: customTextField(
                                tinController,
                                'TIN ID',
                                'Enter Your TIN ID',
                                TextInputType.text, (String? value) {
                          if (value!.isEmpty) {
                            return "This field can't be empty";
                          }
                        })),
                      ],
                    ),
                    AppStyle.smallSpacer,
                    Row(
                      children: [
                        Expanded(
                          child: customTextField(
                              shopnameController,
                              'Shop Name',
                              'Enter Shop Name',
                              TextInputType.text, (String? value) {
                            if (value!.isEmpty) {
                              return "This field can't be empty";
                            }
                          }),
                        ),
                        AppStyle.horizontallySpace,
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(2.0),
                          height: 60,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black54),
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: DropdownButtonFormField(
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              value: dropdownvalue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              validator: (value) => value == 'Shop Type'
                                  ? 'field required'
                                  : null,
                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Center(child: Text(items)),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                    AppStyle.smallSpacer,
                    customTextField(addressController, 'Address',
                        'Enter Address', TextInputType.text, (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                    }),
                    AppStyle.bigSpacer,
                    SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () async {
                              try {
                                // store data
                                if (nameController.text.isEmpty ||
                                    nameController.text.isEmpty) {
                                  String errorMessage = '';
                                  if (nameController.text.isEmpty) {
                                    errorMessage +=
                                        'Product name can\'t be empty\n';
                                  }

                                  if (emailController.text.isEmpty) {
                                    errorMessage += 'Email can\'t be empty\n';
                                  }
                                  if (passwordController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (confirmPasswordController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (usernameController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (dateofbirthController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (phoneController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (nationalityController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (nidController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (tinController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (shopnameController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (shoptypeController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }
                                  if (addressController.text.isEmpty) {
                                    errorMessage +=
                                        'Product Price can\'t be empty\n';
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text(errorMessage),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  registration( emailController.text.toString(),  passwordController.text.toString());
                                  await FirebaseFirestore.instance
                                      .collection('business_user_profile')
                                      .add({
                                    'name': nameController.text.toString(),
                                    'email-id': emailController.text.toString(),
                                    'password':
                                        passwordController.text.toString(),
                                    'confirm-password':
                                        confirmPasswordController.text
                                            .toString(),
                                    'username':
                                        usernameController.text.toString(),
                                    'date-of-birth':
                                        dateofbirthController.text.toString(),
                                    'phone-number':
                                        phoneController.text.toString(),
                                    'nid-number': nidController.text.toString(),
                                    'tin-number': tinController.text.toString(),
                                    'shop-name':
                                        shopnameController.text.toString(),
                                    'address':
                                        addressController.text.toString(),
                                    'shop-type': dropdownvalue,
                                    'country': dropdownvaluenationality,
                                  });

                                  // Clear the form fields
                                  emailController.clear();
                                  passwordController.clear();
                                  nameController.clear();
                                  usernameController.clear();
                                  dateofbirthController.clear();
                                  confirmPasswordController.clear();
                                  phoneController.clear();
                                  nidController.clear();
                                  tinController.clear();
                                  shopnameController.clear();
                                  addressController.clear();
                                  dropdownvalue = 'Shop Type';
                                  dropdownvaluenationality = 'Select Country';

                                  setState(() {});
                                }
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: AppColor.whiteColor, fontSize: 25),
                            ))),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

// if (formkey.currentState!.validate()) {
//   registration(emailController.text,
//       passwordController.text);
// } else {
//   //  print('All the field are required');
//   Get.snackbar(
//       'Warning', 'All the fields are required');
// }

// setState(() {
//   emailController.clear();
//   passwordController.clear();
//   nameController.clear();
//   usernameController.clear();
//   dateofbirthController.clear();
//   confirmPasswordController.clear();
//   phoneController.clear();
//   nidController.clear();
//   tinController.clear();
//   shopnameController.clear();
//   addressController.clear();
//   dropdownvalue = 'Shop Type';
//   dropdownvaluenationality = 'Select Country';
// })
// ;

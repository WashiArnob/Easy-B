import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class BusinessmanProfile extends StatefulWidget {
  const BusinessmanProfile({Key? key}) : super(key: key);

  @override
  _BusinessmanProfileState createState() => _BusinessmanProfileState();
}

class _BusinessmanProfileState extends State<BusinessmanProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopTypeController = TextEditingController();
  TextEditingController nidController = TextEditingController();
  TextEditingController tinController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    dobController.dispose();
    countryController.dispose();
    addressController.dispose();
    phoneController.dispose();
    shopNameController.dispose();
    shopTypeController.dispose();
    nidController.dispose();
    tinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 5,
        title: Text(
          'View Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('business_user_profile')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }

          final indexdata =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final docId = snapshot.data!.docs.first.id;

          nameController.text = indexdata['name'];
          usernameController.text = indexdata['username'];
          emailController.text = indexdata['email-id'];
          dobController.text = indexdata['date-of-birth'];
          countryController.text = indexdata['country'];
          addressController.text = indexdata['address'];
          phoneController.text = indexdata['phone-number'];
          shopNameController.text = indexdata['shop-name'];
          shopTypeController.text = indexdata['shop-type'];
          nidController.text = indexdata['nid-number'];
          tinController.text = indexdata['tin-number'];

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    image == null
                        ? IconButton(
                            onPressed: () async {
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {});
                            },
                            icon: Icon(Icons.add_a_photo),
                          )
                        : Image.file(
                            File(image!.path),
                            height: 150,
                            fit: BoxFit.cover,
                          );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      image == null
                          ? Container(
                              height: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(indexdata['shop-url']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Image.file(
                              File(image!.path),
                              height: 350,
                              fit: BoxFit.cover,
                            ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Business Profile',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Divider(),
                buildDetailItem('Name', nameController),
                Divider(),
                buildDetailItem('User Name', usernameController),
                Divider(),
                buildDetailItem('Email', emailController),
                Divider(),
                buildDetailItem('Date of Birth', dobController),
                Divider(),
                buildDetailItem('Country', countryController),
                Divider(),
                buildDetailItem('Address', addressController),
                Divider(),
                buildDetailItem('Phone Number', phoneController),
                Divider(),
                buildDetailItem('Shop Name', shopNameController),
                Divider(),
                buildDetailItem('Shop Type', shopTypeController),
                Divider(),
                buildDetailItem('NID Number', nidController),
                Divider(),
                buildDetailItem('TIN Number', tinController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Save Changes'),
                          content: Text(
                            'Are you sure you want to save the changes?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                File imgFile = File(image!.path);
                                // upload storage
                                UploadTask _uploadtask = FirebaseStorage
                                    .instance
                                    .ref('images')
                                    .child(image!.name)
                                    .putFile(imgFile);
                                TaskSnapshot snapshot = await _uploadtask;
                                // get the image download link/url
                                var imageUrl =
                                    await snapshot.ref.getDownloadURL();
                                 await snapshot.ref
                                    .getDownloadURL()
                                    .then((value) {
                                  FirebaseFirestore.instance
                                      .collection('business_user_profile')
                                      .doc(docId)
                                      .update({
                                    'name': nameController.text,
                                    'username': usernameController.text,
                                    'email-id': emailController.text,
                                    'date-of-birth': dobController.text,
                                    'country': countryController.text,
                                    'address': addressController.text,
                                    'phone-number': phoneController.text,
                                    'shop-name': shopNameController.text,
                                    'shop-type': shopTypeController.text,
                                    'nid-number': nidController.text,
                                    'tin-number': tinController.text,
                                    'shop-url': imageUrl
                                  });
                                  final box = GetStorage();
                                  box.write('imgUrl', imageUrl);
                                  
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Save Changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDetailItem(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            style: TextStyle(fontSize: 15, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







//main code v2
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class BusinessmanProfile extends StatefulWidget {
//   const BusinessmanProfile({Key? key}) : super(key: key);
//
//   @override
//   _BusinessmanProfileState createState() => _BusinessmanProfileState();
// }
//
// class _BusinessmanProfileState extends State<BusinessmanProfile> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   TextEditingController countryController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController shopNameController = TextEditingController();
//   TextEditingController shopTypeController = TextEditingController();
//   TextEditingController nidController = TextEditingController();
//   TextEditingController tinController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 5,
//         title: Text(
//           'View Details',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//         ),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('business_user_profile')
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No data found'));
//           }
//
//           final indexdata =
//           snapshot.data!.docs.first.data() as Map<String, dynamic>;
//           final docId = snapshot.data!.docs.first.id;
//
//           nameController.text = indexdata['name'];
//           usernameController.text = indexdata['username'];
//           emailController.text = indexdata['email-id'];
//           dobController.text = indexdata['date-of-birth'];
//           countryController.text = indexdata['country'];
//           addressController.text = indexdata['address'];
//           phoneController.text = indexdata['phone-number'];
//           shopNameController.text = indexdata['shop-name'];
//           shopTypeController.text = indexdata['shop-type'];
//           nidController.text = indexdata['nid-number'];
//           tinController.text = indexdata['tin-number'];
//
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   'View Details',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Business Profile',
//                   style: TextStyle(fontSize: 12, color: Colors.black45),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 Divider(),
//                 buildDetailItem('Name', nameController),
//                 Divider(),
//                 buildDetailItem('Username', usernameController),
//                 Divider(),
//                 buildDetailItem('Email', emailController),
//                 Divider(),
//                 buildDetailItem('Date of Birth', dobController),
//                 Divider(),
//                 buildDetailItem('Country', countryController),
//                 Divider(),
//                 buildDetailItem('Address', addressController),
//                 Divider(),
//                 buildDetailItem('Phone Number', phoneController),
//                 Divider(),
//                 buildDetailItem('Shop Name', shopNameController),
//                 Divider(),
//                 buildDetailItem('Shop Type', shopTypeController),
//                 Divider(),
//                 buildDetailItem('NID Number', nidController),
//                 Divider(),
//                 buildDetailItem('TIN Number', tinController),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     FirebaseFirestore.instance
//                         .collection('business_user_profile')
//                         .doc(docId)
//                         .update({
//                       'name': nameController.text,
//                       'username': usernameController.text,
//                       'email-id': emailController.text,
//                       'date-of-birth': dobController.text,
//                       'country': countryController.text,
//                       'address': addressController.text,
//                       'phone-number': phoneController.text,
//                       'shop-name': shopNameController.text,
//                       'shop-type': shopTypeController.text,
//                       'nid-number': nidController.text,
//                       'tin-number': tinController.text,
//                     });
//                   },
//                   child: Text('Save Changes'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildDetailItem(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 4),
//           TextField(
//             controller: controller,
//             style: TextStyle(fontSize: 15, color: Colors.black),
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//




















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class BusinessmanProfile extends StatefulWidget {
//   const BusinessmanProfile({Key? key}) : super(key: key);
//
//   @override
//   _BusinessmanProfileState createState() => _BusinessmanProfileState();
// }
//
// class _BusinessmanProfileState extends State<BusinessmanProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 5,
//         title: Text('View Details', style: TextStyle(color: Colors.black),),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//         ),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//           future: FirebaseFirestore.instance.collection('business_user_profile')
//               .get(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error'));
//             }
//             return SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//               Center(
//               child: Text(
//               indexdata['name'],
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: 5),
//             Center(
//             child: Text(
//             indexdata['username'],
//             style: TextStyle(fontSize: 12, color: Colors.black45),
//             textAlign: TextAlign.center,
//             ),
//             ),
//             SizedBox(height: 5),
//             Center(
//             child: Text(
//             indexdata['email-id'],
//             style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//             ),
//                 ],
//               ),
//
//             );
//           }
//       ),
//
//     );
//   }
// }
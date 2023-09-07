import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WholesalerDetails extends StatefulWidget {
  const WholesalerDetails({Key? key}) : super(key: key);

  @override
  _WholesalerDetailsState createState() => _WholesalerDetailsState();
}

class _WholesalerDetailsState extends State<WholesalerDetails> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController sellerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool showWholesalerDetails = false;
  var dataa;

  @override
  void dispose() {
    productNameController.dispose();
    sellerNameController.dispose();
    phoneNumberController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Wholesaler Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add Wholesaler'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildTextField('Product Name', productNameController),
                              buildTextField('Seller Name', sellerNameController),
                              buildTextField('Phone Number', phoneNumberController),
                              buildTextField('Company Name', companyNameController),
                              buildTextField('Email', emailController),
                              buildTextField('Address', addressController),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              addWholesaler();
                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add Wholesaler'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Update or Delete Wholesaler'),
                        content: SingleChildScrollView(
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildTextField('Product Name', productNameController),
                              buildTextField('Seller Name', sellerNameController),
                              buildTextField('Phone Number', phoneNumberController),
                              buildTextField('Company Name', companyNameController),
                              buildTextField('Email', emailController),
                              buildTextField('Address', addressController),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              updateWholesaler();
                              Navigator.pop(context);
                            },
                            child: Text('Update'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteWholesaler();
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Update or Delete Wholesaler'),
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  'Wholesaler Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('info_wholesell').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final wholesalers = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: wholesalers.length,
                    itemBuilder: (context, index) {
                      final wholesaler = wholesalers[index].data() as Map<String, dynamic>;
                      dataa = snapshot.data!.docs[index];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(wholesaler['seller_name']),
                          subtitle: Text(wholesaler['company_name']),
                          onTap: () {
                            setState(() {
                              showWholesalerDetails = true;
                              productNameController.text = wholesaler['product_name'];
                              sellerNameController.text = wholesaler['seller_name'];
                              phoneNumberController.text = wholesaler['phone_number'];
                              companyNameController.text = wholesaler['company_name'];
                              emailController.text = wholesaler['email'];
                              addressController.text = wholesaler['address'];
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              if (showWholesalerDetails) ...[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Wholesaler Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                buildDetailRow('Product Name', productNameController.text),
                Divider(),
                buildDetailRow('Seller Name', sellerNameController.text),
                Divider(),
                buildDetailRow('Phone Number', phoneNumberController.text),
                Divider(),
                buildDetailRow('Company Name', companyNameController.text),
                Divider(),
                buildDetailRow('Email', emailController.text),
                Divider(),
                buildDetailRow('Address', addressController.text),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label + ":",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  void addWholesaler() {
    final Map<String, dynamic> data = {
      'product_name': productNameController.text,
      'seller_name': sellerNameController.text,
      'phone_number': phoneNumberController.text,
      'company_name': companyNameController.text,
      'email': emailController.text,
      'address': addressController.text,
    };

    FirebaseFirestore.instance.collection('info_wholesell').add(data);
    clearTextFields();
  }

  void updateWholesaler() {
    final Map<String, dynamic> data = {
      'product_name': productNameController.text,
      'seller_name': sellerNameController.text,
      'phone_number': phoneNumberController.text,
      'company_name': companyNameController.text,
      'email': emailController.text,
      'address': addressController.text,
    };

    FirebaseFirestore.instance.collection('info_wholesell').doc(dataa.id).update(data);
    clearTextFields();
  }

  void deleteWholesaler() {
    FirebaseFirestore.instance.collection('info_wholesell').doc(dataa.id).delete();
    clearTextFields();
  }

  void clearTextFields() {
    productNameController.clear();
    sellerNameController.clear();
    phoneNumberController.clear();
    companyNameController.clear();
    emailController.clear();
    addressController.clear();
  }
}




























// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class WholesalerDetails extends StatefulWidget {
//   const WholesalerDetails({Key? key}) : super(key: key);
//
//   @override
//   _WholesalerDetailsState createState() => _WholesalerDetailsState();
// }
//
// class _WholesalerDetailsState extends State<WholesalerDetails> {
//   TextEditingController productNameController = TextEditingController();
//   TextEditingController sellerNameController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController companyNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   bool showWholesalerDetails = false;
//   var dataa;
//
//   @override
//   void dispose() {
//     productNameController.dispose();
//     sellerNameController.dispose();
//     phoneNumberController.dispose();
//     companyNameController.dispose();
//     emailController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Wholesaler Details',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//         ),
//         elevation: 4,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Add Wholesaler'),
//                         content: SingleChildScrollView(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               buildTextField('Product Name', productNameController),
//                               buildTextField('Seller Name', sellerNameController),
//                               buildTextField('Phone Number', phoneNumberController),
//                               buildTextField('Company Name', companyNameController),
//                               buildTextField('Email', emailController),
//                               buildTextField('Address', addressController),
//                             ],
//                           ),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               addWholesaler();
//                               Navigator.pop(context);
//                             },
//                             child: Text('Add'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text('Add Wholesaler'),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Update Wholesaler'),
//                         content: SingleChildScrollView(
//                           child:  Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               buildTextField('Product Name', productNameController),
//                               buildTextField('Seller Name', sellerNameController),
//                               buildTextField('Phone Number', phoneNumberController),
//                               buildTextField('Company Name', companyNameController),
//                               buildTextField('Email', emailController),
//                               buildTextField('Address', addressController),
//                             ],
//                           ),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               updateWholesaler();
//                               Navigator.pop(context);
//                             },
//                             child: Text('Update'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text('Update Wholesaler'),
//               ),
//               SizedBox(height: 15),
//               Center(
//                 child: Text(
//                   'Wholesaler Information',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 10),
//               StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('info_wholesell').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//
//                   final wholesalers = snapshot.data!.docs;
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: wholesalers.length,
//                     itemBuilder: (context, index) {
//                       final wholesaler = wholesalers[index].data() as Map<String, dynamic>;
//                        dataa = snapshot.data!.docs[index];
//                       return Card(
//                         elevation: 2,
//                         child: ListTile(
//                           title: Text(wholesaler['seller_name']),
//                           subtitle: Text(wholesaler['company_name']),
//                           onTap: () {
//                             setState(() {
//                               showWholesalerDetails = true;
//                               productNameController.text = wholesaler['product_name'];
//                               sellerNameController.text = wholesaler['seller_name'];
//                               phoneNumberController.text = wholesaler['phone_number'];
//                               companyNameController.text = wholesaler['company_name'];
//                               emailController.text = wholesaler['email'];
//                               addressController.text = wholesaler['address'];
//                             });
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//               if (showWholesalerDetails) ...[
//                 SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     'Wholesaler Details',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Divider(),
//                 buildDetailRow('Product Name', productNameController.text),
//                 Divider(),
//                 buildDetailRow('Seller Name', sellerNameController.text),
//                 Divider(),
//                 buildDetailRow('Phone Number', phoneNumberController.text),
//                 Divider(),
//                 buildDetailRow('Company Name', companyNameController.text),
//                 Divider(),
//                 buildDetailRow('Email', emailController.text),
//                 Divider(),
//                 buildDetailRow('Address', addressController.text),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           TextField(
//             controller: controller,
//             style: TextStyle(fontSize: 16),
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Text(
//             label + ":",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(width: 8),
//           Text(value),
//         ],
//       ),
//     );
//   }
//
//   void addWholesaler() {
//     final Map<String, dynamic> data = {
//       'product_name': productNameController.text,
//       'seller_name': sellerNameController.text,
//       'phone_number': phoneNumberController.text,
//       'company_name': companyNameController.text,
//       'email': emailController.text,
//       'address': addressController.text,
//     };
//
//     FirebaseFirestore.instance.collection('info_wholesell').add(data);
//     clearTextFields();
//   }
//
//   void updateWholesaler() {
//     final Map<String, dynamic> data = {
//       'product_name': productNameController.text,
//       'seller_name': sellerNameController.text,
//       'phone_number': phoneNumberController.text,
//       'company_name': companyNameController.text,
//       'email': emailController.text,
//       'address': addressController.text,
//     };
//
//     FirebaseFirestore.instance.collection('info_wholesell').doc(dataa.id).update(data);
//     clearTextFields();
//   }
//
//   void clearTextFields() {
//     productNameController.clear();
//     sellerNameController.clear();
//     phoneNumberController.clear();
//     companyNameController.clear();
//     emailController.clear();
//     addressController.clear();
//   }
// }
//

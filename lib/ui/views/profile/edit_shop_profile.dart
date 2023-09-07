import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditShopProfile extends StatefulWidget {
  const EditShopProfile({Key? key}) : super(key: key);

  @override
  _EditShopProfileState createState() => _EditShopProfileState();
}

class _EditShopProfileState extends State<EditShopProfile> {
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopTypeController = TextEditingController();
  TextEditingController nidController = TextEditingController();
  TextEditingController tinController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late String docId; // Variable to store the document ID

  @override
  void initState() {
    super.initState();
    // Fetch the document ID from the database
    fetchDocumentId();
  }

  Future<void> fetchDocumentId() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('business_user_profile')
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      docId = snapshot.docs.first.id;
      shopNameController.text = data['shop-name'];
      shopTypeController.text = data['shop-type'];
      nidController.text = data['nid-number'];
      tinController.text = data['tin-number'];
      emailController.text = data['email-id'];
      addressController.text = data['address'];
      phoneController.text = data['phone-number'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: Text(
          'Edit Shop Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Add image upload functionality
                  // Implement your logic to change the image here
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('assets/images/shop.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
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
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Edit Shop Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              buildDetailItem('Shop Name', shopNameController),
              SizedBox(height: 12),
              buildDetailItem('Shop Type', shopTypeController),
              SizedBox(height: 12),
              buildDetailItem('NID Number', nidController),
              SizedBox(height: 12),
              buildDetailItem('TIN Number', tinController),
              SizedBox(height: 12),
              buildDetailItem('Email', emailController),
              SizedBox(height: 12),
              buildDetailItem('Address', addressController),
              SizedBox(height: 12),
              buildDetailItem('Phone', phoneController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateShopProfile();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateShopProfile() {
    FirebaseFirestore.instance
        .collection('business_user_profile')
        .doc(docId)
        .update({
      'shop-name': shopNameController.text,
      'shop-type': shopTypeController.text,
      'nid-number': nidController.text,
      'tin-number': tinController.text,
      'email-id': emailController.text,
      'address': addressController.text,
      'phone-number': phoneController.text,
    });

    Navigator.pop(context);
  }

  Widget buildDetailItem(String label, TextEditingController controller) {
    return Column(
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
    );
  }
}

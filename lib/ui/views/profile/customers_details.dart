import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomersDetails extends StatefulWidget {
  const CustomersDetails({Key? key}) : super(key: key);

  @override
  _CustomersDetailsState createState() => _CustomersDetailsState();
}

class _CustomersDetailsState extends State<CustomersDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool showCustomerDetails = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Customers Details',
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
                        title: Text('Add Customer'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildTextField('Name', nameController),
                              buildTextField('Phone Number', phoneNumberController),
                              buildTextField('Address', addressController),
                              buildTextField('Email', emailController),
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
                              addCustomer();
                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add Customer'),
              ),
              SizedBox(height: 20),
              Text(
                'Customer List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('customers_info').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final customers = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index].data() as Map<String, dynamic>;
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            customer['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(customer['phone_number']),
                          onTap: () {
                            setState(() {
                              showCustomerDetails = true;
                              nameController.text = customer['name'];
                              phoneNumberController.text = customer['phone_number'];
                              addressController.text = customer['address'];
                              emailController.text = customer['email'];
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                    return AlertDialog(
                                      title: Text('Customer Details'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            buildDetailRow('Name', customer['name']),
                                            buildDetailRow('Phone Number', customer['phone_number']),
                                            buildDetailRow('Address', customer['address']),
                                            buildDetailRow('Email', customer['email']),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Close'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Edit Customer'),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        buildTextField('Name', nameController),
                                                        buildTextField('Phone Number', phoneNumberController),
                                                        buildTextField('Address', addressController),
                                                        buildTextField('Email', emailController),
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
                                                        updateCustomer(customers[index].reference);
                                                        setState(() {
                                                          showCustomerDetails = true;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Update'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        deleteCustomer(customers[index].reference);
                                                        setState(() {
                                                          showCustomerDetails = false;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Edit'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
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

  void addCustomer() {
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'phone_number': phoneNumberController.text,
      'address': addressController.text,
      'email': emailController.text,
    };

    FirebaseFirestore.instance.collection('customers_info').add(data);
    clearTextFields();
  }

  void updateCustomer(DocumentReference reference) {
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'phone_number': phoneNumberController.text,
      'address': addressController.text,
      'email': emailController.text,
    };

    reference.update(data);
    clearTextFields();
  }

  void deleteCustomer(DocumentReference reference) {
    reference.delete();
    clearTextFields();
  }

  void clearTextFields() {
    nameController.clear();
    phoneNumberController.clear();
    addressController.clear();
    emailController.clear();
  }
}

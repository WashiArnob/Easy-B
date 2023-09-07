
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Map<String, dynamic>>> productsList;
  String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

  @override
  void initState() {
    super.initState();
    productsList = fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();
      // Convert the Firestore documents to a list of maps
      List<Map<String, dynamic>> products = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Add serial numbers to the products
      for (int i = 0; i < products.length; i++) {
        products[i]['serial-number'] = i + 1;
      }

      // Sort the products alphabetically by 'product-name'
      products.sort((a, b) => a['product-name'].compareTo(b['product-name']));

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Products Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        elevation: 4,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: productsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading products'),
            );
          } else {
            List<Map<String, dynamic>> products = snapshot.data ?? [];
            if (products.isEmpty) {
              return Center(
                child: Text('No products found'),
              );
            }
            return ListView.separated(
              itemCount: products.length,
              separatorBuilder: (context, index) => Divider(
                height: 0,
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                Map<String, dynamic> product = products[index];
                return ListTile(
                  leading: Text('${product['serial-number']}'),
                  title: Text(product['product-name']),
                  subtitle: Text('${product['product-price']} Tk'),
                  trailing: CircleAvatar(
                    backgroundImage: NetworkImage(product['product-img']),
                  ),
                  onTap: () {
                    // Get.toNamed(
                    //   allProductDetails,
                    //   arguments: AllProductDetails(
                    //     productName: indexdata['product-name'],
                    //     productPrice: indexdata['product-price'],
                    //     productDetails: indexdata['product-details'],
                    //     productImage: indexdata['product-img'],
                    //   ),
                    // );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

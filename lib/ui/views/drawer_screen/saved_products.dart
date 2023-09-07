import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedProducts extends StatefulWidget {
  const SavedProducts({Key? key}) : super(key: key);

  @override
  _SavedProductsState createState() => _SavedProductsState();
}

class _SavedProductsState extends State<SavedProducts> {
  late Stream<QuerySnapshot> savedProductsStream;

  @override
  void initState() {
    super.initState();
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    savedProductsStream = FirebaseFirestore.instance
        .collection('saved-products')
        .doc(currentUserEmail)
        .collection('products')
        .snapshots();
  }

  void deleteProduct(String productId) async {
    try {
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
      await FirebaseFirestore.instance
          .collection('saved-products')
          .doc(currentUserEmail)
          .collection('products')
          .doc(productId)
          .delete();
      print('Product deleted successfully.');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void showProductDetails(Map<String, dynamic> productData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(productData['product-name']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Details:'),
              Text(productData['product-details']),
              SizedBox(height: 10),
              Text('Price: ${productData['product-price']}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: Text(
          'Saved Products',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: savedProductsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> savedProducts = snapshot.data!.docs;
            if (savedProducts.isEmpty) {
              return Center(
                child: Text(
                  'No saved products yet.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: savedProducts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> productData =
                savedProducts[index].data() as Map<String, dynamic>;
                String productId = savedProducts[index].id;
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () {
                      showProductDetails(productData);
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(productData['product-image']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    title: Text(
                      productData['product-name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      productData['product-details'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Product'),
                              content: Text('Are you sure you want to delete this product?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    deleteProduct(productId);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading saved products.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class SavedProducts extends StatefulWidget {
//   const SavedProducts({Key? key}) : super(key: key);
//
//   @override
//   _SavedProductsState createState() => _SavedProductsState();
// }
//
// class _SavedProductsState extends State<SavedProducts> {
//   late Stream<QuerySnapshot> savedProductsStream;
//
//   @override
//   void initState() {
//     super.initState();
//     String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
//     savedProductsStream = FirebaseFirestore.instance
//         .collection('saved-products')
//         .doc(currentUserEmail)
//         .collection('products')
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 5,
//         title: Text(
//           'Saved Products',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: savedProductsStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<DocumentSnapshot> savedProducts = snapshot.data!.docs;
//             if (savedProducts.isEmpty) {
//               return Center(
//                 child: Text(
//                   'No saved products yet.',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               );
//             }
//             return ListView.builder(
//               itemCount: savedProducts.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> productData =
//                 savedProducts[index].data() as Map<String, dynamic>;
//                 return Card(
//                   elevation: 2,
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     leading: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(productData['product-image']),
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     title: Text(
//                       productData['product-name'],
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(
//                       productData['product-details'],
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     trailing: Text(
//                       'Price ${productData['product-price']}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error loading saved products.',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
//


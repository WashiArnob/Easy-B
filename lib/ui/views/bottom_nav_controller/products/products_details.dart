import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllProductDetails extends StatefulWidget {
  final String productName;
  final String productImage;
  final String productDetails;
  final int productPrice;

  AllProductDetails({
    Key? key,
    required this.productName,
    required this.productImage,
    required this.productDetails,
    required this.productPrice,
  }) : super(key: key);

  @override
  _AllProductDetailsState createState() => _AllProductDetailsState();
}

class _AllProductDetailsState extends State<AllProductDetails> {
  bool isSaved = false;

  Future<void> toggleSavedStatus() async {
    try {
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
      CollectionReference productsCollection = FirebaseFirestore.instance
          .collection('saved-products')
          .doc(currentUserEmail)
          .collection('products');

      if (isSaved) {
        // If already saved, delete the product from the database
        QuerySnapshot snapshot = await productsCollection
            .where('product-name', isEqualTo: widget.productName)
            .get();
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      } else {
        // If not saved, add the product to the database
        await productsCollection.add({
          'product-name': widget.productName,
          'product-details': widget.productDetails,
          'product-price': widget.productPrice,
          'product-image': widget.productImage,
        });
      }

      setState(() {
        isSaved = !isSaved;
      });
    } catch (e) {
      print('Error toggling product saved status: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkProductSaved();
  }

  Future<void> checkProductSaved() async {
    try {
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('saved-products')
          .doc(currentUserEmail)
          .collection('products')
          .where('product-name', isEqualTo: widget.productName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          isSaved = true;
        });
      }
    } catch (e) {
      print('Error checking if product is saved: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: Text(
          'View Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.productImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.productName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          toggleSavedStatus();
                        },
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          color: isSaved ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.black54,
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.productDetails,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.black54,
                    thickness: 1,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${widget.productPrice}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.black54,
                    thickness: 1,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('add-to-cart')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection('my-product')
                          .add({
                        'product-name': widget.productName,
                        'product-details': widget.productDetails,
                        'product-price': widget.productPrice,
                        'time': DateTime.now()
                      });
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AllProductDetails extends StatefulWidget {
//   final String productName;
//   final String productImage;
//   final String productDetails;
//   final String productPrice;
//
//   AllProductDetails({
//     Key? key,
//     required this.productName,
//     required this.productImage,
//     required this.productDetails,
//     required this.productPrice,
//   }) : super(key: key);
//
//   @override
//   _AllProductDetailsState createState() => _AllProductDetailsState();
// }
//
// class _AllProductDetailsState extends State<AllProductDetails> {
//   bool isSaved = false;
//
//   Future<void> saveToWishlist() async {
//     try {
//       String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
//       await FirebaseFirestore.instance
//           .collection('saved-products')
//           .doc(currentUserEmail)
//           .collection('products')
//           .add({
//         'product-name': widget.productName,
//         'product-details': widget.productDetails,
//         'product-price': widget.productPrice,
//         'product-image': widget.productImage,
//       });
//       print('Product saved to wishlist.');
//       setState(() {
//         isSaved = true;
//       });
//     } catch (e) {
//       print('Error saving product to wishlist: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     checkProductSaved();
//   }
//
//   Future<void> checkProductSaved() async {
//     try {
//       String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('saved-products')
//           .doc(currentUserEmail)
//           .collection('products')
//           .where('product-name', isEqualTo: widget.productName)
//           .get();
//       if (snapshot.docs.isNotEmpty) {
//         setState(() {
//           isSaved = true;
//         });
//       }
//     } catch (e) {
//       print('Error checking if product is saved: $e');
//     }
//   }
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
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.4,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(widget.productImage),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         widget.productName,
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             isSaved = !isSaved;
//                           });
//                           if (isSaved) {
//                             saveToWishlist();
//                           }
//                         },
//                         icon: Icon(
//                           isSaved ? Icons.favorite : Icons.favorite_border,
//                           color: isSaved ? Colors.red : Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Divider(
//                     color: Colors.black54,
//                     thickness: 1,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     widget.productDetails,
//                     style: TextStyle(fontSize: 15, color: Colors.black),
//                   ),
//                   SizedBox(height: 20),
//                   Divider(
//                     color: Colors.black54,
//                     thickness: 1,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     widget.productPrice,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Divider(
//                     color: Colors.black54,
//                     thickness: 1,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       FirebaseFirestore.instance
//                           .collection('add-to-cart')
//                           .doc(FirebaseAuth.instance.currentUser!.email)
//                           .collection('my-product')
//                           .add({
//                         'product-name': widget.productName,
//                         'product-details': widget.productDetails,
//                         'product-price': widget.productPrice
//                       });
//                     },
//                     child: Text('Add to Cart'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


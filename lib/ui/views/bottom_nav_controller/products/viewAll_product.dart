//Main code
import 'package:app_by_washi/ui/custom_widgets/custom_textfield.dart';
import 'package:app_by_washi/ui/route/routes.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/products/products_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllProduct extends StatefulWidget {
  const ViewAllProduct({Key? key}) : super(key: key);

  @override
  _ViewAllProductState createState() => _ViewAllProductState();
}

class _ViewAllProductState extends State<ViewAllProduct> {
  final editnameController = TextEditingController();
  final editdetailsController = TextEditingController();
  final editpriceController = TextEditingController();
  List<DocumentSnapshot> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

    Future<void> fetchProducts() async {
    try {
       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
      setState(() {
        products = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  

  void deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      setState(() {
        products.removeWhere((product) => product.id == productId);
      });
      print('Product deleted successfully.');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Products',
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
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var indexdata = products[index];
            return Container(
              height: 320, // Set a fixed height for the container
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      allProductDetails,
                      arguments: AllProductDetails(
                        productName: indexdata['product-name'],
                        productPrice: indexdata['product-price'],
                        productDetails: indexdata['product-details'],
                        productImage: indexdata['product-img'],
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.lightBlueAccent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              child: Image.network(
                                indexdata['product-img'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          indexdata['product-name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          indexdata['product-details'],
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text('${indexdata['product-price']} Tk',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        height: 400,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topLeft,
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        Get.back(),
                                                    icon: Icon(
                                                        Icons
                                                            .arrow_back_ios,
                                                        color:
                                                            Colors.black),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                customTextField(
                                                  editnameController
                                                    ..text = indexdata[
                                                        'product-name'],
                                                  'product name',
                                                  'product name',
                                                  TextInputType.text,
                                                  (String? value) {
                                                    if (value!.isEmpty) {
                                                      return "This field can't be empty";
                                                    }
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                customTextField(
                                                  editdetailsController
                                                    ..text = indexdata[
                                                        'product-details'],
                                                  'product details',
                                                  'product details',
                                                  TextInputType.text,
                                                  (String? value) {
                                                    if (value!.isEmpty) {
                                                      return "This field can't be empty";
                                                    }
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                customTextField(
                                                  editpriceController..text = indexdata[
                                                        'product-price'].toString(),
                                                  'product price',
                                                  'product price',
                                                  TextInputType.number,
                                                  (String? value) {
                                                    if (value!.isEmpty) {
                                                      return "This field can't be empty";
                                                    }
                                                  },
                                                ),
                                                SizedBox(height: 15),
                                                TextButton(
                                                  onPressed: () async {
                                                    FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'products')
                                                        .doc(indexdata.id)
                                                        .update({
                                                      'product-name':
                                                          editnameController
                                                              .text
                                                              .toString(),
                                                      'product-details':
                                                          editdetailsController
                                                              .text
                                                              .toString(),
                                                      'product-price':int.tryParse(editpriceController
                                                              .text)
                                                          
                                                              ,
                                                    });
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .lightBlue),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors
                                                                    .white),
                                                  ),
                                                  child: Text('Update'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue),
                              ),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete Product'),
                                      content: Text(
                                          'Are you sure you want to delete this product?'),
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
                                            deleteProduct(indexdata.id);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.7,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 10,
          ),
        ),
      ),
    );
  }
}

































//
// import 'package:app_by_washi/ui/custom_widgets/custom_textfield.dart';
// import 'package:app_by_washi/ui/route/routes.dart';
// import 'package:app_by_washi/ui/views/bottom_nav_controller/products/products_details.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ViewAllProduct extends StatefulWidget {
//   const ViewAllProduct({Key? key}) : super(key: key);
//
//   @override
//   _ViewAllProductState createState() => _ViewAllProductState();
// }
//
// class _ViewAllProductState extends State<ViewAllProduct> {
//   final editnameController = TextEditingController();
//   final editdetailsController = TextEditingController();
//   final editpriceController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Products',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//         ),
//         elevation: 4,
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance.collection('products').get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error'));
//           }
//           return SingleChildScrollView(
//             child: GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var indexdata = snapshot.data!.docs[index];
//                 return Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Container(
//                     color: Colors.white24,
//                     padding: EdgeInsets.all(10),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                                border: Border.all(color: Colors.lightBlueAccent, width: 2),
//                               // borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: ClipRRect(
//                               //borderRadius: BorderRadius.circular(20),
//                               child: Image.network(
//                                 indexdata['product-img'],
//                                 height: 100,
//                                 width: 200,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 7),
//                         Center(
//                           child: Text(
//                             indexdata['product-name'],
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Center(
//                           child: Text(
//                             indexdata['product-details'],
//                             style: TextStyle(fontSize: 12, color: Colors.black45),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Center(
//                           child: Text(
//                             indexdata['product-price'],
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Get.toNamed(
//                                 allProductDetails,
//                                 arguments: AllProductDetails(
//                                   productName: indexdata['product-name'],
//                                   productPrice: indexdata['product-price'],
//                                   productDetails: indexdata['product-details'],
//                                   productImage: indexdata['product-img'],
//
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.lightBlue,
//                             ),
//                             child: Text('View Details'),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return Dialog(
//                                     child: Container(
//                                       height: 400,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             children: [
//                                               Align(
//                                                 alignment: Alignment.topLeft,
//                                                 child: IconButton(
//                                                   onPressed: () => Get.back(),
//                                                   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//                                                 ),
//                                               ),
//                                               SizedBox(height: 10),
//                                               customTextField(
//                                                 editnameController..text = indexdata['product-name'],
//                                                 'product name',
//                                                 'product name',
//                                                 TextInputType.text,
//                                                     (String? value) {
//                                                   if (value!.isEmpty) {
//                                                     return "This field can't be empty";
//                                                   }
//                                                 },
//                                               ),
//                                               SizedBox(height: 10),
//                                               customTextField(
//                                                 editdetailsController..text = indexdata['product-details'],
//                                                 'product details',
//                                                 'product details',
//                                                 TextInputType.text,
//                                                     (String? value) {
//                                                   if (value!.isEmpty) {
//                                                     return "This field can't be empty";
//                                                   }
//                                                 },
//                                               ),
//                                               SizedBox(height: 10),
//                                               customTextField(
//                                                 editpriceController..text = indexdata['product-price'],
//                                                 'product price',
//                                                 'product price',
//                                                 TextInputType.text,
//                                                     (String? value) {
//                                                   if (value!.isEmpty) {
//                                                     return "This field can't be empty";
//                                                   }
//                                                 },
//                                               ),
//                                               SizedBox(height: 15),
//                                               ElevatedButton(
//                                                 onPressed: () async {
//                                                   FirebaseFirestore.instance.collection('products').doc(indexdata.id).update({
//                                                     'product-name': editnameController.text.toString(),
//                                                     'product-details': editdetailsController.text.toString(),
//                                                     'product-price': editpriceController.text.toString(),
//                                                   });
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Text('Update'),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.lightBlue,
//                             ),
//                             child: Text('Update'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: 0.6,
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 10,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }









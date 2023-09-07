import 'dart:io';
import 'package:app_by_washi/ui/custom_widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({Key? key}) : super(key: key);

  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  final productNameController = TextEditingController();
  final productDetailsController = TextEditingController();
  final productPriceController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String selectedQuantity = 'kg';
  int selectedNumber = 1;

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Upload Products',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Upload Your Products',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  customTextField(
                    productNameController,
                    'Enter Product Name',
                    'Enter Product Name',
                    TextInputType.text,
                        (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    productDetailsController,
                    'Enter Product Details',
                    'Enter Product Details',
                    TextInputType.text,
                        (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    productPriceController,
                    'Enter Product Price',
                    'Enter Product Price',
                    TextInputType.number,
                        (String? value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedQuantity,
                    onChanged: (newValue) {
                      setState(() {
                        selectedQuantity = newValue!;
                      });
                    },
                    items: ['kg', 'liter', 'piece'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Quantity Type',
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: selectedNumber,
                    onChanged: (newValue) {
                      setState(() {
                        selectedNumber = newValue!;
                      });
                    },
                    items: List<int>.generate(100, (index) => index + 1).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Quantity in Number',
                    ),
                  ),
                  SizedBox(height: 15),

                  image == null ? IconButton(
                    onPressed: () async {
                      image = await picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    icon: Icon(Icons.add_a_photo),
                  )
                      : Image.file(File(image!.path),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        File imgFile = File(image!.path);
                        // upload storage
                        UploadTask _uploadtask = FirebaseStorage.instance.ref('images').child(image!.name).putFile(imgFile);
                        TaskSnapshot snapshot = await _uploadtask;
                        // get the image download link/url
                        var imageUrl = await snapshot.ref.getDownloadURL();
                        // store data
                        if (productNameController.text.isEmpty ||
                            productDetailsController.text.isEmpty ||
                            image == null) {
                          String errorMessage = '';
                          if (productNameController.text.isEmpty) {
                            errorMessage += 'Product name can\'t be empty\n';
                          }

                          if (productDetailsController.text.isEmpty) {
                            errorMessage += 'Product details can\'t be empty\n';
                          }
                          if (productPriceController.text.isEmpty) {
                            errorMessage += 'Product Price can\'t be empty\n';
                          }
                          if (image == null) {
                            errorMessage += 'Product img can\'t be empty\n';
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
                          await FirebaseFirestore.instance.collection('products').add({
                            'product-name': productNameController.text.toString(),
                            'product-details': productDetailsController.text.toString(),
                            'product-price': int.tryParse(productPriceController.text),
                            'product-img': imageUrl,
                            'quantity': selectedQuantity,
                            'number': selectedNumber,
                            'time':DateTime.now()
                          });

                          // Clear the form fields
                          productNameController.clear();
                          productDetailsController.clear();
                          productPriceController.clear();
                          selectedQuantity = 'kg';
                          selectedNumber = 1;
                          image = null;

                          setState(() {});
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text('Upload'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}






//Main code upload product
// import 'dart:io';
// import 'package:app_by_washi/ui/custom_widgets/custom_textfield.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class UploadProduct extends StatefulWidget {
//   const UploadProduct({Key? key}) : super(key: key);
//
//   @override
//   _UploadProductState createState() => _UploadProductState();
// }
//
// class _UploadProductState extends State<UploadProduct> {
//   final productNameController=TextEditingController();
//   final productDetailsController=TextEditingController();
//   final productPriceController=TextEditingController();
//   final ImagePicker picker = ImagePicker();
//   XFile? image;
//   String selectedQuantity = 'kg';
//
//   final formkey= GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Upload Products',style: TextStyle(color: Colors.black),),
//         centerTitle: true,
//         leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formkey,
//               child: Column(
//                 children: [
//                   Center(child: Text("Upload Your Products",style: TextStyle(fontSize: 20),)),
//                   SizedBox(height: 20,),
//                   customTextField(productNameController, 'Enter Product Name',  'Enter Product Name', TextInputType.text, (String? value){
//                     if(value!.isEmpty){
//                       return "This field can't be empty";
//                     }
//                   }),
//                   SizedBox(height: 10,),
//                   customTextField(productDetailsController, 'Enter Product Details',  'Enter Product Details', TextInputType.text, (String? value){
//                     if(value!.isEmpty){
//                       return "This field can't be empty";
//                     }
//                   }),
//                   SizedBox(height: 10,),
//
//
//                   customTextField(productPriceController, 'Enter Product Price',  'Enter Product Price', TextInputType.number, (String? value){
//                     if(value!.isEmpty){
//                       return "This field can't be empty";
//                     }
//                   }),
//                   SizedBox(height: 10,),
//
//
//                   SizedBox(height: 10,),
//                   image==null? IconButton(onPressed: ()async{
//                      image = await picker.pickImage(source: ImageSource.camera);
//                      setState(() {
//
//                      });
//                   }, icon: Icon(Icons.add_a_photo))
//                       : Image.file(File(image!.path),height: 150,fit: BoxFit.cover,),
//                   SizedBox(height: 20,),
//
//
//                   ElevatedButton(
//                       onPressed: () async {
//                         try {
//                           File imgFile = File(image!.path);
// // upload storage
//                           UploadTask _uploadtask = FirebaseStorage.instance
//                               .ref('images')
//                               .child(image!.name)
//                               .putFile(imgFile);
//                           TaskSnapshot snapshot = await _uploadtask;
// // get the image download link/url
//                           var imageUrl = await snapshot.ref.getDownloadURL();
// // store data
//                           if (productNameController.text.isEmpty ||
//                               productDetailsController.text.isEmpty ||
//                               image == null) {
//                             String errorMessage = '';
//                             if (productNameController.text.isEmpty) {
//                               errorMessage += 'Product name can\'t be empty\n';
//                             }
//                             if (productDetailsController.text.isEmpty) {
//                               errorMessage += 'Product details can\'t be empty\n';
//                             }
//                             if (image == null) {
//                               errorMessage += 'Product img can\'t be empty\n';
//                             }
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     title: Text('Error'),
//                                     content: Text(errorMessage),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                         child: Text('OK'),
//                                       ),
//                                     ],
//                                   );
//                                 });
//                           } else {
//                             FirebaseFirestore.instance.collection('products').add({
//
//                               'product-name': productNameController.text.toString(),
//                               'product-details': productDetailsController.text.toString(),
//                               'product-price': productPriceController.text.toString(),
//                               'product-img': imageUrl
//                             });
//                           }
//                         } catch (e) {
//                           print(e.toString());
//                         }
//                       }, child: Text('Upload'))
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// ElevatedButton(onPressed: ()async{
//   try{
//    File imgFile= File(image!.path);
//    //upload storage
//    UploadTask _uploadtask=  FirebaseStorage.instance.ref('images').child(image!.name).putFile(imgFile);
//    TaskSnapshot snapshot= await _uploadtask;
//    //get the image download link/url
//   var imageUrl = await snapshot.ref.getDownloadURL();
//   //store data
//   FirebaseFirestore.instance.collection('products').add({
//     'product-name': productNameController.text.toString(),
//     'product-details': productDetailsController.text.toString(),
//     'product-price':productPriceController.text.toString(),
//     'product-img': imageUrl
//
//   });
//   // print('Add Successfully');
//
//
//
//   } catch(e){
//     print(e.toString());
//   }
// }, child: Text('Upload'))


// DropdownButtonFormField<String>(
//   decoration: InputDecoration(
//     border: InputBorder.none,
//   ),
//   value: selectedQuantity,
//   icon: const Icon(Icons.keyboard_arrow_down),
//   validator: (value) => value == 'kg' ? 'Field required' : null,
//   items: [
//     DropdownMenuItem(
//       value: 'kg',
//       child: Text('Kg'),
//     ),
//     DropdownMenuItem(
//       value: 'liter',
//       child: Text('Liter'),
//     ),
//     DropdownMenuItem(
//       value: 'pieces',
//       child: Text('Pieces'),
//     ),
//   ],
//   onChanged: (String? newValue) {
//     setState(() {
//       selectedQuantity = newValue!;
//     });
//   },
// ),

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class ShopQRCodeScreen extends StatefulWidget {
  const ShopQRCodeScreen({Key? key}) : super(key: key);

  @override
  _ShopQRCodeScreenState createState() => _ShopQRCodeScreenState();
}

class _ShopQRCodeScreenState extends State<ShopQRCodeScreen> {
  var totalMonthly = ''.obs;

  Future shopName() async {
    //current time
    var now = new DateTime.now();
    // Sum the count of each shard in the subcollection
    final shards = await FirebaseFirestore.instance
        .collection('business_user_profile')
        .get();

    var totalCount = ''.obs;

    shards.docs.forEach(
          (doc) {
        totalCount.value += doc.data()['shop-name'] ;
        if(totalMonthly.value==''){
          totalMonthly.value=totalCount.value;
        }

      },
    );

    return totalCount;
  }
  @override
  void initState() {
   shopName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(totalMonthly.value);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'QR Code Scan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        elevation: 4,
      ),
      body: Center(
        child: Container(
          height: 250,
          child: SfBarcodeGenerator(
            value: '${totalMonthly.value}',
            showValue: true,
            symbology: QRCode(),
          ),
        ),
      ),
    );
  }
}

import 'package:app_by_washi/ui/views/drawer_screen/new_sell_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SellDetails extends StatefulWidget {
  @override
  _SellDetailsState createState() => _SellDetailsState();
}

class _SellDetailsState extends State<SellDetails> {
  late Future<int> totalProducts;
  late Stream<QuerySnapshot<Map<String, dynamic>>> savedProductsStream;

  @override
  void initState() {
    super.initState();
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    savedProductsStream = FirebaseFirestore.instance
        .collection('saved-products')
        .doc(currentUserEmail)
        .collection('products')
        .snapshots();

    totalProducts = fetchTotalProducts();
  }

  Future<int> fetchTotalProducts() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      return snapshot.size;
    } catch (e) {
      print('Error fetching products: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: Text(
          'Sell Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(DailySellDetails());
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
            child: ListTile(
              title: Text('Daily Sell'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Divider(),
          ElevatedButton(
            onPressed: () {
               Get.to(WeeklySellDetails());
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            child: ListTile(
              title: Text('Weekly Sell'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Divider(),
          ElevatedButton(
            onPressed: () {
               Get.to(MonthlySellDetails());
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
            ),
            child: ListTile(
              title: Text('Monthly Sell'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          // Divider(),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     primary: Colors.red,
          //   ),
          //   child: ListTile(
          //     title: Text('Yearly Sell'),
          //     trailing: Icon(Icons.keyboard_arrow_right),
          //   ),
          // ),
          SizedBox(height: 20),
          FutureBuilder<int>(
            future: totalProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CardWidget(title: 'Total Products Items', value: '00');
              } else if (snapshot.hasError) {
                return CardWidget(
                    title: 'Total Products Items', value: 'Error');
              } else {
                return CardWidget(
                  title: 'Total Products Items',
                  value: snapshot.data!.toString(),
                );
              }
            },
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: savedProductsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CardWidget(title: 'Saved Products', value: '00');
              } else if (snapshot.hasError) {
                return CardWidget(title: 'Saved Products', value: 'Error');
              } else {
                int savedProductsCount = snapshot.data!.size;
                return CardWidget(
                  title: 'Saved Products',
                  value: savedProductsCount.toString(),
                );
              }
            },
          ),
          CardWidget(title: 'Best Selling Products', value: '00'),
          CardWidget(title: 'Average Selling Products', value: '00'),
          CardWidget(title: 'Least Selling Products', value: '00'),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String value;

  const CardWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

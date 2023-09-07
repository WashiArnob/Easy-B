import 'package:app_by_washi/ui/custom_widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewSellButtonScreen extends StatefulWidget {
  const NewSellButtonScreen({Key? key}) : super(key: key);

  @override
  State<NewSellButtonScreen> createState() => _NewSellButtonScreenState();
}

class _NewSellButtonScreenState extends State<NewSellButtonScreen> {
  var now = new DateTime.now();
  List products = [];
  //  fetchProducts() async {
  //   try {
  //
  //     var snapshot = await FirebaseFirestore.instance
  //         .collection('daily-sells')
  //         .where('time',
  //             isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
  //         .snapshots();
  //     setState(() {
  //       products = snapshot.docs;
  //     });
  //   } catch (e) {
  //     print('Error fetching products: $e');
  //   }
  // }

  @override
  void initState() {
    //fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Sell'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('daily-sells')
                    .where('time',
                        isGreaterThanOrEqualTo:
                            DateTime(now.year, now.month, now.day))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Fluttertoast.showToast(msg: "Error");
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var indexdata = snapshot.data!.docs[index];

                          return Card(
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  color: Colors.lightBlueAccent,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      '\Tk ${indexdata['product-price']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      indexdata['product-name'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Quicksand',
                                      ),
                                    ),
                                    Text(
                                      '${DateFormat().format(indexdata['time'].toDate())}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FloatingActionButton(
              backgroundColor: Colors.lightBlueAccent,
              onPressed: () {
                Get.to(DailySellUploadProduct());
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailySellUploadProduct extends StatefulWidget {
  const DailySellUploadProduct({Key? key}) : super(key: key);

  @override
  _DailySellUploadProductState createState() => _DailySellUploadProductState();
}

class _DailySellUploadProductState extends State<DailySellUploadProduct> {
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Today's Sell",
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
                      'Selling Products',
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        if (formkey.currentState!.validate()) {
                          FirebaseFirestore.instance
                              .collection('daily-sells')
                              .add({
                            'product-name':
                                productNameController.text.toString(),
                            'product-price':
                                int.tryParse(productPriceController.text),
                            'time': DateTime.now()
                          });
                          // Clear the form fields
                          productNameController.clear();
                          productPriceController.clear();
                          Get.back();
                          setState(() {});
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please fill up all fields');
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text('Enter'),
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

class DailySellDetails extends StatefulWidget {
  const DailySellDetails({Key? key}) : super(key: key);

  @override
  State<DailySellDetails> createState() => _DailySellDetailsState();
}

class _DailySellDetailsState extends State<DailySellDetails> {
  List<DocumentSnapshot> products = [];
  Future<void> fetchProducts() async {
    try {
      var now = new DateTime.now();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('daily-sells')
          .where('time',
              isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
          .get();
      setState(() {
        products = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  var subtotalDaily = 0.obs;
  var totalDaily = 0.obs;

  Future<RxInt> getCountDaily() async {
    //current time
    var now = new DateTime.now();
    // Sum the count of each shard in the subcollection
    final shards = await FirebaseFirestore.instance
        .collection('daily-sells')
        .where('time',
            isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
        .get();

    var totalCount = 0.obs;

    shards.docs.forEach(
      (doc) {
        totalCount.value += doc.data()['product-price'] as int;
        totalDaily.value = subtotalDaily.value + totalCount.value;
      },
    );

    return totalDaily;
  }

  @override
  void initState() {
    fetchProducts();
    getCountDaily();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Sell Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var indexdata = products[index];

                    return Card(
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            color: Colors.lightBlueAccent,
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '\Tk ${indexdata['product-price']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                indexdata['product-name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              Text(
                                '${DateFormat().format(indexdata['time'].toDate())}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
            Container(
                height: 50,
                width: double.infinity,
                color: Colors.blue,
                child: Center(
                    child: Text(
                  'Total sell - ${totalDaily.value} Tk',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )))
          ],
        ),
      ),
    );
  }
}

class WeeklySellDetails extends StatefulWidget {
  const WeeklySellDetails({Key? key}) : super(key: key);

  @override
  State<WeeklySellDetails> createState() => _WeeklySellDetailsState();
}

class _WeeklySellDetailsState extends State<WeeklySellDetails> {
  List<DocumentSnapshot> products = [];
  Future<void> fetchProducts() async {
    try {
      DateTime birHaftaOnce = DateTime.now().subtract(Duration(days: 7));
      Timestamp birHaftaOnceTimestamp = Timestamp.fromDate(birHaftaOnce);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('daily-sells')
          .where('time', isGreaterThanOrEqualTo: birHaftaOnceTimestamp)
          .get();
      setState(() {
        products = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  var subtotalWeekly = 0.obs;
  var totalWeekly = 0.obs;

  Future<RxInt> getCountWeekly() async {
    //current time
    var now = new DateTime.now();
    // Sum the count of each shard in the subcollection
    final shards = await FirebaseFirestore.instance
        .collection('daily-sells')
        .where('time',
            isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
        .get();

    var totalCount = 0.obs;

    shards.docs.forEach(
      (doc) {
        totalCount.value += doc.data()['product-price'] as int;
        totalWeekly.value = subtotalWeekly.value + totalCount.value;
      },
    );

    return totalWeekly;
  }

  @override
  void initState() {
    fetchProducts();
    getCountWeekly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Sell Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var indexdata = products[index];

                    return Card(
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            color: Colors.lightBlueAccent,
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '\Tk ${indexdata['product-price']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                indexdata['product-name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              Text(
                                '${DateFormat().format(indexdata['time'].toDate())}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
            Container(
                height: 50,
                width: double.infinity,
                color: Colors.blue,
                child: Center(
                    child: Text(
                  'Total sell - ${totalWeekly.value} Tk',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )))
          ],
        ),
      ),
    );
  }
}

class MonthlySellDetails extends StatefulWidget {
  const MonthlySellDetails({Key? key}) : super(key: key);

  @override
  State<MonthlySellDetails> createState() => _MonthlySellDetailsState();
}

class _MonthlySellDetailsState extends State<MonthlySellDetails> {
  List<DocumentSnapshot> products = [];
  Future<void> fetchProducts() async {
    try {
      var now = new DateTime.now();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('daily-sells')
          .where('time',
              isGreaterThanOrEqualTo: DateTime(now.year, now.month, 1))
          .get();
      setState(() {
        products = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  var subtotalMonthly = 0.obs;
  var totalMonthly = 0.obs;

  Future<RxInt> getCountMonthly() async {
    //current time
    var now = new DateTime.now();
    // Sum the count of each shard in the subcollection
    final shards = await FirebaseFirestore.instance
        .collection('daily-sells')
        .where('time', isGreaterThanOrEqualTo: DateTime(now.year, now.month, 1))
        .get();

    var totalCount = 0.obs;

    shards.docs.forEach(
      (doc) {
        totalCount.value += doc.data()['product-price'] as int;
        totalMonthly.value = subtotalMonthly.value + totalCount.value;
      },
    );

    return totalMonthly;
  }

  @override
  void initState() {
    fetchProducts();
    getCountMonthly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Sell Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var indexdata = products[index];

                    return Card(
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            color: Colors.lightBlueAccent,
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '\Tk ${indexdata['product-price']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                indexdata['product-name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              Text(
                                '${DateFormat().format(indexdata['time'].toDate())}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
            Container(
                height: 50,
                width: double.infinity,
                color: Colors.blue,
                child: Center(
                    child: Text(
                  'Total sell - ${totalMonthly.value} Tk',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )))
          ],
        ),
      ),
    );
  }
}

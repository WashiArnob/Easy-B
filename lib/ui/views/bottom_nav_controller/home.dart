import 'package:app_by_washi/ui/route/routes.dart';
import 'package:app_by_washi/ui/style/styles.dart';
import 'package:app_by_washi/ui/views/drawer_screen/new_sell_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    getCountDaily();
    getCountWeekly();
    recentOrders();
    super.initState();
  }

  bool isChecked = false;
  final amountController = TextEditingController();
  final forWhatController = TextEditingController();

  var subtotalDaily = 0.obs;
  var totalDaily = 0.obs;
  var subtotalWeekly = 0.obs;
  var totalWeekly = 0.obs;
  List<DocumentSnapshot> products = [];

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

  Future<RxInt> getCountWeekly() async {
    DateTime birHaftaOnce = DateTime.now().subtract(Duration(days: 7));
    Timestamp birHaftaOnceTimestamp = Timestamp.fromDate(birHaftaOnce);

    // Sum the count of each shard in the subcollection
    final shards = await FirebaseFirestore.instance
        .collection('daily-sells')
        .where('time', isGreaterThanOrEqualTo: birHaftaOnceTimestamp)
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

  Future<void> recentOrders() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('add-to-cart')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .collection('my-product')
          .orderBy('time', descending: true)
          .limit(4)
          .get();
      setState(() {
        products = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    getCountDaily();
    getCountWeekly();
    recentOrders();

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 80,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.purpleAccent,
                                size: 30,
                              ),
                              AppStyle.horizontallySpace,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Weekly Sell',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  AppStyle.smallSpacer,
                                  Obx(() => Text(
                                        '${totalWeekly.value}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )),
                                ],
                              )
                            ],
                          )),
                    ),
                    AppStyle.horizontallySpace,
                    Expanded(
                      child: Container(
                          height: 80,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance,
                                color: Colors.purpleAccent,
                              ),
                              AppStyle.horizontallySpace,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Today\'s Sell",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  AppStyle.smallSpacer,
                                  Obx(() => Text(
                                        '${totalDaily.value}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ))
                                ],
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 60,
            ),
          ),
         
          Expanded(
            flex: 8,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -70,
                    left: 60,
                    right: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: GestureDetector(
                          onTap: () => Get.toNamed(viewAllProduct),
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      1.0), // Set shadow color and opacity
                                  blurRadius: 20, // Set shadow blur radius
                                  offset: Offset(5, 5), // Set shadow offset
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/shop.jpg',
                                  fit: BoxFit.cover,
                                ),
                                Center(
                                  child: Text(
                                    'View Products',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              1.0), // Set shadow color and opacity
                                          blurRadius:
                                              4, // Set shadow blur radius
                                          offset:
                                              Offset(2, 2), // Set shadow offset
                                          // Set shadow spread radius
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Recent order\'s preview',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              var indexdata = products[index];
                              return Card(
                                elevation: 3,
                                child: ListTile(
                                  tileColor: Colors.white38,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15), // Set the border radius value
                                  ),
                                  leading: CircleAvatar(
                                    child: Icon(Icons.menu),
                                  ),
                                  title: Text(indexdata['product-name']),
                                  subtitle:
                                      Text('${indexdata['product-price']} Tk'),
                                  trailing: Text('Completed'),
                                ),
                              );
                            }),
                      ),
                      
                      FloatingActionButton(
                        backgroundColor: Colors.lightBlueAccent,
                        onPressed: () {
                           Get.to(NewSellButtonScreen());
                          // Get.to(HomeTransection());
                          // showDialog(context: context, builder: (context){
                          //   return StatefulBuilder(
                          //     builder: (context,setState){
                          //       return Dialog(
                          //         child: Container(
                          //           height: 300,
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(15.0),
                          //             child: SingleChildScrollView(
                          //               child: Column(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                          //                 children: [
                          //                   Text('New Transection',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                          //
                          //                   Row(
                          //                     mainAxisAlignment: MainAxisAlignment.center,
                          //                     children: [
                          //                       Text('Expense'),
                          //                       SizedBox(width: 15,),
                          //                       Switch(
                          //                         value: isChecked,
                          //                         onChanged: (bool value) {
                          //                           setState(() {
                          //                             isChecked = value;
                          //                           });
                          //                         },
                          //                       ),
                          //                       SizedBox(width: 15,),
                          //                       Text('Income'),
                          //                     ],
                          //                   ),
                          //                   customTextField(amountController, 'Amount?', 'Amount?', TextInputType.number, (String? value){}),
                          //                   SizedBox(height: 10,),
                          //                   customTextField(forWhatController, 'For what?', 'For what?', TextInputType.text, (String? value){}),
                          //                   SizedBox(height: 10,),
                          //                   Row(
                          //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //                     children: [
                          //                       ElevatedButton(onPressed: (){
                          //                         Navigator.pop(context);
                          //                       }, child: Text('Cancel')),
                          //                       ElevatedButton(onPressed: (){
                          //                         Navigator.pop(context);
                          //                       }, child: Text('Enter')),
                          //                     ],
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   );
                          // });
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Sell Button",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

import 'package:app_by_washi/constant/appColors.dart';
import 'package:app_by_washi/logic/authentication_logic.dart';
import 'package:app_by_washi/ui/custom_widgets/drawer_menu_button.dart';
import 'package:app_by_washi/ui/route/routes.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/bottom_nav_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardBusiness extends StatefulWidget {
  const DashboardBusiness({Key? key}) : super(key: key);

  @override
  _DashboardBusinessState createState() => _DashboardBusinessState();
}

class _DashboardBusinessState extends State<DashboardBusiness> {
  Future _exitDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are u sure to close this app?"),
            content: Row(
              children: [
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text("No"),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Text("Yes"),
                ),
              ],
            ),
          );
        });
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: WillPopScope(
          onWillPop: () {
            _exitDialog(context);
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: AppColor.blueColor,
            appBar: AppBar(
              backgroundColor: AppColor.blueColor,
              title: Text(
                'Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(businessmanProfile);
                    },
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('business_user_profile')
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasError)
                          return Text('Error = ${snapshot.error}');

                        if (snapshot.hasData) {
                          final docs = snapshot.data!.docs;
                          // box.write('imgUrl', docs[0]["shop-url"]);
                          // box.write('shopName', docs[0]["shop-name"]);
                          // var a= box.read('imgUrl');
                          // var b=box.read('shopName');
                          return Image.network(
                            docs[0]["shop-url"],
                            fit: BoxFit.contain,
                          );
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    // child: CircleAvatar(
                    //   backgroundImage: NetworkImage('assets/images/me.jpeg'),
                    //   //Dashboard Image on right
                    // ),
                  ),
                ),
              ],
            ),
            drawer: SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Drawer(
                  child: Container(
                    color: Colors.lightBlueAccent,
                    child: ListView(
                      padding: EdgeInsets.all(10),
                      children: [
                        Card(
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('business_user_profile')
                                    .snapshots(),
                                builder: (_, snapshot) {
                                  if (snapshot.hasError)
                                    return Text('Error = ${snapshot.error}');

                                  if (snapshot.hasData) {
                                    final docs = snapshot.data!.docs;
                                    // box.write('imgUrl', docs[0]["shop-url"]);
                                    // box.write('shopName', docs[0]["shop-name"]);
                                    // var a= box.read('imgUrl');
                                    // var b=box.read('shopName');
                                    return Image.network(
                                      docs[0]["shop-url"],
                                      fit: BoxFit.contain,
                                    );
                                  }

                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                              // backgroundImage: AssetImage(
                              //     'assets/logos/sample_shop_logo.jpg'),
                            ),
                            title: InkWell(
                              onTap: () {
                                Get.toNamed(editShopProfile);
                              },
                              child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('business_user_profile')
                                    .snapshots(),
                                builder: (_, snapshot) {
                                  if (snapshot.hasError)
                                    return Text('Error = ${snapshot.error}');

                                  if (snapshot.hasData) {
                                    final docs = snapshot.data!.docs;
                                    return Text(docs[0]["shop-name"],
                                        style: TextStyle(fontSize: 15));
                                  }

                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                              // child: Text(
                              //   'Abir Shop Bd',
                              //   style: TextStyle(fontSize: 15),
                              // )
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  //for close drawer/alert dialog/bottom sheet etc
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.menu,
                                  size: 30,
                                )),
                          ),
                        ),
                        SizedBox(height: 10),

                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: 'Search',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.lightBlueAccent,
                                    child: Icon(Icons.search,
                                        color: Colors.black54, size: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 45),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            menuButton(Icon(Icons.edit), Text('edit Shop'), () {
                              Get.toNamed(editShopProfile);
                            }),
                            menuButton(
                                Icon(Icons.production_quantity_limits_sharp),
                                Text('Upload Product'), () {
                              // Navigator.pop(context);
                              Get.toNamed(uploadProduct);
                            }),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            menuButton(Icon(Icons.addchart_sharp),
                                Text('Products Stock'), () {
                              Get.toNamed(productViewListTile);
                            }),
                            menuButton(Icon(Icons.money), Text('Sell Details'),
                                () {
                              Get.toNamed(sellDetails);
                            }),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            menuButton(Icon(Icons.people_alt_sharp),
                                Text('WholSale Details'), () {
                              Get.toNamed(wholeSellDetails);
                            }),
                            menuButton(
                                Icon(Icons.people), Text('Customers Details'),
                                () {
                              Get.toNamed(customersDetails);
                            }),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            menuButton(Icon(Icons.save), Text('Saved'), () {
                              Get.toNamed(savedProducts);
                            }),
                            // menuButton(Icon(Icons.notifications_rounded),
                            //     Text('Notifications'), () {
                            //   Get.toNamed(notifications);
                            // }),
                            menuButton(Icon(Icons.qr_code), Text('QR Code'),
                                    () {
                                  Get.toNamed(qrCode);
                                }),

                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            menuButton(Icon(Icons.shopping_cart_outlined),
                                Text('Orders'), () {
                                  Get.toNamed(orders);
                                }),

                            menuButton(Icon(Icons.reviews), Text('Reviews'),
                                () {
                              Get.toNamed(reviewScreen);
                            }),
                          ],
                        ),
                        //SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     menuButton(Icon(Icons.money), Text('Sell Details'),(){}),
                        //     menuButton(Icon(Icons.addchart_sharp), Text('Target Sell'),(){}),
                        //   ],
                        // ),
                        // SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     menuButton(Icon(Icons.payment_outlined),
                        //         Text('Payment System'), () {
                        //       Get.toNamed(paymentScreen);
                        //     }),
                        //     menuButton(Icon(Icons.save), Text('Saved'), () {
                        //       Get.toNamed(savedProducts);
                        //     }),
                        //   ],
                        // ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            menuButton(
                                Icon(Icons.logout_outlined), Text('Log Out'),
                                () {
                              logOut();
                            })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           

            body: BottomNavController(),
          ),
        ));
  }
}

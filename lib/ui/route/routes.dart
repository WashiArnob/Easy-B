
import 'package:app_by_washi/ui/views/authentications/login.dart';
import 'package:app_by_washi/ui/views/authentications/signup.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/home.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/products/products_details.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/products/upload_product.dart';
import 'package:app_by_washi/ui/views/bottom_nav_controller/products/viewAll_product.dart';
import 'package:app_by_washi/ui/views/drawer_screen/orders.dart';
import 'package:app_by_washi/ui/views/drawer_screen/payment_screen.dart';
import 'package:app_by_washi/ui/views/drawer_screen/product_listtile.dart';
import 'package:app_by_washi/ui/views/drawer_screen/qrCode.dart';
import 'package:app_by_washi/ui/views/drawer_screen/review_screen.dart';
import 'package:app_by_washi/ui/views/drawer_screen/saved_products.dart';
import 'package:app_by_washi/ui/views/drawer_screen/sell_details.dart';
import 'package:app_by_washi/ui/views/notifications/notifications.dart';
import 'package:app_by_washi/ui/views/profile/businessman_profile.dart';
import 'package:app_by_washi/ui/views/profile/customers_details.dart';
import 'package:app_by_washi/ui/views/profile/edit_shop_profile.dart';
import 'package:app_by_washi/ui/views/profile/wholesaller_details.dart';
import 'package:app_by_washi/ui/views/splash.dart';
import 'package:get/get.dart';

import '../views/drawer_screen/search_page.dart';

const String splash= '/splash';
const String signup= '/signup';
const String login= '/login';
const String home= '/home';
const String uploadProduct= '/upload-product';
const String viewAllProduct= '/viewAll-product';
const String allProductDetails= '/all-product-details';
const String businessmanProfile= '/businessman-profile';
const String qrCode= '/qr-code';
const String editShopProfile= '/edit-shop-profile';
const String wholeSellDetails= '/whole-sell-details';
const String customersDetails= '/customers-details';
const String notifications= '/notifications';
const String orders= '/orders';
const String reviewScreen= '/review-screen';
const String paymentScreen= '/payment';
const String savedProducts= '/saved-products';
const String productViewListTile= '/product-view-list-tile';
const String sellDetails= '/sell-details';

List<GetPage> getPages=[
  GetPage(name: splash, page:()=> SplashScreen()),
  GetPage(name: signup, page:()=> SignupBusiness()),
  GetPage(name: login, page:()=> Login()),
  GetPage(name: home, page:()=> HomeScreen()),
  GetPage(name: uploadProduct, page:()=> UploadProduct()),
  GetPage(name: viewAllProduct, page:()=> ViewAllProduct()),
  GetPage(name: businessmanProfile, page:()=> BusinessmanProfile()),
  GetPage(name: allProductDetails, page:(){
    AllProductDetails allProductDeatils= Get.arguments;
    return allProductDeatils;
  }),
  GetPage(name: qrCode, page:()=> ShopQRCodeScreen()),
  GetPage(name: editShopProfile, page:()=> EditShopProfile()),
  GetPage(name: wholeSellDetails, page:()=> WholesalerDetails()),
  GetPage(name: customersDetails, page:()=> CustomersDetails()),
  GetPage(name: notifications, page:()=> Notifications()),
  GetPage(name: orders, page:()=> OrdersScreen()),
  GetPage(name: reviewScreen, page:()=> ReviewScreen()),
  GetPage(name: paymentScreen, page:()=> PaymentScreen()),
  GetPage(name: savedProducts, page:()=> SavedProducts()),
  GetPage(name: productViewListTile, page:()=> ProductList()),
  GetPage(name: sellDetails, page:()=> SellDetails()),
];
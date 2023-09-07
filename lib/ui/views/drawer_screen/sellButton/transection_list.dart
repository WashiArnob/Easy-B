// import 'package:app_by_washi/ui/views/drawer_screen/sellButton/transection.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';


// class TransactionList extends StatelessWidget {
//   final List<Transaction> transactions;
//   TransactionList(this.transactions);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 350,
//       child: ListView.builder(
//         itemBuilder: (ctx, index) {
//           return Card(
//             child: Row(
//               children: [
//                 Container(
//                   width: 120,
//                   color: Colors.lightBlueAccent,
//                   margin: EdgeInsets.symmetric(
//                     vertical: 10,
//                     horizontal: 20,
//                   ),
//                   padding: EdgeInsets.all(10),
//                   child: Center(
//                     child: Text(
//                       '\Tk ${transactions[index].amount.toStringAsFixed(2)}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       transactions[index].title.toString(),
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Quicksand',
//                       ),
//                     ),
//                     Text(
//                       DateFormat.yMMMEd().format(transactions[index].date),
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           );
//         },
//         itemCount: transactions.length,
//       ),
//     );
//   }
// }



// import 'package:app_by_washi/ui/views/drawer_screen/sellButton/new_transection.dart';
// import 'package:app_by_washi/ui/views/drawer_screen/sellButton/transection.dart';
// import 'package:app_by_washi/ui/views/drawer_screen/sellButton/transection_list.dart';
// import 'package:flutter/material.dart';

// class HomeTransection extends StatefulWidget {
//   @override
//   State<HomeTransection> createState() => _HomeTransectionState();
// }

// class _HomeTransectionState extends State<HomeTransection> {
//   final List<Transaction> _userTransactions = [
//     Transaction(
//       id: 't1',
//       title: 'Grocery',
//       amount: 100,
//       date: DateTime.now(),
//     ),
//   ];

//   void _addNewTransaction(String txTitle, double txAmount) {
//     final newTx = Transaction(
//       title: txTitle,
//       amount: txAmount,
//       date: DateTime.now(),
//       id: DateTime.now().toString(),
//     );
//     setState(() {
//       _userTransactions.add(newTx);
//     });
//   }

//   void _startAddNewTransactons(BuildContext ctx) {
//     showModalBottomSheet(
//       context: ctx,
//       builder: (_) {
//         return GestureDetector(
//           onTap: () {},
//           child: NewTransaction(_addNewTransaction),
//           behavior: HitTestBehavior.opaque,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title: Text(
//           'Daily Expenses',
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () => _startAddNewTransactons(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               width: double.infinity,
//               color: Theme.of(context).primaryColor,
//               child: Card(
//                 child: Center(
//                   child: Text(
//                     'CHART',
//                     style: TextStyle(
//                       color: Theme.of(context).primaryColor,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             TransactionList(_userTransactions),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.add,
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//         onPressed: () => _startAddNewTransactons(context),
//       ),
//     );
//   }
// }

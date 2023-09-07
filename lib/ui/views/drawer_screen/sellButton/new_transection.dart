// import 'package:flutter/material.dart';

// class NewTransaction extends StatefulWidget {
//   final Function addTx;
//   NewTransaction(this.addTx);

//   @override
//   State<NewTransaction> createState() => _NewTransactionState();
// }

// class _NewTransactionState extends State<NewTransaction> {
//   final titleController = TextEditingController();

//   final amountController = TextEditingController();

//   void submitData() {
//     final enterTitle = titleController.text;
//     final enterAmount = double.parse(amountController.text);
//     if (enterTitle.isEmpty || enterAmount < 0) {
//       return;
//     }
//     widget.addTx(
//       enterTitle,
//       enterAmount,
//     );
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'title',
//             ),
//             controller: titleController,
//             onSubmitted: (_) => submitData(),
//           ),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'amount',
//             ),
//             controller: amountController,
//             keyboardType: TextInputType.number,
//             onSubmitted: (_) => submitData(),
//           ),
//           ElevatedButton(
//             onPressed: submitData,
//             child: Text(
//               'Add Transaction',
//               style: TextStyle(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
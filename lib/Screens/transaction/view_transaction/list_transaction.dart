// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../../db/category/category_db.dart';
// import '../../../db/transactions/transaction_db.dart';
// import '../../../models/transaction/transaction_model.dart';
// import '../../add_transaction/add_transaction.dart';
// import 'transactionlistview.dart';

// class Screen_Transaction extends StatefulWidget {
//   const Screen_Transaction({super.key});

//   @override
//   State<Screen_Transaction> createState() => _Screen_TransactionState();
// }

// class _Screen_TransactionState extends State<Screen_Transaction>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     context.read<TransactionProvider>().dropDownVale;
//     context.read<TransactionProvider>().results.clear();

//     context.read<TransactionProvider>().results =
//         context.read<TransactionProvider>().transationAll;

//     super.initState();
//     _tabController = TabController(vsync: this, length: 3);
//     _tabController.addListener(() {
//       context.read<TransactionProvider>().results =
//           context.read<TransactionProvider>().transationAll;

//       context.read<TransactionProvider>().filter(
//           context.read<TransactionProvider>().dropDownVale, _tabController);
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // results.clear();
//     context.watch<TransactionProvider>().refreshAll();
//   context.watch<CategoryProvider>().refreshUI();

//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.yellow[300],
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           title: Text(
//             'Transactions',
//             style: TextStyle(
//                 fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black),
//           ),
//           centerTitle: true,
//         ),
//         backgroundColor: Colors.yellow[300],
//         floatingActionButton: Container(
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.4),
//               spreadRadius: 2,
//               blurRadius: 7,
//               offset: Offset(0, 5),
//             )
//           ]),
//           child: FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => AddTransaction()));
//               },
//               child: Icon(
//                 IconlyLight.plus,
//                 color: Colors.black,
//               ),
//               backgroundColor: Colors.yellow,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30))),
//         ),
//         body: Consumer<TransactionProvider>(

//         builder: (context, value, child){
//           Consumer<TransactionProvider>(

//             builder: (context, value, child) => Column(children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 250.0, right: 5),
//                 child: DropdownButton(
//                     icon: const Icon(Icons.filter_list_alt),
//                     underline: Container(),
//                     elevation: 0,
//                     borderRadius: BorderRadius.circular(10),
//                     items:value. items.map((e) {
//                       return DropdownMenuItem(
//                         value: e,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: Text(e),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (newValue) {
//                       if (newValue == 'month') {
//                         value.selectDate(context);
//                       }
//                       value.filter(newValue,_tabController);
//                     }),
//               ),
//               TabBar(
//                 controller: _tabController,
//                 indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.yellow,
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.grey,
//                         blurRadius: 15,
//                         offset: Offset(5, 5),
//                       ),
//                       BoxShadow(
//                         color: Colors.white,
//                         blurRadius: 15,
//                         offset: Offset(-5, -5),
//                       ),
//                     ]),
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.black,
//                 tabs: const [
//                   Tab(
//                     text: 'Overview',
//                   ),
//                   Tab(
//                     text: 'Income',
//                   ),
//                   Tab(
//                     text: 'Expense',
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Expanded(
//                   child: TabBarView(controller: _tabController, children: [
//                 TransationListView(
//                   results:value. results,
//                 ),
//                 TransationListView(
//                   results:value. results,
//                 ),
//                 TransationListView(
//                   results:value. results,
//                 )
//               ])),
//             ],),
//           );

//   }
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../db/category/category_db.dart';
import '../../../db/transactions/transaction_db.dart';
import '../../../models/transaction/transaction_model.dart';
import '../../add_transaction/add_transaction.dart';
import 'transactionlistview.dart';

class Screen_Transaction extends StatefulWidget {
  const Screen_Transaction({Key? key}) : super(key: key);

  @override
  State<Screen_Transaction> createState() => _Screen_TransactionState();
}

class _Screen_TransactionState extends State<Screen_Transaction>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    context.read<TransactionProvider>().dropDownVale;
    context.read<TransactionProvider>().results.clear();

    context.read<TransactionProvider>().results =
        context.read<TransactionProvider>().transationAll;

    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      context.read<TransactionProvider>().results =
          context.read<TransactionProvider>().transationAll;

      context.read<TransactionProvider>().filter(
          context.read<TransactionProvider>().dropDownVale, _tabController);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<TransactionProvider>().refreshAll();
    // context.watch<CategoryProvider>().refreshUI();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[300],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Transactions',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.yellow[300],
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTransaction()),
            );
          },
          child: Icon(
            IconlyLight.plus,
            color: Colors.black,
          ),
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 250.0, right: 5),
                child: DropdownButton(
                  icon: const Icon(Icons.filter_list_alt),
                  underline: Container(),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(10),
                  items: value.items.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(e),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue == 'month') {
                      value.selectDate(context);
                    }
                    value.filter(newValue, _tabController);
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.yellow,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15,
                      offset: Offset(5, 5),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 15,
                      offset: Offset(-5, -5),
                    ),
                  ],
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Overview',
                  ),
                  Tab(
                    text: 'Income',
                  ),
                  Tab(
                    text: 'Expense',
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TransationListView(
                      results: value.results,
                    ),
                    TransationListView(
                      results: value.results,
                    ),
                    TransationListView(
                      results: value.results,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../db/transactions/transaction_db.dart';
import '../../../models/category/category_model.dart';
import '../../../models/transaction/transaction_model.dart';
import '../edit_transaction/edit_transaction.dart';
import 'view_Transaction.dart';

class TransationListView extends StatefulWidget {
  TransationListView({
    Key? key,
    required this.results,
  }) : super(key: key);

  List<TransactionModel> results = [];

  String dropdownvalue = 'All';
  var items = [
    'All',
    'income',
    'Expense',
  ];

  @override
  State<TransationListView> createState() => _DropdownListState();
}

class _DropdownListState extends State<TransationListView> {
  String parseDate(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.yellow[300],
        child: widget.results.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final _value = widget.results[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => View_Transaction(
                                    amount: _value.amount,
                                    category: _value.category.name,
                                    description: _value.purpose,
                                    date: _value.date,
                                  )));
                    },
                    child: Slidable(
                      startActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(30),
                          padding: EdgeInsets.all(8),
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          icon: IconlyLight.edit,
                          label: 'Edit',
                          onPressed: (context) {
                            final model = TransactionModel(
                                purpose: _value.purpose,
                                amount: _value.amount,
                                date: _value.date,
                                category: _value.category,
                                type: _value.type,
                                id: _value.id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditTransaction(
                                          model: model,
                                        )));
                          },
                        ),
                        SlidableAction(
                            borderRadius: BorderRadius.circular(30),
                            spacing: 8,
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            icon: IconlyLight.delete,
                            label: 'Delete',
                            onPressed: (context) {
                              _value;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete'),
                                      content: Text(
                                          'Are you sure?Do you want to delete this transaction?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              context
                                                  .read<TransactionProvider>()
                                                  .deleteTransaction(
                                                      _value.id!);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ok'))
                                      ],
                                    );
                                  });
                            })
                      ]),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _value.type == CategoryType.income
                                ? Colors.white
                                : Colors.white,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.yellow, Colors.white]),
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              leading: Text(
                                parseDate(_value.date),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    ' ${_value.category.name}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: _value.type == CategoryType.income
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${_value.amount}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: _value.type == CategoryType.income
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: widget.results.length,
              )
            : Center(
                child: Container(
                    height: 150,
                    width: 150,
                    child: Lottie.asset('images/noresult.json')),
              ));
  }
}

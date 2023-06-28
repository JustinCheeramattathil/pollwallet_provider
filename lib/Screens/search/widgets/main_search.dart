import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gowallet/db/transactions/transaction_db.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/category/category_model.dart';
import '../../../models/transaction/transaction_model.dart';
import '../../transaction/edit_transaction/edit_transaction.dart';
import '../../transaction/view_transaction/view_Transaction.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(
          Icons.clear,
          size: 30,
          shadows: <Shadow>[Shadow(color: Colors.yellow, blurRadius: 15.0)],
          color: Colors.black54,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(
        Icons.arrow_back,
        size: 30,
        shadows: <Shadow>[Shadow(color: Colors.white, blurRadius: 15.0)],
        color: Colors.black54,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // context.read<TransactionDb>().refresh();
    // context.read<CategoryDb>().refreshUI();
    return Consumer<TransactionProvider>(
      builder: (BuildContext ctx, newList, Widget? _) {
        List<TransactionModel> searchResult = [];
        searchResult = newList.transactionList
            .where((element) => element.purpose.contains(query))
            .toList();
        return searchResult.isEmpty
            ? Center(
                child: Text('hiiigusys'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20.0),
                itemBuilder: (ctx, index) {
                  final value = searchResult[index];

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final _value = newList.transactionList[index];
                      // log("123: ${newList.transactionList.length}");
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
                              ),
                            ),
                          );
                        },
                        child: Slidable(
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
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
                                    id: _value.id,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTransaction(
                                        model: model,
                                      ),
                                    ),
                                  );
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
                                          'Are you sure? Do you want to delete this transaction?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<TransactionProvider>()
                                                  .deleteTransaction(
                                                    _value.id!,
                                                  );
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _value.type == CategoryType.income
                                    ? Colors.yellow
                                    : Colors.yellow,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.yellow, Colors.white],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  leading: Text(
                                    parseDate(_value.date),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        ' ${_value.category.name}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              _value.type == CategoryType.income
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                      ),
                                      Text(
                                        "₹ ${_value.amount}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              _value.type == CategoryType.income
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
                    itemCount: newList.transactionList.length,
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: searchResult.length,
              );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.last}\n${_splitedDate.first}';
  }
}

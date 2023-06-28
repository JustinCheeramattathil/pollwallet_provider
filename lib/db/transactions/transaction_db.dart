import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gowallet/Account/balance.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../models/category/category_model.dart';
import '../../models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transactio-db';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> transactionList = [];
  List<TransactionModel> incomeListenable = [];
  List<TransactionModel> expenseListenable = [];
  List<TransactionModel> transationAll = [];

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

    db.put(obj.id, obj);
    // log(obj.id.toString(), name: 'add');
    refreshAll();
  }

  Future<void> refreshAll() async {
    final list = await accessTransactions();
    // log(list.length.toString(), name: 'refresh_list');
    list.sort((first, second) => second.date.compareTo(first.date));
    transactionList.clear();
    transactionList.addAll(list);
    // notifyListeners();
    incomeListenable.clear();
    expenseListenable.clear();
    transationAll.clear();
    balanceAmount();

    await Future.forEach(transactionList, (TransactionModel transation) {
      if (transation.category.type == CategoryType.income) {
        incomeListenable.add(transation);
        // log(incomeListenable.length.toString());
      } else if (transation.category.type == CategoryType.expense) {
        expenseListenable.add(transation);
      }
      transationAll.add(transation);
    });
    notifyListeners();
  }

  @override
  Future<List<TransactionModel>> accessTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refreshAll();
  }

  @override
  Future<void> editTransaction(TransactionModel model) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(model.id, model);
    // log(model.id.toString(), name: 'edit');
    refreshAll();
  }

  String a = 'a';

  // Future<void> search(String porpose) async {
  //   final TransactionDB =
  //       await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

  //   transactionListNotifietr.clear();
  //   log(transactionListNotifietr.toString());
  //   // notifyListeners();
  //   transactionListNotifietr.addAll(TransactionDB.values
  //       .where((element) => element.purpose.contains(porpose)));
  //   notifyListeners();
  //   log(transactionListNotifietr.toString());
  // }
  void search(String purpose) async {
    final TransactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionList.clear();

    transactionList.addAll(TransactionDB.values
        .where((element) => element.purpose.contains(purpose)));
    log(transactionList.length.toString());
    notifyListeners();
  }

  DateTime selectedmonth = DateTime.now();
  void selectDate(context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary:
                    Color.fromARGB(213, 20, 27, 38), // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Color.fromARGB(213, 20, 27, 38), // body text color
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedmonth,
        firstDate: DateTime(2021),
        lastDate: DateTime(2030));

    if (picked != null && picked != selectedmonth) {
      selectedmonth = picked;
      notifyListeners();
    }
  }

  List<TransactionModel> results = [];
  dynamic dropDownVale = 'All';

  List items = ['All', 'today', 'yesterday', 'week', 'month'];

  String parseDate(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  void runFilter(String enteredKeyword, TabController tabController) {
    if (enteredKeyword.isEmpty) {
      filter(dropDownVale, tabController);
    } else {
      results = results
          .where((user) => user.category.name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      notifyListeners();
    }
  }

  void filter(newValue, TabController _tabController) {
    // log('filter');

    results = transationAll;
    notifyListeners();

    dropDownVale = newValue;
    notifyListeners();
    //log(results.value.length.toString(), name: 'vvvvvn');
    // log(dropDownVale.toString(), name: 'filter');
    final DateTime now = DateTime.now();
    if (dropDownVale == 'All') {
      results = (_tabController.index == 0
          ? transationAll
          : _tabController.index == 1
              ? incomeListenable
              : expenseListenable);
      notifyListeners();

      // log(_tabController.index.toString(), name: 'filter_tabe');
    } else if (dropDownVale == 'today') {
      results.clear();

      results = (_tabController.index == 0
              ? transationAll
              : _tabController.index == 1
                  ? incomeListenable
                  : expenseListenable)
          .where((element) => parseDate(element.date)
              .toLowerCase()
              .contains(parseDate(DateTime.now()).toLowerCase()))
          .toList();
      notifyListeners();

      // log(_tabController.index.toString(), name: 'filter_tabe');
    } else if (dropDownVale == 'yesterday') {
      results.clear();

      DateTime start = DateTime(now.year, now.month, now.day - 1);
      DateTime end = start.add(const Duration(days: 1));
      results = (_tabController.index == 0
              ? transationAll
              : _tabController.index == 1
                  ? incomeListenable
                  : expenseListenable)
          .where((element) =>
              (element.date.isAfter(start) || element.date == start) &&
              element.date.isBefore(end))
          .toList();
      notifyListeners();

      // log(_tabController.index.toString(), name: 'filter_tabe');
    } else if (dropDownVale == 'week') {
      results.clear();
      notifyListeners();

      DateTime start = DateTime(now.year, now.month, now.day - 6);
      DateTime end = DateTime(start.year, start.month, start.day + 7);
      results = (_tabController.index == 0
              ? transationAll
              : _tabController.index == 1
                  ? incomeListenable
                  : expenseListenable)
          .where((element) =>
              (element.date.isAfter(start) || element.date == start) &&
              element.date.isBefore(end))
          .toList();
      notifyListeners();
    } else {
      results.clear();

      DateTime start = DateTime(selectedmonth.year, selectedmonth.month, 1);
      DateTime end = DateTime(start.year, start.month + 1, start.day);
      results = (_tabController.index == 0
              ? transationAll
              : _tabController.index == 1
                  ? incomeListenable
                  : expenseListenable)
          .where((element) =>
              (element.date.isAfter(start) || element.date == start) &&
              element.date.isBefore(end))
          .toList();
      notifyListeners();
    }
  }
}

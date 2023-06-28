import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../chart_function/chart_function.dart';
import '../../../db/transactions/transaction_db.dart';
import '../home.dart';
import '../../Statistics/Statistics.dart';
import '../../transaction/view_transaction/list_transaction.dart';
import 'bottomNavigation.dart';

class RootPage extends StatelessWidget {
  RootPage({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = [
    HomePage(),
    Screen_Transaction(),
    Statistics_Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext context, int updatedIndex, _) {
                filterFunction();
                if (updatedIndex == 1) {
                  context.read<TransactionProvider>().results =
                      context.read<TransactionProvider>().transationAll;
                }
                return _pages[updatedIndex];
              })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

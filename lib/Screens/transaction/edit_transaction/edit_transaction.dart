import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gowallet/providers/addtransaction/add_transaction_provider.dart';
import 'package:gowallet/providers/edittransaction/edit_transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../db/category/category_db.dart';
import '../../../db/transactions/transaction_db.dart';
import '../../../models/category/category_model.dart';
import '../../../models/transaction/transaction_model.dart';
import '../../home/widgets/rootpage.dart';

class EditTransaction extends StatefulWidget {
  const EditTransaction({super.key, required this.model});
  final TransactionModel model;

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final _formkey = GlobalKey<FormState>();

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    _purposeTextEditingController.text = widget.model.purpose;
    _amountTextEditingController.text = widget.model.amount.toString();
    // _selectedDate = widget.model.date;
    // _selectedCategorytype = widget.model.type;
    // _selectedCategoryModel = widget.model.category;
    // log(widget.model.id.toString(), name: 'idcheck_init');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log(widget.model.id.toString(),name: 'buildcon');
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.yellow,
          title: Text(
            'Edit Transaction',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.yellow[300],
        body: Consumer<EditTransactionProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.yellow, Colors.white])),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            controller: _purposeTextEditingController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              fillColor: Colors.white,
                              labelText: 'Description',
                              hintText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            controller: _amountTextEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              labelText: 'amount',
                              hintText: 'amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.075,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.yellow,
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme:
                                  Theme.of(context).colorScheme.copyWith(
                                        primary: Colors.black,
                                      ),
                            ),
                            child: TextButton.icon(
                              onPressed: () async {
                                final _selectedDateTemp = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now(),
                                );

                                if (_selectedDateTemp == null) {
                                  return;
                                } else {
                                  log(_selectedDateTemp.toString());
                                  _selectedDate = _selectedDateTemp;
                                  provider
                                      .updateSelectedDate(_selectedDateTemp);
                                }
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.black,
                              ),
                              label: Text(
                                _selectedDate == null
                                    ? 'Select Date'
                                    : DateFormat("dd-MMMM-yyyy")
                                        .format(_selectedDate!),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Radio(
                                      value: CategoryType.income,
                                      groupValue: provider.selectedCategorytype,
                                      activeColor: Colors.black,
                                      onChanged: (newValue) {
                                        // setState(() {
                                        //   _selectedCategorytype =
                                        //       CategoryType.income;
                                        //   _categoryID = null;
                                        // });

                                        provider.updateSelectedCategoryType(
                                            CategoryType.income);
                                        provider.updateCategoryId(null);
                                        // log('hello');
                                      }),
                                  Text(
                                    'Income',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Radio(
                                      value: CategoryType.expense,
                                      groupValue: provider.selectedCategorytype,
                                      activeColor: Colors.black,
                                      onChanged: (newValue) {
                                        // setState(() {
                                        //   _selectedCategorytype =
                                        //       CategoryType.expense;
                                        //   _categoryID = null;
                                        // });
                                        provider.updateSelectedCategoryType(
                                            CategoryType.expense);
                                        provider.updateCategoryId(null);
                                      }),
                                  const Text(
                                    'Expense',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 90),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.075,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              color: Colors.yellow,
                              // border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: DropdownButton<String>(
                              underline: Container(),
                              hint: const Text(
                                'Select Category',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: provider.categoryID,
                              items: (provider.selectedCategorytype ==
                                          CategoryType.income
                                      ? context
                                          .watch<CategoryProvider>()
                                          .incomeCategoryListListener
                                      : context
                                          .watch<CategoryProvider>()
                                          .expenseCategoryListListener)
                                  .map((e) {
                                return DropdownMenuItem(
                                  value: e.id,
                                  child: Text(
                                    e.name,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    // print(e.toString());
                                    provider.selectedCategoryModel = e;
                                  },
                                );
                              }).toList(),
                              onChanged: (selectedValue) async {
                                // print(selectedValue);

                                await provider.updateCategoryId(selectedValue);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.yellow,
                              fixedSize: Size(200, 60),
                            ),
                            onPressed: () {
                              editTransaction(
                                provider.selectedCategorytype,
                                provider.selectedDate,
                                provider.selectedCategoryModel,
                                provider.categoryID,
                              );
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            );
          },
        ));
  }

  Future<void> editTransaction(CategoryType Ctype, DateTime? selectedDate,
      CategoryModel? selectedCategoryModel, String? categoryID) async {
    final _purposeText = _purposeTextEditingController.text.trim();
    final _amountText = _amountTextEditingController.text.trim();
    if (_purposeText.isEmpty) {
      log('l6');
      return;
    }
    if (_amountText.isEmpty) {
      log('l7');
      return;
    }
    if (categoryID == null) {
      log('l8');
      return;
    }
    if (selectedDate == null) {
      log('l9');
      return;
    }

    if (selectedCategoryModel == null) {
      log('120');
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    // log(widget.model.id.toString(),name: 'hjuikjnj');

    final _model = TransactionModel(
        purpose: _purposeText,
        amount: _parsedAmount,
        date: selectedDate,
        type: Ctype,
        category: selectedCategoryModel,
        id: widget.model.id);
    log('edit transaction');
    await context.read<TransactionProvider>().editTransaction(_model);

    Navigator.of(context).pop();

    context.read<TransactionProvider>().refreshAll();
  }
}

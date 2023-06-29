import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:gowallet/models/category/category_model.dart';

class AddTransactionProvider with ChangeNotifier {
  DateTime? _selectedDate;
  CategoryType selectedCategorytype = CategoryType.income;
  CategoryModel? selectedCategoryModel;
  String? categoryID;

  DateTime? get selectedDate => _selectedDate;
  // CategoryType get selectedCategoryType => selectedCategorytype;
  // CategoryModel? get selectedCategoryModel => selectedCategoryModel;

  void updateSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void updateSelectedCategoryType(CategoryType type) {
    log(type.toString(), name: 'in');
    selectedCategorytype = type;
    notifyListeners();
  }

  void updateSelectedCategoryModel(CategoryModel? model) {
    selectedCategoryModel = model;
    notifyListeners();
  }

  void updateCategoryId(String? categoryiD) {
    categoryID = categoryiD;
    notifyListeners();
  }
}

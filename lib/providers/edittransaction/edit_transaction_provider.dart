import 'package:flutter/cupertino.dart';

import '../../models/category/category_model.dart';

class EditTransactionProvider with ChangeNotifier {
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
    selectedCategorytype = type;
    notifyListeners();
  }

  void updateSelectedCategoryModel(CategoryModel? model) {
    selectedCategoryModel = model;
    notifyListeners();
  }

  Future<void> updateCategoryId(String? categoryiD) async {
    categoryID = categoryiD;
    notifyListeners();
  }
}

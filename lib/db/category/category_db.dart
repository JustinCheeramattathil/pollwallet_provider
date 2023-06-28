import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category_database';



class CategoryProvider with ChangeNotifier {
  
  List<CategoryModel> incomeCategoryListListener = [];
  List<CategoryModel> expenseCategoryListListener = [];


  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
    
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();

    incomeCategoryListListener.clear();
    expenseCategoryListListener.clear();
    await Future.forEach(
      allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryListListener.add(category);
        } else {
          expenseCategoryListListener.add(category);
        }
      },
    );
    notifyListeners();
   
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.delete(categoryID);
    refreshUI();
    notifyListeners();
  }
}

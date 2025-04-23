import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(name: 'salad', iconPath: 'assets/icons/cat.svg', boxColor: Colors.red)
    );
    categories.add(
        CategoryModel(name: 'salad', iconPath: 'assets/icons/cat.svg', boxColor: Colors.red)
    );
    // categories.add(
    //     CategoryModel(name: 'salad', iconPath: 'assets/icons/cat.svg', boxColor: Colors.red)
    // );
    // categories.add(
    //     CategoryModel(name: 'salad', iconPath: 'assets/icons/cat.svg', boxColor: Colors.red)
    // );
    return categories;
  }
}
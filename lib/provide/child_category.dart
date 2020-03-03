import 'package:flutter/material.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategory = [];
  int childIndex = 0;
    String categoryId = "";
  String categorySubId = "";
  int page = 1;
  getChildCategory(List list) {
    childCategory = list;
    childIndex = 0;
    notifyListeners();
  }

  changeChildIndex(int index) {
    childIndex = index;
    notifyListeners();
  }
}

class CategoryGoodListProvide with ChangeNotifier {
  List<CategoryListData> goodList = [];

  getGoodList(List<CategoryListData> list) {
    goodList = list;
    notifyListeners();
  }


}

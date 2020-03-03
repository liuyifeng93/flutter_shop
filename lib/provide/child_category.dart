import 'package:flutter/material.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategory = [];
  int childIndex = 0;
  Map goodListParams = {};
  List<CategoryListData> goodList = [];
  getChildCategory(List list) {
    childCategory = list;
    childIndex = 0;
    notifyListeners();
  }

  changeChildIndex(int index) {
    childIndex = index;
    notifyListeners();
  }

  changeGoodList(List list) {
    goodList = list;
    notifyListeners();
  }

  requestGoodListParams(Map params) {
    goodListParams = params;
    notifyListeners();
  }
}

class CategoryGoodListProvide with ChangeNotifier {
  List<CategoryListData> goodList = [];
  String categoryId = "";
  String categorySubId = "";
  int page = 1;
  getGoodList(List<CategoryListData> list) {
    goodList = list;
    notifyListeners();
  }


}

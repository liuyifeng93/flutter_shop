import 'package:flutter/material.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
import '../model/category.dart';

class ChildCagetory with ChangeNotifier {
  List<BxMallSubDto> childCategory = [];
  getChildCategory(List list) {
    childCategory = list;
    notifyListeners();
  }
}

class CategoryGoodListProvide with ChangeNotifier {
  Map goodListParams = {};
  requestGoodListParams(Map params) {
    goodListParams = params;
    notifyListeners();
  }
}

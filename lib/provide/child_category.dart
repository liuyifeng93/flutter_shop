import 'package:flutter/material.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
import '../model/category.dart';

class ChildCagetory with ChangeNotifier {
  List<BxMallSubDto> childCategory = [];
  Map goodListParams = {};
  getChildCategory(List list) {
    childCategory = list;
    notifyListeners();
  }

  requestGoodListParams(Map params) {
    goodListParams = params;
    notifyListeners();
  }
}

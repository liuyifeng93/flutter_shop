import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/category.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('商品分类'),
        ),
        body: Container(
            child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav(), CategoryGoodList()],
            ),
          ],
        )),
      ),
    );
  }
}

class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<Data> list = [];
  var currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(100),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1, color: Colors.black12)),
      ),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _leftInkwell(index);
          }),
    );
  }

  Widget _leftInkwell(int index) {
    final model = list[index];
    return InkWell(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
          var childList = model.bxMallSubDto;
          final categoryId = model.mallCategoryId;
          Provide.value<ChildCategory>(context).getChildCategory(childList);
          Provide.value<CategoryGoodListProvide>(context).categoryId =
              categoryId;
          Provide.value<CategoryGoodListProvide>(context).categorySubId = '';
          Provide.value<CategoryGoodListProvide>(context).page = 1;

          _getGoodList();
        },
        child: Container(
          height: ScreenUtil().setHeight(80),
          padding: EdgeInsets.only(left: 10, top: 20),
          decoration: BoxDecoration(
              color: currentIndex == index ? Colors.grey : Colors.white,
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black12),
              )),
          child: Text(
            model.mallCategoryName,
            style: TextStyle(fontSize: 14),
          ),
        ));
  }

  void _getCategory() async {
    await request('getCategory').then((value) {
      var data = json.decode(value.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      var childList = list[0].bxMallSubDto;
      Provide.value<ChildCategory>(context).getChildCategory(childList);
      final firstSubModel = childList.first;
      final params = {
        "categoryId": firstSubModel.mallCategoryId,
        "CategorySubId": firstSubModel.mallSubId,
        "page": 1
      };
      Provide.value<ChildCategory>(context).requestGoodListParams(params);
    });
  }

  void _getGoodList() async {
    final categoryId =
        Provide.value<CategoryGoodListProvide>(context).categoryId;
    final categorySubId =
        Provide.value<CategoryGoodListProvide>(context).categorySubId;
    final page = Provide.value<CategoryGoodListProvide>(context).page;
    var params = {
      "categoryId": categoryId,
      'CategorySubId': categorySubId,
      "page": page
    };
    await request('getMallGoods', formData: params).then((data) {
      final list =
          CategoryGoodsListModel.fromJson(json.decode(data.toString())).data;
      Provide.value<CategoryGoodListProvide>(context).getGoodList(list);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(builder: (context, child, childCategory) {
      return Container(
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(275),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategory.length,
            itemBuilder: (context, index) {
              return _rightInkWell(childCategory.childCategory[index], index);
            }),
      );
    });
  }

  void _getGoodList() async {
    final categoryId =
        Provide.value<CategoryGoodListProvide>(context).categoryId;
    final categorySubId =
        Provide.value<CategoryGoodListProvide>(context).categorySubId;
    final page = Provide.value<CategoryGoodListProvide>(context).page;
    var params = {
      "categoryId": categoryId,
      'CategorySubId': categorySubId,
      "page": page
    };
    await request('getMallGoods', formData: params).then((data) {
      final list =
          CategoryGoodsListModel.fromJson(json.decode(data.toString())).data;
      print(list.map((value) {
        return value.goodsName;
      }).toList());
      Provide.value<CategoryGoodListProvide>(context).getGoodList(list);
    });
  }

  Widget _rightInkWell(BxMallSubDto item, int index) {
    bool isClick = Provide.value<ChildCategory>(context).childIndex == index;
    return InkWell(
      onTap: () {
        Provide.value<CategoryGoodListProvide>(context).categorySubId =
            item.mallSubId;
        Provide.value<CategoryGoodListProvide>(context).page = 1;
        Provide.value<ChildCategory>(context).changeChildIndex(index);
        _getGoodList();
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: 16, color: isClick ? Colors.red : Colors.grey),
        ),
      ),
    );
  }
}

class CategoryGoodList extends StatefulWidget {
  CategoryGoodList({Key key}) : super(key: key);

  @override
  _CategoryGoodListState createState() => _CategoryGoodListState();
}

class _CategoryGoodListState extends State<CategoryGoodList> {
  @override
  var scrollController = new ScrollController();
  void initState() {
    _getGoodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodListProvide>(
        builder: (context, child, provider) {
      try {
        if (Provide.value<CategoryGoodListProvide>(context).page == 1) {
          scrollController.jumpTo(0.0);
        }
      } catch (e) {
        print('切换大类');
      }
      final goodList = provider.goodList;
      if (goodList.isNotEmpty) {
        return Expanded(
          child: Container(
              width: ScreenUtil().setWidth(270),
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: Wrap(
                    spacing: 2,
                    children: goodList.map((model) {
                      return _categoryItem(model);
                    }).toList(),
                  ))),
        );
      } else {
        return Text('没有数据');
      }
    });
  }

  _getGoodList() async {
    var params = {"categoryId": '4', 'CategorySubId': '', "page": 1};
    await request('getMallGoods', formData: params).then((data) {
      final list =
          CategoryGoodsListModel.fromJson(json.decode(data.toString())).data;
      Provide.value<CategoryGoodListProvide>(context).getGoodList(list);
    });
  }

  Widget _categoryItem(CategoryListData model) {
    return Container(
      width: ScreenUtil().setWidth(260 / 2),
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1, color: Colors.black12),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            model.image,
            fit: BoxFit.fill,
            width: ScreenUtil().setWidth(260 / 2),
            height: ScreenUtil().setWidth(260 / 2),
          ),
          Text(model.goodsName),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('${model.presentPrice}'),
              Text(
                '${model.oriPrice}',
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
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
    // TODO: implement initState
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
          var childList = list[index].bxMallSubDto;
          Provide.value<ChildCagetory>(context).getChildCategory(childList);
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
      Provide.value<ChildCagetory>(context).getChildCategory(childList);
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
    return Provide<ChildCagetory>(builder: (context, child, childCategory) {
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
              return _rightInkWell(childCategory.childCategory[index]);
            }),
      );
    });
  }

  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      onTap: () {
        final data = {
          "categoryId": item.mallCategoryId,
          "CategorySubId": item.mallSubId,
          "page": 1
        };
        Provide.value<ChildCagetory>(context).requestGoodListParams(data);
        print('选者类别');
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: 16),
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
  List<CategoryListData> list = [];
  @override
  void initState() {
    super.initState();
    _getGoodList();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCagetory>(builder: (context, child, provider) {
      print('接受到信号');
      _getGoodList(params: provider.goodListParams).then((value) {
        print(value);
      });
      return FutureBuilder(
          future: _getGoodList(params: provider.goodListParams),
          builder: (context, params) {
            if (params.hasData) {
              list = CategoryGoodsListModel.fromJson(
                      json.decode(params.data.toString()))
                  .data;
              return Container(
                width: ScreenUtil().setWidth(270),
                height: ScreenUtil().setHeight(1000 - 22),
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final model = list[index];
                      return _categoryItem(model);
                    }),
              );
            } else {
              return Text('没有数据');
            }
          });
    });
    // return Provide(builder: (context, child, goodListParams) {
    //   return FutureBuilder(
    //     future: _getGoodList(),
    //     builder: (context, params){
    //       print(params);
    //     });
    // }

    //  return Container(
    //   width: ScreenUtil().setWidth(270),
    //   height: ScreenUtil().setHeight(1000 - 22),
    //   child: ListView.builder(
    //     itemCount: list.length,
    //     itemBuilder: (context, index) {
    //       final model = list[index];
    //       return _categoryItem(model);
    //   }),
    //   );
  }

  Future _getGoodList({Map params}) async {
    var response = await request('getMallGoods', formData: params);
    return response;
  }

  Widget _categoryItem(CategoryListData model) {
    return Container(
      width: ScreenUtil().setWidth(270 / 2),
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
            width: ScreenUtil().setWidth(270 / 2),
            height: ScreenUtil().setWidth(200),
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

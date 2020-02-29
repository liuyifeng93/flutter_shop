import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _typeController = TextEditingController();
  String showText = "welcome";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('百姓生活+')),
        body: FutureBuilder(
          future: getHomePageContent(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data..toString());
              List<Map> swiper = (data['data']['slides'] as List).cast();
              print(swiper);
              return Column(children: <Widget>[
                SwiperDiy(swiperDataList: swiper)
              ],);
            } else {
              return Center(child: Text('加载中'),);
            }
          },
        ),
      ),
    );
  }
}

/// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);
  final List swiperDataList;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 1334);
    return Container(
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          pagination: SwiperPagination(),
          autoplay: true,
          itemCount: swiperDataList.length,
          itemBuilder: (BuildContext ctx, int index) {
            var url = swiperDataList[index]['image'];
            print(url);
            return Image.network(url, fit: BoxFit.fill,);
          },
        ));
  }
}

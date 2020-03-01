import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int page = 0;
  List<Map> hotGoodList = [];

  @override
  void initState() {
    super.initState();
    _getHotGoodList();
    print('111111');
  }

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
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'].toString();
              String leaderImage =
                  data['data']['shopInfo']['leaderImage'].toString();
              String leaderPhone =
                  data['data']['shopInfo']['leaderPhone'].toString();
              List<Map> recommandList =
                  (data['data']['recommend'] as List).cast();
              String floor1Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS'].toString();
              String floor2Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS'].toString();
              String floor3Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS'].toString();
              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor2'] as List).cast();
              List<Map> floor3 = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                header: ClassicalHeader(
                  refreshText: '哈哈哈 正在刷新',
                  refreshedText: '刷新完毕',
                  showInfo: false,
                ),
                onRefresh: () async{
                  getHomePageContent();
                },
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiper),
                    TopNavigator(
                      navigatorList: navigatorList,
                    ),
                    AdBanner(
                      adPicture: adPicture,
                    ),
                    LeaderPhone(
                      leaderPhone: leaderPhone,
                      picture: leaderImage,
                    ),
                    Recommand(recommandList: recommandList),
                    FloorTitle(picture: floor1Title),
                    FloorContent(
                      floorGoodList: floor1,
                    ),
                    FloorTitle(picture: floor2Title),
                    FloorContent(
                      floorGoodList: floor2,
                    ),
                    FloorTitle(picture: floor3Title),
                    FloorContent(
                      floorGoodList: floor3,
                    ),
                    HotGoodList(
                      hotGoods: hotGoodList,
                    ),
                  ],
                ),
                onLoad: () async {
                  _getHotGoodList();
                },
              );
            } else {
              return Center(
                child: Text('加载中'),
                
              );
            }
          },
        ),
      ),
    );
  }

  void _getHotGoodList() {
    final formdata = {"page": page};
    request('homePageBelowConten', formData: formdata).then((value) {
      var data = json.decode(value.toString());
      List<Map> list = (data["data"] as List).cast();
      setState(() {
        hotGoodList.addAll(list);
        page++;
      });
    });
  }
}

/// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);
  final List swiperDataList;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          pagination: SwiperPagination(),
          autoplay: true,
          itemCount: swiperDataList.length,
          itemBuilder: (BuildContext ctx, int index) {
            var url = swiperDataList[index]['image'];
            return Image.network(
              url,
              fit: BoxFit.fill,
            );
          },
        ));
  }
}

class TopNavigator extends StatelessWidget {
  const TopNavigator({Key key, this.navigatorList}) : super(key: key);
  final List navigatorList;

  Widget _gridViewItemUI(BuildContext ctx, item) {
    return InkWell(
        onTap: () {
          print('点击了导航选项');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              item['image'],
              width: ScreenUtil().setWidth(30),
              height: ScreenUtil().setWidth(30),
            ),
            Text(item['mallCategoryName'])
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(250),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.take(10).map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  const AdBanner({Key key, this.adPicture}) : super(key: key);
  final String adPicture;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          print('点击了广告栏');
        },
        child: Image.network(
          adPicture,
        ),
      ),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  const LeaderPhone({Key key, this.picture, this.leaderPhone})
      : super(key: key);
  final String picture;
  final String leaderPhone;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        _lancher(leaderPhone);
      },
      child: Image.network(picture),
    ));
  }

  void _lancher(String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('url不能拨打电话');
    }
  }
}

class Recommand extends StatelessWidget {
  const Recommand({Key key, this.recommandList}) : super(key: key);
  final List recommandList;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[_titleWidget(), _recommandList()],
    ));
  }

  Widget _titleWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
      child: Text('商品推荐', style: TextStyle(color: Colors.pink)),
    );
  }

  Widget _recommandItem(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(150),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 0.5, color: Colors.black12)),
        ),
        child: Column(
          children: <Widget>[
            Image.network(
              recommandList[index]['image'],
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setWidth(200),
            ),
            Text('¥${recommandList[index]['mallPrice']}'),
            Text(
              '¥${recommandList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommandList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: recommandList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return _recommandItem(index);
        },
      ),
    );
  }
}

class FloorTitle extends StatelessWidget {
  const FloorTitle({Key key, this.picture}) : super(key: key);
  final String picture;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture),
    );
  }
}

class FloorContent extends StatelessWidget {
  const FloorContent({Key key, this.floorGoodList}) : super(key: key);
  final List floorGoodList;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[_firstRow(), _otherGoods()],
    ));
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodItem(floorGoodList[0]),
        Column(
          children: <Widget>[
            _goodItem(floorGoodList[1]),
            _goodItem(floorGoodList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodItem(floorGoodList[3]),
        _goodItem(floorGoodList[4]),
      ],
    );
  }

  Widget _goodItem(Map goods) {
    return Container(
        width: ScreenUtil().setWidth(375 / 2),
        child: InkWell(
          onTap: () {
            print('点击商品了');
          },
          child: Image.network(goods['image']),
        ));
  }
}

class HotGoodList extends StatelessWidget {
  const HotGoodList({Key key, this.hotGoods}) : super(key: key);
  final List<Map> hotGoods;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[hotTitle(), hotGoodListContent()],
    ));
  }

  Widget hotGoodListContent() {
    if (hotGoods.isEmpty) {
      return Text('加载中');
    } else {
      final List<Widget> list = hotGoods.map((value) {
        return InkWell(
          onTap: () {
            print('点击了hot');
          },
          child: hotGoodItem(value),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: list,
      );
    }
  }

  Widget hotTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Text('火爆专区'),
    );
  }

  Widget hotGoodItem(Map data) {
    return Container(
        width: ScreenUtil().setWidth(372 / 2),
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              data['image'],
            ),
            Text(
              data['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.pink, fontSize: ScreenUtil().setSp(13)),
            ),
            Row(
              children: <Widget>[
                Text('¥${data['mallPrice']}'),
                Text(
                  '¥${data['price']}',
                  style: TextStyle(
                      color: Colors.black26,
                      decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
          ],
        ));
  }
}

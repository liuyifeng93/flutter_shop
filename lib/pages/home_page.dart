import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
          appBar: AppBar(title: Text('美好人间')),
          body: Container(
              child: Column(
            children: <Widget>[
              TextField(
                autofocus: false,
                controller: _typeController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '美女类型',
                  helperText: '请输入你喜欢的类型',
                ),
              ),
              RaisedButton(
                onPressed: _choiceAction,
                child: Text('选择完毕'),
              ),
              Text(
                showText,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ))),
    );
  }

void _choiceAction() {
  print('object');
  if (_typeController.text.isEmpty) {
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(title: Text("美女类型不能为空")));
  } else {
    final str = _typeController.text.toString();
    getHttp(str).then((value){
      setState(() {
        showText = value['data']['name'].toString();
      });
    });
  }
}
  Future getHttp(String url) async {
    try {
      Response response;
      var data = {"name": url};
      response = await Dio().get(
          "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian",
          queryParameters: data);
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车界面'),
      ),
      body: Center(
        child: Column(
         children: <Widget>[
           Number(),
           MyButton()
         ], 
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {
  const Number({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200),
      child: Container(),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 200),
      child: RaisedButton(
        child: Text('递增'),
        onPressed: () {
          
      }),
    );
  }
}

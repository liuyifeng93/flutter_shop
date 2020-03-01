import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'provide/counter.dart';
import 'package:provide/provide.dart';

void main() {
  var counter = Counter();
  var providers = Providers();
  providers..provide(Provider<Counter>.value(counter));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '百姓生活+',
      theme: ThemeData(primaryColor: Colors.pink),
      home: IndexPage(),
    ));
  }
}

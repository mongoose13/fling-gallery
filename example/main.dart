import 'package:flutter/material.dart';
import 'package:fling_gallery/fling_gallery.dart' as fling;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fling Gallery Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fling Gallery Demo"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.blueGrey,
            child: fling.Gallery(
              preferredRowHeight: 300.0,
              children: <Widget>[
                Image.asset("assets/images/img_01.jpg"),
                Image.asset("assets/images/img_02.jpg"),
                Image.asset("assets/images/img_03.jpg"),
                Image.asset("assets/images/img_04.jpg"),
                Image.asset("assets/images/img_05.jpg"),
                Image.asset("assets/images/img_06.jpg"),
                Image.asset("assets/images/img_07.jpg"),
                Image.asset("assets/images/img_08.jpg"),
                Image.asset("assets/images/img_09.jpg"),
                Image.asset("assets/images/img_10.jpg"),
                Image.asset("assets/images/img_11.jpg"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

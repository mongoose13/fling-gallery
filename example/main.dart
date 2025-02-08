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
                Container(
                  width: 250.0,
                  height: 700.0,
                  color: Colors.red,
                ),
                Container(
                  width: 400.0,
                  height: 600.0,
                  color: Colors.blue,
                ),
                Container(
                  width: 200.0,
                  height: 1000.0,
                  color: Colors.green,
                ),
                Container(
                  width: 150.0,
                  height: 700.0,
                  color: Colors.yellow,
                ),
                Container(
                  width: 300.0,
                  height: 800.0,
                  color: Colors.purple,
                ),
                Container(
                  width: 100.0,
                  height: 700.0,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

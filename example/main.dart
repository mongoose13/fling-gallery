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
          title: Text("Fling Gallery Demo - 0.2.0"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Resize your window to see how the gallery adjusts!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Divider(),
              Text("preferredRowHeight = 300\nforceFill = true"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 48.0),
                padding: EdgeInsets.all(8.0),
                color: Colors.blueGrey,
                child: fling.Gallery(
                  layoutStrategy: fling.GreedyLayout(
                    horizontalSpacing: 0.0,
                    verticalSpacing: 0.0,
                    preferredRowHeight: 300.0,
                    forceFill: true,
                  ),
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
              SizedBox(height: 48.0),
              Divider(),
              Text(
                  "preferredRowHeight = 100\nmaxRowItems = 4\nforceFill = false"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 48.0),
                padding: EdgeInsets.all(8.0),
                color: Colors.blueGrey,
                child: fling.Gallery(
                  layoutStrategy: fling.GreedyLayout(
                    preferredRowHeight: 100.0,
                    maxRowItems: 4,
                    forceFill: false,
                  ),
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
              SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}

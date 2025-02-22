import 'package:flutter/material.dart';
import 'package:fling_gallery/fling_gallery.dart' as fling;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MaterialApp(
        title: 'Fling Gallery Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text("Fling Gallery Demo - 1.0.1"),
            bottom: TabBar(
              tabs: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("AStarGalleryLayout"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("GreedyGalleryLayout"),
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Resize your window to see how the gallery adjusts!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Divider(),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 48.0),
                        padding: EdgeInsets.all(8.0),
                        color: Colors.blueGrey,
                        child: fling.Gallery(
                          layoutStrategy: fling.AStarGalleryLayout(
                            minRatio: 0.7,
                            maxRatio: 1.3,
                            preferredRowHeight: 300.0,
                          ),
                          children: List.generate(
                            11,
                            (index) => Image.network(
                                "https://f000.backblazeb2.com/file/mongoose-website/fling-gallery/img_${index < 9 ? "0${index + 1}" : index + 1}.jpg"),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 48.0),
                        padding: EdgeInsets.all(8.0),
                        color: Colors.blueGrey,
                        child: fling.Gallery(
                          layoutStrategy: fling.GreedyGalleryLayout(
                            preferredRowHeight: 300.0,
                            forceFill: true,
                          ),
                          children: List.generate(
                            11,
                            (index) => Image.network(
                                "https://f000.backblazeb2.com/file/mongoose-website/fling-gallery/img_${index < 9 ? "0${index + 1}" : index + 1}.jpg"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

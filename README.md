# Fling Gallery

![Fling logo](https://f000.backblazeb2.com/file/mongoose-website/fling-title.png)

A Flutter widget that lays out its children into tight rows.

[![Build Status](https://img.shields.io/circleci/build/bitbucket/mongoose13/fling-gallery)](https://app.circleci.com/pipelines/bitbucket/mongoose13/fling-gallery?branch=master&filter=all)
[![Code Quality](https://img.shields.io/codacy/grade/749ee1e8ee2e4d26ab57b3256f422e9a?style=plastic)](https://www.codacy.com/bb/gelbermungo/fling-gallery/dashboard)
[![Pub Version](https://img.shields.io/pub/v/fling_gallery?style=plastic)](https://pub.dev/packages/fling_gallery)

## Overview

This widget creates rows for its children not unlike a Wrap widget. However, unlike the Wrap widget, this widget tries to size its children so that they fit perfectly on each row. This widget is expected to be used with children that maintain their aspect ratios, such as [Image](https://api.flutter.dev/flutter/widgets/Image-class.html) or [AspectRatio](https://api.flutter.dev/flutter/widgets/AspectRatio-class.html).

We offer two algorithms: greedy and A*. A* will generally give better results, but if performance is a concern, consider using the greedy algorithm instead. The A* algorithm also tends to shift things around more dramatically as the gallery resizes, so if smoothness during resize is a concern you may be better off with the greedy algorithm. You can play with both on the demo page.

[Demo Page](https://fling-gallery-demo.web.app/)

![Example gallery with photos of Yellowstone](https://f000.backblazeb2.com/file/mongoose-website/fling-gallery/fling-gallery-snap.png)

## Usage

### Installation

Install the widget the usual way:

> $> flutter pub add fling_gallery

...or add it manually to your `pubspec.yaml` under "dependencies", then:

> $> flutter pub get

You can then import it in your code:

```dart
import 'package:fling_gallery/fling_gallery.dart';
```

### Instantiation

Place the widget in a constrained space of your widget tree. It will (generally) attempt to take up as much horizontal space as it is given. It will take up as much vertical space as it needs given the horizontal constraints, limited by the vertical constraints you give it.

Ensure the children are aspect ratio aware for best results. The built-in `Image` class does this, but you can also wrap your children in `AspectRatio` widgets.

Choose an implementation of `GalleryLayout` you want to use, and pass that along with the children you want to lay out to its constructor.

For example:
```dart
@override
Widget build(BuildContext context) {
    // ...
        Gallery(
            layoutStrategy: AStarGalleryLayout(
                minRatio: 0.7,
                maxRatio: 1.3,
                horizontalSpacing: 4.0,
                verticalSpacing: 4.0,
                preferredRowHeight: 300.0,
            ),
            children: <Widget>[
                // ...
            ],
        )
    // ...
}
```

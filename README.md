# Fling Gallery

![Fling logo](https://f000.backblazeb2.com/file/mongoose-website/fling-title.png)

A Flutter widget that lays out its children into tight rows.

[![Build Status](https://img.shields.io/circleci/build/bitbucket/mongoose13/fling-gallery)](https://app.circleci.com/pipelines/bitbucket/mongoose13/fling-gallery?branch=master&filter=all)
[![Code Quality](https://img.shields.io/codacy/grade/749ee1e8ee2e4d26ab57b3256f422e9a?style=plastic)](https://www.codacy.com/bb/gelbermungo/fling-gallery/dashboard)
[![Pub Version](https://img.shields.io/pub/v/fling_gallery?style=plastic)](https://pub.dev/packages/fling_gallery)

## Overview

This widget creates rows for its children not unlike a Wrap widget. However, unlike the Wrap widget, this widget tries to size its children so that they fit perfectly on each row. This widget is expected to be used with children that maintain their aspect ratios, such as [Image](https://api.flutter.dev/flutter/widgets/Image-class.html) or [AspectRatio](https://api.flutter.dev/flutter/widgets/AspectRatio-class.html).

The current implementation uses a greedy algorithm and thus may not optimally arrange items. In particular, the last row may not have enough items to fill it completely. You can still control how the last row is rendered: either force it to be filled, or set sensible ratios at which point you would want to force the row to be filled.

[Demo Page](https://fling-gallery-demo.web.app/)

![Example gallery with photos of Yellowstone](https://f000.backblazeb2.com/file/mongoose-website/fling-gallery/fling-gallery-snap.png)

## Parameters

### preferredRowHeight

This defines the preferred height for each row. The widget will attempt to resize its children to make them fit as close to this height as possible while completely filling each row.

### maxRowItems

Set a maximum number of items in each row. Leave empty to allow any number of items so long as they fit reasonably well within the bounds of the row.

### horizontal / veticalSpacing

Changes the amount of space left blank in between items, both horizontally and vertically.

### maxScaleRatio

Sets the threshold for when the algorithm will decide to render a row that is too short (width-wise) using the `preferredRowHeight` rather than forcing the row to fill completely (thus going over the `preferredRowHeight`). The larger this number, the more likely the widget is to force fill the last row.

### forceFill

Forces the last row to fill the width completely regardless of how much this means the row height must differ from `preferredRowHeight`.

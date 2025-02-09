# Fling Gallery

![Fling logo](https://f000.backblazeb2.com/file/mongoose-website/fling-title.png)

A Flutter widget that lays out its children into tight rows.

[![Build Status](https://img.shields.io/circleci/build/bitbucket/mongoose13/fling-gallery)](https://app.circleci.com/pipelines/bitbucket/mongoose13/fling-gallery?branch=master&filter=all)
[![Code Quality](https://img.shields.io/codacy/grade/749ee1e8ee2e4d26ab57b3256f422e9a?style=plastic)](https://www.codacy.com/bb/gelbermungo/fling-gallery/dashboard)
[![Pub Version](https://img.shields.io/pub/v/fling_gallery?style=plastic)](https://pub.dev/packages/fling_gallery)

## Overview

This widget creates rows for its children not unlike a Wrap widget. However, unlike the Wrap widget, this widget tries to size its children so that they fit perfectly on each row.

The current implementation uses a greedy algorithm and thus may not optimally arrange items. In particular, the last row may not have enough items to fill it completely.

[Demo Page](https://fling-gallery-demo.web.app/)

![Example gallery with photos of Yellowstone](https://f000.backblazeb2.com/file/mongoose-website/fling-gallery/fling-gallery-snap.png)

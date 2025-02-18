// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fling_gallery/fling_gallery.dart';

void main() {
  group("Gallery", () {
    group("Sanity", () {
      testWidgets('Empty gallery lays itself out without errors',
          (WidgetTester tester) async {
        // given
        final gallery = Center(
          child: Gallery(
            preferredRowHeight: 200.0,
          ),
        );

        // when
        await tester.pumpWidget(gallery);
      });
      testWidgets('Single item gallery lays itself out without errors',
          (WidgetTester tester) async {
        // given
        final gallery = Center(
          child: Gallery(
            preferredRowHeight: 200.0,
            children: <Widget>[
              AspectRatio(aspectRatio: 10.0 / 10.0),
            ],
          ),
        );

        // when
        await tester.pumpWidget(gallery);
      });
      testWidgets('Multiple item gallery lays itself out without errors',
          (WidgetTester tester) async {
        // given
        final gallery = Center(
          child: Gallery(
            preferredRowHeight: 200.0,
            children: <Widget>[
              AspectRatio(aspectRatio: 10.0 / 10.0),
              AspectRatio(aspectRatio: 40.0 / 20.0),
            ],
          ),
        );

        // when
        await tester.pumpWidget(gallery);
      });
    });

    group("Layout dimensions", () {
      testWidgets('Single row gallery lays out to its preferred size',
          (WidgetTester tester) async {
        // given
        final gallery = Gallery(
          horizontalSpacing: 0.0,
          preferredRowHeight: 100.0,
          children: <Widget>[
            AspectRatio(aspectRatio: 10.0 / 50.0),
            AspectRatio(aspectRatio: 15.0 / 50.0),
          ],
        );
        final container = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 10.0,
              maxWidth: 100.0,
              minHeight: 60.0,
              maxHeight: 300.0,
            ),
            child: gallery,
          ),
        );

        // when
        await tester.pumpWidget(container);

        // then
        expect(tester.getSize(find.byWidget(gallery)), Size(50.0, 100.0));
      });
      testWidgets(
          'Single row gallery lays out to its maximum size when sensible',
          (WidgetTester tester) async {
        // given
        final gallery = Gallery(
          horizontalSpacing: 0.0,
          maxScaleRatio: 4.0,
          preferredRowHeight: 100.0,
          children: <Widget>[
            AspectRatio(aspectRatio: 10.0 / 50.0),
            AspectRatio(aspectRatio: 15.0 / 50.0),
          ],
        );
        final container = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 10.0,
              maxWidth: 100.0,
              minHeight: 60.0,
              maxHeight: 300.0,
            ),
            child: gallery,
          ),
        );

        // when
        await tester.pumpWidget(container);

        // then
        expect(tester.getSize(find.byWidget(gallery)), Size(100.0, 200.0));
      });
      testWidgets('Single row gallery lays out to its maximum size when forced',
          (WidgetTester tester) async {
        // given
        final gallery = Gallery(
          forceFill: true,
          horizontalSpacing: 0.0,
          preferredRowHeight: 100.0,
          children: <Widget>[
            AspectRatio(aspectRatio: 5.0 / 50.0),
            AspectRatio(aspectRatio: 7.5 / 50.0),
          ],
        );
        final container = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 60.0,
              maxWidth: 100.0,
              minHeight: 60.0,
              maxHeight: 500.0,
            ),
            child: gallery,
          ),
        );

        // when
        await tester.pumpWidget(container);

        // then
        expect(tester.getSize(find.byWidget(gallery)), Size(100.0, 400.0));
      });
      testWidgets(
          'Single row gallery lays out to its constrained maximum size when not upscaling',
          (WidgetTester tester) async {
        // given
        final gallery = Gallery(
          horizontalSpacing: 0.0,
          preferredRowHeight: 100.0,
          children: <Widget>[
            AspectRatio(aspectRatio: 10.0 / 50.0),
            AspectRatio(aspectRatio: 15.0 / 50.0),
          ],
        );
        final container = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 10.0,
              maxWidth: 200.0,
              minHeight: 60.0,
              maxHeight: 300.0,
            ),
            child: gallery,
          ),
        );

        // when
        await tester.pumpWidget(container);

        // then
        expect(tester.getSize(find.byWidget(gallery)), Size(50.0, 100.0));
      });
      testWidgets(
          'Single row gallery lays out to its constrained maximum height when forced',
          (WidgetTester tester) async {
        // given
        final gallery = Gallery(
          forceFill: true,
          horizontalSpacing: 0.0,
          preferredRowHeight: 100.0,
          children: <Widget>[
            AspectRatio(aspectRatio: 5.0 / 50.0),
            AspectRatio(aspectRatio: 7.5 / 50.0),
          ],
        );
        final container = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 60.0,
              maxWidth: 100.0,
              minHeight: 60.0,
              maxHeight: 300.0,
            ),
            child: gallery,
          ),
        );

        // when
        await tester.pumpWidget(container);

        // then
        expect(tester.getSize(find.byWidget(gallery)), Size(100.0, 300.0));
      });
      testWidgets('Single row gallery respects minimum width',
          (WidgetTester tester) async {
        // given
        final gallery = Gallery(
          horizontalSpacing: 0.0,
          preferredRowHeight: 100.0,
          children: <Widget>[
            AspectRatio(aspectRatio: 10.0 / 50.0),
            AspectRatio(aspectRatio: 15.0 / 50.0),
          ],
        );
        final container = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 60.0,
              maxWidth: 100.0,
              minHeight: 60.0,
              maxHeight: 300.0,
            ),
            child: gallery,
          ),
        );

        // when
        await tester.pumpWidget(container);

        // then
        expect(tester.getSize(find.byWidget(gallery)), Size(60.0, 120.0));
      });
    });
  });
}

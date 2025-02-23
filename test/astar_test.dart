import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fling_gallery/fling_gallery.dart';

Widget buildConstrainedBox(BoxConstraints constraints, Widget gallery) {
  return Align(
    alignment: Alignment.topLeft,
    child: ConstrainedBox(
      constraints: constraints,
      child: gallery,
    ),
  );
}

void main() {
  group("AStarGalleryLayout", () {
    group("layout dimensions", () {
      group("without spacing", () {
        group("no children", () {
          testWidgets("has zero base size", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 100.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(0.0, 0.0));
          });
          testWidgets("matches minimum size", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 10.0,
                maxWidth: 100.0,
                minHeight: 10.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(10.0, 10.0));
          });
        });

        group("one child", () {
          testWidgets("fills width", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 2.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 100.0));
          });
          testWidgets("constrains height to max ratio if children are infinite",
              (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 200.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.5,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  ConstrainedBox(constraints: BoxConstraints()),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 250.0));
          });
          testWidgets("respects minimum height", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 200.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 2.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 200.0));
          });
          testWidgets("overflows on height", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: 100.0,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 1.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 100.0));
          });
          testWidgets("keeps to ratio constraints when unforced",
              (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  forceFill: false,
                  minRatio: 0.5,
                  maxRatio: 1.2,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 1.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(120.0, 120.0));
          });
          testWidgets("allows override of ratio constraints",
              (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  forceFill: true,
                  minRatio: 0.5,
                  maxRatio: 1.2,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 1.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 200.0));
          });
        });

        group("multiple children in a single row", () {
          testWidgets("fills width", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 1.0),
                  AspectRatio(aspectRatio: 1.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 100.0));
          });
          testWidgets("positions a child after a zero width child",
              (WidgetTester tester) async {
            // given
            final firstChild = Container();
            final secondChild = Container();
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[firstChild, secondChild],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(
                tester.getTopLeft(find.byWidget(firstChild)), Offset(0.0, 0.0));
            expect(tester.getTopLeft(find.byWidget(secondChild)),
                Offset(0.0, 0.0));
          });
          testWidgets("respects minimum height", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 200.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 1.0),
                  AspectRatio(aspectRatio: 1.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 200.0));
          });
          testWidgets("overflows on height", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: 100.0,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 0.5),
                  AspectRatio(aspectRatio: 0.5),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 100.0));
          });
          testWidgets("keeps to max ratio if insufficient content",
              (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  forceFill: false,
                  minRatio: 0.5,
                  maxRatio: 1.2,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 0.5),
                  AspectRatio(aspectRatio: 0.5),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(120.0, 120.0));
          });
          testWidgets("allows override of ratio constraints",
              (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  forceFill: true,
                  minRatio: 0.5,
                  maxRatio: 1.1,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 0.5),
                  AspectRatio(aspectRatio: 0.5),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 200.0));
          });
          testWidgets("overridden ratios still limited by page constraints",
              (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 80.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  forceFill: true,
                  minRatio: 0.9,
                  maxRatio: 1.1,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 2.0),
                  AspectRatio(aspectRatio: 2.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(80.0, 80.0));
          });
        });

        group("multiple children in two rows", () {
          testWidgets("fills width", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 200.0));
          });
          testWidgets("respects minimum height", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 300.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 300.0));
          });
          testWidgets("overflows on height", (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: 100.0,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  minRatio: 0.5,
                  maxRatio: 2.0,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                  AspectRatio(aspectRatio: 0.25),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 100.0));
          });
          testWidgets("keeps to ratio constraints",
              (WidgetTester tester) async {
            // given
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  forceFill: false,
                  minRatio: 0.9,
                  maxRatio: 1.1,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: <Widget>[
                  AspectRatio(aspectRatio: 1.0),
                  AspectRatio(aspectRatio: 1.0),
                  AspectRatio(aspectRatio: 1.0),
                  AspectRatio(aspectRatio: 1.0),
                ],
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(tester.getSize(find.byType(Gallery)), Size(200.0, 200.0));
          });
          testWidgets("positions children", (WidgetTester tester) async {
            // given
            final childKeys = List.generate(4, (_) => GlobalKey());
            final widget = buildConstrainedBox(
              BoxConstraints(
                minWidth: 0.0,
                maxWidth: 200.0,
                minHeight: 0.0,
                maxHeight: double.infinity,
              ),
              Gallery(
                layoutStrategy: AStarGalleryLayout(
                  preferredRowHeight: 100.0,
                  forceFill: false,
                  minRatio: 0.9,
                  maxRatio: 1.1,
                  horizontalSpacing: 0.0,
                  verticalSpacing: 0.0,
                ),
                children: childKeys
                    .map(
                      (key) => AspectRatio(
                        aspectRatio: 1.0,
                        key: key,
                      ),
                    )
                    .toList(growable: false),
              ),
            );

            // when
            await tester.pumpWidget(widget);

            // then
            expect(
                tester.getTopLeft(find.byKey(childKeys[0])), Offset(0.0, 0.0));
            expect(tester.getTopLeft(find.byKey(childKeys[1])),
                Offset(100.0, 0.0));
            expect(tester.getTopLeft(find.byKey(childKeys[2])),
                Offset(0.0, 100.0));
            expect(tester.getTopLeft(find.byKey(childKeys[3])),
                Offset(100.0, 100.0));
          });
        });
      });
    });
  });
}

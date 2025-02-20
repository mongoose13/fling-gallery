import 'dart:math' as math;

import 'package:fling_gallery/src/layout.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// [ParentData] for use with [GalleryRenderObject].
class GalleryParentData extends ContainerBoxParentData<RenderBox> {}

/// [RenderBox] for a gallery widget.
class GalleryRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GalleryParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GalleryParentData> {
  GalleryLayoutStrategy get layoutStrategy => _layoutStrategy;
  GalleryLayoutStrategy _layoutStrategy;
  set layoutStrategy(GalleryLayoutStrategy newStrategy) {
    if (newStrategy != _layoutStrategy) {
      _layoutStrategy = newStrategy;
      markNeedsLayout();
    }
  }

  /// The [RenderObject] for the [Gallery] widget.
  GalleryRenderObject({
    required GalleryLayoutStrategy layoutStrategy,
    List<RenderBox>? children,
  }) : _layoutStrategy = layoutStrategy {
    addAll(children);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! GalleryParentData) {
      child.parentData = GalleryParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _childSizes().fold(
      0.0,
      (previous, child) => math.max(previous, child.width),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _childSizes().fold(
      0.0,
      (previous, child) => previous + child.width,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _computeRows(BoxConstraints(maxWidth: width)).height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _computeRows(constraints).size;
  }

  @override
  void performLayout() {
    final layout = _computeRows(constraints);
    size = layout.size;

    Offset offset = const Offset(0.0, 0.0);
    for (var row in layout.rows) {
      final rowHeight = row.ratio * layoutStrategy.preferredRowHeight;
      for (var slot in row.slots) {
        final slotWidth = slot.width * row.ratio;
        final child = slot.child;
        child.layout(
            BoxConstraints(
              maxWidth: slotWidth.isNaN ? 0.0 : slotWidth,
              maxHeight: rowHeight.isFinite ? rowHeight : 0.0,
            ),
            parentUsesSize: true);
        (child.parentData! as GalleryParentData).offset = offset;
        offset = Offset(
            offset.dx + slotWidth + layoutStrategy.horizontalSpacing,
            offset.dy);
      }
      offset =
          Offset(0.0, offset.dy + rowHeight + layoutStrategy.verticalSpacing);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  Iterable<RenderBox> get children sync* {
    var child = firstChild;
    while (child != null) {
      yield child;
      child = childAfter(child);
    }
  }

  /// Returns an iterator over the sizes of all children, in order.
  Iterable<Size> _childSizes() sync* {
    RenderBox? child = firstChild;
    while (child != null) {
      final childSize = child.getDryLayout(
          BoxConstraints.tightFor(height: layoutStrategy.preferredRowHeight));
      yield childSize;
      child = childAfter(child);
    }
  }

  /// Calculates the finished layout given parent constraints.
  GalleryLayout _computeRows(BoxConstraints constraints) {
    return layoutStrategy.build(this, constraints);
  }
}

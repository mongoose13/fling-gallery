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
  /// The preferred row height.
  ///
  /// The widget will attempt to lay out its children such that the resulting
  /// row height is as close to this value as possible.
  double get preferredRowHeight => _preferredRowHeight;
  double _preferredRowHeight;
  set preferredRowHeight(double value) {
    if (_preferredRowHeight == value) {
      return;
    }
    _preferredRowHeight = value;
    markNeedsLayout();
  }

  /// The spacing between items in a row.
  double get horizontalSpacing => _horizontalSpacing;
  double _horizontalSpacing;
  set horizontalSpacing(double value) {
    if (_horizontalSpacing == value) {
      return;
    }
    _horizontalSpacing = value;
    markNeedsLayout();
  }

  /// The spacing between items in a row.
  double get verticalSpacing => _horizontalSpacing;
  double _verticalSpacing;
  set verticalSpacing(double value) {
    if (_verticalSpacing == value) {
      return;
    }
    _verticalSpacing = value;
    markNeedsLayout();
  }

  /// The maximum ratio to use when scaling.
  double get maxScaleRatio => _maxScaleRatio;
  double _maxScaleRatio;
  set maxScaleRatio(double value) {
    if (_maxScaleRatio == value) {
      return;
    }
    _maxScaleRatio = value;
    markNeedsLayout();
  }

  GalleryRenderObject({
    List<RenderBox>? children,
    required double preferredRowHeight,
    required double horizontalSpacing,
    required double verticalSpacing,
    required double maxScaleRatio,
  })  : _preferredRowHeight = preferredRowHeight,
        _horizontalSpacing = horizontalSpacing,
        _verticalSpacing = verticalSpacing,
        _maxScaleRatio = maxScaleRatio {
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
    double width = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childSize = child
          .getDryLayout(BoxConstraints.tightFor(height: preferredRowHeight));
      width = math.max(width, childSize.width);
      child = childAfter(child);
    }
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childSize = child
          .getDryLayout(BoxConstraints.tightFor(height: preferredRowHeight));
      width += childSize.width;
      child = childAfter(child);
    }
    return width;
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

  /// Calculate the finished layout.
  GalleryLayout _computeRows(BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth;
    RenderBox? child = firstChild;
    double totalWidth = 0.0;
    double previousRatio = double.infinity;
    double newRatio = double.infinity;
    List<RenderBox> children = [];
    List<GalleryRow> rows = [];

    while (child != null) {
      final spacingModifier = children.length * horizontalSpacing;
      final modifiedWidth = maxWidth - spacingModifier;
      final childSize = child
          .getDryLayout(BoxConstraints.tightFor(height: preferredRowHeight));
      totalWidth += childSize.width;
      if (totalWidth > modifiedWidth) {
        newRatio = modifiedWidth / totalWidth;
        double height = preferredRowHeight;
        if ((1.0 - previousRatio) > (newRatio - 1.0)) {
          // keep the new child
          children.add(child);
          child = childAfter(child);
          height *= newRatio;
        } else {
          height *= previousRatio;
        }
        rows.add(
          (
            children: children,
            height: height,
          ),
        );
        // reset
        totalWidth = 0.0;
        previousRatio = double.infinity;
        children = [];
      } else {
        children.add(child);
        child = childAfter(child);
        previousRatio = modifiedWidth / totalWidth;
      }
    }
    if (children.isNotEmpty) {
      // add the last row
      if (newRatio < maxScaleRatio) {
        // Scaling up the last row is not so egregious, so do it
        rows.add(
          (
            children: children,
            height: preferredRowHeight * newRatio,
          ),
        );
      } else {
        // Scaling up the last row makes it too big, default to left aligned
        rows.add((children: children, height: preferredRowHeight));
      }
    }
    return GalleryLayout(
      rows: rows,
      width: maxWidth,
      height: math.max(
        math.min(
            constraints.maxHeight,
            rows.isNotEmpty
                ? rows.fold(0.0, (height, row) => height + row.height) +
                    (rows.length - 1) * verticalSpacing
                : 0.0),
        constraints.minHeight,
      ),
    );
  }

  @override
  double? computeDryBaseline(
      covariant BoxConstraints constraints, TextBaseline baseline) {
    return null;
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
      for (var child in row.children) {
        final childWidth = child.getMaxIntrinsicWidth(row.height);
        child.layout(
            BoxConstraints(
              maxWidth: childWidth,
              maxHeight: row.height,
            ),
            parentUsesSize: true);
        (child.parentData! as GalleryParentData).offset = offset;
        offset = Offset(offset.dx + childWidth + horizontalSpacing, offset.dy);
      }
      offset = Offset(0.0, offset.dy + row.height + verticalSpacing);
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
}

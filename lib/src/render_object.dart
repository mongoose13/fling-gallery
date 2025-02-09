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

  /// The spacing between rows.
  double get verticalSpacing => _horizontalSpacing;
  double _verticalSpacing;
  set verticalSpacing(double value) {
    if (_verticalSpacing == value) {
      return;
    }
    _verticalSpacing = value;
    markNeedsLayout();
  }

  /// Whether the bottom row should be forced into a full row.
  bool get forceFill => _forceFill;
  bool _forceFill;
  set forceFill(bool value) {
    if (_forceFill == value) {
      return;
    }
    _forceFill = value;
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
    required bool forceFill,
  })  : _preferredRowHeight = preferredRowHeight,
        _horizontalSpacing = horizontalSpacing,
        _verticalSpacing = verticalSpacing,
        _maxScaleRatio = maxScaleRatio,
        _forceFill = forceFill {
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

  /*@override
  double? computeDryBaseline(
      covariant BoxConstraints constraints, TextBaseline baseline) {
    return null;
  }*/

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
      final rowHeight = row.ratio * preferredRowHeight;
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
        offset = Offset(offset.dx + slotWidth + horizontalSpacing, offset.dy);
      }
      offset = Offset(0.0, offset.dy + rowHeight + verticalSpacing);
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

  /// Returns an iterator over the sizes of all children, in order.
  Iterable<Size> _childSizes() sync* {
    RenderBox? child = firstChild;
    while (child != null) {
      final childSize = child
          .getDryLayout(BoxConstraints.tightFor(height: preferredRowHeight));
      yield childSize;
      child = childAfter(child);
    }
  }

  /// Calculates the finished layout given parent constraints.
  GalleryLayout _computeRows(BoxConstraints constraints) {
    final preferredConstraints =
        BoxConstraints.tightFor(height: preferredRowHeight);
    final maxRowWidth = constraints.maxWidth;
    RenderBox? child = firstChild;
    double currentRowWidth = 0.0;
    double ratioWithoutLatestChild = double.infinity;
    double ratioWithLatestChild = double.infinity;
    List<GallerySlot> slots = [];
    List<GalleryRow> rows = [];

    while (child != null) {
      // The amount of space taken up by the spacing between items
      final rowWidthSpacingModifier = slots.length * horizontalSpacing;
      // The amount of space on the row that is useful for laying out children
      final adjustedMaxRowWidth = maxRowWidth - rowWidthSpacingModifier;
      // The current child's width, adjusted for the row's height constraints
      final adjustedChildWidth = child.getDryLayout(preferredConstraints).width;

      currentRowWidth += adjustedChildWidth;
      ratioWithLatestChild = adjustedMaxRowWidth / currentRowWidth;
      if (currentRowWidth > adjustedMaxRowWidth) {
        final deviationWithLatestChild = (ratioWithLatestChild - 1.0).abs();
        final deviationWithoutLatestChild =
            (ratioWithoutLatestChild - 1.0).abs();
        double ratio;
        if (deviationWithoutLatestChild > deviationWithLatestChild) {
          ratio = ratioWithLatestChild;
          // keep the new child
          slots.add((child: child, width: adjustedChildWidth));
          child = childAfter(child);
        } else {
          ratio = ratioWithoutLatestChild;
        }
        rows.add(
          (
            slots: slots,
            ratio: ratio,
          ),
        );
        // reset
        currentRowWidth = 0.0;
        ratioWithoutLatestChild = double.infinity;
        slots = [];
      } else {
        slots.add((child: child, width: adjustedChildWidth));
        child = childAfter(child);
        ratioWithoutLatestChild = adjustedMaxRowWidth / currentRowWidth;
      }
    }
    if (slots.isNotEmpty) {
      // add the last row
      if (forceFill || ratioWithLatestChild < maxScaleRatio) {
        // Scaling up the last row is not so egregious, so do it
        rows.add(
          (
            slots: slots,
            ratio: ratioWithLatestChild,
          ),
        );
      } else {
        // Scaling up the last row makes it too big, so default to left aligned
        rows.add((
          slots: slots,
          ratio: 1.0,
        ));
      }
    }
    final totalHeight = math.min(
        constraints.maxHeight,
        rows.isNotEmpty
            ? rows.fold(0.0,
                    (height, row) => height + row.ratio * preferredRowHeight) +
                (rows.length - 1) * verticalSpacing
            : 0.0);
    return GalleryLayout(
      rows: rows,
      width: maxRowWidth.isNaN ? double.infinity : maxRowWidth,
      height: totalHeight.isFinite ? totalHeight : 0.0,
    );
  }
}

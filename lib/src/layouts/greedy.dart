import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../layout.dart';
import '../render_object.dart';

class GreedyLayout extends GalleryLayoutStrategy {
  final int? maxRowItems;
  final double maxScaleRatio;
  final bool forceFill;

  GreedyLayout({
    required super.preferredRowHeight,
    this.maxRowItems,
    this.maxScaleRatio = 2.0,
    this.forceFill = false,
    super.verticalSpacing = 4.0,
    super.horizontalSpacing = 4.0,
  });

  /// Calculates the finished layout given parent constraints.
  @override
  GalleryLayout build(
      GalleryRenderObject renderer, BoxConstraints constraints) {
    final preferredConstraints =
        BoxConstraints.tightFor(height: preferredRowHeight);
    final maxRowWidth =
        constraints.maxWidth.isNaN ? double.infinity : constraints.maxWidth;
    double totalWidth = 0.0;
    double currentRowWidth = 0.0;
    double ratioWithoutLatestChild = double.infinity;
    double ratioWithLatestChild = double.infinity;
    List<GallerySlot> slots = [];
    List<GalleryRow> rows = [];

    RenderBox? child = renderer.firstChild;
    while (child != null) {
      // The amount of space taken up by the spacing between items
      final rowWidthSpacingModifier = slots.length * horizontalSpacing;
      // The amount of space on the row that is useful for laying out children
      final adjustedMaxRowWidth = maxRowWidth - rowWidthSpacingModifier;
      // The current child's width, adjusted for the row's height constraints
      final adjustedChildWidth = child.getDryLayout(preferredConstraints).width;

      currentRowWidth += adjustedChildWidth;
      ratioWithLatestChild = adjustedMaxRowWidth / currentRowWidth;
      if (maxRowItems != null && maxRowItems! <= slots.length) {
        rows.add(
          (
            slots: slots,
            ratio: ratioWithoutLatestChild,
          ),
        );
        // reset
        totalWidth = math.max(totalWidth, maxRowWidth);
        currentRowWidth = 0.0;
        ratioWithoutLatestChild = double.infinity;
        slots = [];
      } else if (currentRowWidth > adjustedMaxRowWidth) {
        final deviationWithLatestChild = (ratioWithLatestChild - 1.0).abs();
        final deviationWithoutLatestChild =
            (ratioWithoutLatestChild - 1.0).abs();
        double ratio;
        if (deviationWithoutLatestChild > deviationWithLatestChild) {
          ratio = ratioWithLatestChild;
          // keep the new child
          slots.add((child: child, width: adjustedChildWidth));
          child = renderer.childAfter(child);
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
        totalWidth = math.max(totalWidth, maxRowWidth);
        currentRowWidth = 0.0;
        ratioWithoutLatestChild = double.infinity;
        slots = [];
      } else {
        slots.add((child: child, width: adjustedChildWidth));
        child = renderer.childAfter(child);
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
        totalWidth = math.max(totalWidth, maxRowWidth);
      } else {
        // Scaling up the last row makes it too big, so default to left aligned
        final itemsWidth = math.max(totalWidth,
            slots.fold(0.0, (accumulator, item) => accumulator + item.width));
        totalWidth = math.max(itemsWidth, constraints.minWidth);
        rows.add((
          slots: slots,
          ratio: totalWidth / itemsWidth,
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
      width: totalWidth,
      height: totalHeight.isFinite ? totalHeight : 0.0,
    );
  }
}

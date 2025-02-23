import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../layout.dart';
import '../render_object.dart';

/// A layout strategy that fills rows with as many children as possible within
/// some constraints, without concern for how that may affect future rows.
///
/// While this strategy may not give optimal results, it will likely be a bit
/// faster than other algorithms.
///
/// Each complete row will not deviate more than [maxScaleRatio] from the
/// preferred row height. If the last row can not meet this requirement, it
/// will remain incomplete (it won't take up the entire width). This behavior
/// can be overridden by setting [forceFill] to `true`.
class GreedyGalleryLayout extends GalleryLayoutStrategy {
  /// The maximum number of items per row.
  final int? maxRowItems;

  /// The maximum allowed auto scale ratio.
  final double maxScaleRatio;
  final bool forceFill;

  /// Constructor.
  GreedyGalleryLayout({
    required super.preferredRowHeight,
    this.maxRowItems,
    this.maxScaleRatio = 2.0,
    this.forceFill = false,
    super.verticalSpacing = 4.0,
    super.horizontalSpacing = 4.0,
  });

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
            ratio:
                ratioWithoutLatestChild.isFinite ? ratioWithLatestChild : 1.0,
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
            ratio: ratioWithLatestChild.isFinite ? ratioWithLatestChild : 1.0,
          ),
        );
        totalWidth = math.max(totalWidth, maxRowWidth);
      } else {
        // Scaling up the last row makes it too big, so default to left aligned
        final itemsWidth = math.max(totalWidth,
            slots.fold(0.0, (accumulator, item) => accumulator + item.width));
        totalWidth = math.max(itemsWidth, constraints.minWidth);
        final ratio = totalWidth / itemsWidth;
        rows.add((
          slots: slots,
          ratio: ratio.isFinite ? ratio : 1.0,
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

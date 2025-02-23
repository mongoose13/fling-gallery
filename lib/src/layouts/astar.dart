import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../layout.dart';
import '../render_object.dart';

/// A layout strategy that attempts to optimize item fit across all rows using
/// a variety of the A* algorithm.
///
/// See [Wikipedia](https://en.wikipedia.org/wiki/A*_search_algorithm) for an
/// introduction to A*.
///
/// This strategy relies on a minimum and maximum ratio. This ratio refers to
/// how far from the preferred row height an item is allowed to be.
///
/// Any row whose children all fit within the bounds of the ratios is considered
/// good, regardless of how far away from the preferred row height the result
/// actually is. Solutions with rows that deviate from the range are penalized
/// based on how far from the preferred row height each row is.
class AStarGalleryLayout extends GalleryLayoutStrategy {
  final double minRatio;
  final double maxRatio;
  final bool forceFill;
  final BoxConstraints preferredConstraints;

  /// [forceFill] allows the ratio constraints to be ignored in cases where the
  /// row cannot meet the ratio constraints and still take the entire width the
  /// widget has been allocated.
  AStarGalleryLayout({
    required super.preferredRowHeight,
    required this.minRatio,
    required this.maxRatio,
    this.forceFill = true,
    super.horizontalSpacing = 4.0,
    super.verticalSpacing = 4.0,
  }) : preferredConstraints = BoxConstraints(maxHeight: preferredRowHeight) {
    assert(minRatio <= maxRatio, "minRatio must be <= maxRatio");
    assert(minRatio > 0.0, "minRatio must be > 0.0");
  }

  @override
  GalleryLayout build(
    GalleryRenderObject renderer,
    BoxConstraints constraints,
  ) {
    final totalChildWidth =
        renderer.computeMaxIntrinsicWidth(preferredRowHeight);

    // shortcut
    if (constraints.maxWidth > maxRatio * totalChildWidth) {
      return _singleRowLayout(
        renderer: renderer,
        constraints: constraints,
        totalChildWidth: totalChildWidth,
      );
    }

    final options = <_AStarOption>[];
    options.add(
      _AStarOption(
        layout: this,
        constraints: constraints,
        rows: const <GalleryRow>[],
        currentChild: renderer.firstChild,
        remainingWidth: totalChildWidth,
        score: 0.0,
      ),
    );

    while (options.isNotEmpty) {
      options.sort();
      final option = options.removeAt(0);
      if (option.isComplete) {
        return option.build();
      }

      var currentChild = option.currentChild;
      var remainingWidth = option.remainingWidth;
      var currentRowWidth = 0.0;
      var currentRowPadding = 0.0;
      var ratio = maxRatio;
      final slots = <GallerySlot>[];
      while (currentChild != null && ratio >= minRatio) {
        // calculate effects of one more child in this row
        final currentChildPreferredWidth =
            currentChild.getDryLayout(preferredConstraints).width;
        if (slots.isNotEmpty) {
          currentRowPadding += horizontalSpacing;
        }
        remainingWidth -= currentChildPreferredWidth;
        currentRowWidth += currentChildPreferredWidth;
        ratio = (constraints.maxWidth - currentRowPadding) / currentRowWidth;

        // we can (or must) accept this child
        if (slots.isEmpty || ratio >= minRatio) {
          slots.add((child: currentChild, width: currentChildPreferredWidth));
          currentChild = renderer.childAfter(currentChild);
        }

        // determine of the row is complete
        if (ratio <= maxRatio && ratio >= minRatio) {
          // this row is within bounds: accept it
          options.add(
            _AStarOption(
              layout: this,
              constraints: constraints,
              rows: option.rows.followedBy(
                  [(slots: slots, ratio: ratio)]).toList(growable: false),
              currentChild: currentChild,
              remainingWidth: remainingWidth,
              score: currentChild == null
                  ? 0.0
                  : constraints.maxWidth /
                      (remainingWidth % constraints.maxWidth),
            ),
          );
        } else if (currentChild == null ||
            (slots.length == 1 && ratio < minRatio)) {
          // we must accept this row:
          // it either has only one item, or there are no more children
          options.add(
            _AStarOption(
              layout: this,
              constraints: constraints,
              rows: option.rows.followedBy([
                (slots: slots, ratio: forceFill ? ratio : maxRatio)
              ]).toList(growable: false),
              currentChild: currentChild,
              remainingWidth: remainingWidth,
              score: constraints.maxWidth - currentRowWidth,
            ),
          );
        }
      }
    }

    assert(options.isNotEmpty,
        "Did not find a working solution: please file a bug report");
    return _singleRowLayout(
      renderer: renderer,
      constraints: constraints,
      totalChildWidth: totalChildWidth,
    );
  }

  /// Create a layout that just puts everything on a single row.
  ///
  /// Useful if you don't need more than one row, or if you otherwise don't know
  /// what to do.
  GalleryLayout _singleRowLayout({
    required GalleryRenderObject renderer,
    required BoxConstraints constraints,
    required double totalChildWidth,
  }) {
    final ratio = forceFill
        ? (constraints.maxWidth -
                (renderer.childCount - 1) * horizontalSpacing) /
            totalChildWidth
        : maxRatio;
    return _AStarOption(
      layout: this,
      constraints: constraints,
      rows: renderer.childCount > 0
          ? <GalleryRow>[
              (
                slots: renderer.children
                    .map<GallerySlot>(
                      (child) => (
                        child: child,
                        width: child.getDryLayout(preferredConstraints).width,
                      ),
                    )
                    .toList(growable: false),
                ratio: ratio.isFinite ? ratio : maxRatio,
              ),
            ]
          : const [],
      currentChild: null,
      remainingWidth: 0.0,
      score: 0.0,
    ).build();
  }
}

class _AStarOption implements Comparable<_AStarOption> {
  final AStarGalleryLayout layout;
  final BoxConstraints constraints;
  final List<GalleryRow> rows;
  final RenderBox? currentChild;
  final double remainingWidth;
  final double score;

  const _AStarOption({
    required this.layout,
    required this.constraints,
    required this.rows,
    required this.currentChild,
    required this.remainingWidth,
    required this.score,
  });

  bool get isComplete => currentChild == null;

  GalleryLayout build() {
    return GalleryLayout(
      rows: rows,
      width: rows.isEmpty
          ? constraints.minWidth
          : !layout.forceFill && rows.length == 1
              ? math.max(
                  rows.first.slots.fold(
                    -layout.horizontalSpacing,
                    (accumulator, slot) =>
                        accumulator +
                        slot.width * rows.first.ratio +
                        layout.horizontalSpacing,
                  ),
                  0.0,
                )
              : constraints.maxWidth,
      height: math.max(
        math.min(
          rows.fold(
            math.max(rows.length - 1, 0) * layout.verticalSpacing,
            (accumulator, row) =>
                accumulator + row.ratio * layout.preferredRowHeight,
          ),
          constraints.maxHeight,
        ),
        constraints.minHeight,
      ),
    );
  }

  @override
  int compareTo(_AStarOption other) {
    return score.compareTo(other.score);
  }
}

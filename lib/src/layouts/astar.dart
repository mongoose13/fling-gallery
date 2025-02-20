import 'dart:math' as math;

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
  final BoxConstraints preferredConstraints;

  /// Constructor.
  AStarGalleryLayout({
    required super.preferredRowHeight,
    required this.minRatio,
    required this.maxRatio,
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
    if (constraints.maxWidth * minRatio > totalChildWidth) {
      return _singleRowLayout(renderer, constraints, totalChildWidth);
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
        final currentChildPreferredWidth =
            currentChild.getDryLayout(preferredConstraints).width;
        if (slots.isNotEmpty) {
          currentRowPadding += horizontalSpacing;
        }
        slots.add((child: currentChild, width: currentChildPreferredWidth));
        remainingWidth -= currentChildPreferredWidth;
        currentRowWidth += currentChildPreferredWidth;
        ratio = (constraints.maxWidth - currentRowPadding) / currentRowWidth;

        currentChild = renderer.childAfter(currentChild);
        if (ratio <= maxRatio) {
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
        } else if (currentChild == null) {
          options.add(
            _AStarOption(
              layout: this,
              constraints: constraints,
              rows: option.rows.followedBy(
                  [(slots: slots, ratio: ratio)]).toList(growable: false),
              currentChild: currentChild,
              remainingWidth: remainingWidth,
              score: constraints.maxWidth - currentRowWidth,
            ),
          );
        }
      }
    }

    assert(false, "Did not find a working solution: please file a bug report");
    return _singleRowLayout(renderer, constraints, totalChildWidth);
  }

  /// Create a layout that just puts everything on a single row.
  ///
  /// Useful if you don't need more than one row, or if you otherwise don't know
  /// what to do.
  GalleryLayout _singleRowLayout(
    GalleryRenderObject renderer,
    BoxConstraints constraints,
    double totalChildWidth,
  ) {
    return _AStarOption(
      layout: this,
      constraints: constraints,
      rows: <GalleryRow>[
        (
          slots: renderer.children
              .map<GallerySlot>(
                (child) => (
                  child: child,
                  width: child.getDryLayout(preferredConstraints).width,
                ),
              )
              .toList(growable: false),
          ratio: math.max(
            math.min(
              constraints.maxWidth /
                  (totalChildWidth +
                      (renderer.childCount > 1
                          ? (renderer.childCount - 1) * horizontalSpacing
                          : 0)),
              maxRatio,
            ),
            minRatio,
          ),
        ),
      ],
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

  _AStarOption({
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
      width: constraints.maxWidth,
      height: math.max(
        math.min(
          rows.fold(
            -layout.verticalSpacing,
            (accumulator, row) =>
                accumulator +
                row.ratio * layout.preferredRowHeight +
                layout.verticalSpacing,
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

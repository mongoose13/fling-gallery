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

  /// Constructor.
  AStarGalleryLayout({
    required super.preferredRowHeight,
    required this.minRatio,
    required this.maxRatio,
    super.horizontalSpacing = 4.0,
    super.verticalSpacing = 4.0,
  });

  @override
  GalleryLayout build(
      GalleryRenderObject renderer, BoxConstraints constraints) {
    final preferredConstraints = BoxConstraints(maxHeight: preferredRowHeight);
    final totalChildWidth =
        renderer.computeMaxIntrinsicWidth(preferredRowHeight);

    // shortcut
    if (constraints.maxWidth > totalChildWidth) {
      return GalleryLayout(
        rows: <GalleryRow>[
          (
            ratio: 1.0,
            slots: renderer.children
                .map<GallerySlot>(
                  (child) => (
                    child: child,
                    width: child.getDryLayout(preferredConstraints).width,
                  ),
                )
                .toList(growable: false)
          )
        ],
        width: totalChildWidth,
        height: preferredRowHeight,
      );
    }

    final options = <_AStarOption>[];
    options.add(
      _AStarOption(
        rows: const [],
        currentChild: renderer.firstChild,
        remainingWidth: totalChildWidth,
        score: 0.0,
      ),
    );

    while (options.isNotEmpty) {
      options.sort();
      final option = options.removeAt(0);
      if (option.isComplete) {
        return option.build(
          preferredRowHeight: preferredRowHeight,
          constrainedWidth: constraints.maxWidth,
        );
      }

      var currentChild = option.currentChild;
      var remainingWidth = option.remainingWidth;
      var currentRowWidth = 0.0;
      var ratio = maxRatio;
      final slots = <GallerySlot>[];
      while (currentChild != null && ratio >= minRatio) {
        final currentChildPreferredWidth =
            currentChild.getDryLayout(preferredConstraints).width;
        slots.add((child: currentChild, width: currentChildPreferredWidth));
        remainingWidth -= currentChildPreferredWidth;
        currentRowWidth += currentChildPreferredWidth;
        ratio = constraints.maxWidth / currentRowWidth;

        currentChild = renderer.childAfter(currentChild);
        if (ratio <= maxRatio) {
          options.add(
            _AStarOption(
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
    return const GalleryLayout();
  }
}

class _AStarOption implements Comparable<_AStarOption> {
  final List<GalleryRow> rows;
  final RenderBox? currentChild;
  final double remainingWidth;
  final double score;

  _AStarOption({
    required this.rows,
    required this.currentChild,
    required this.remainingWidth,
    required this.score,
  });

  bool get isComplete => currentChild == null;

  GalleryLayout build({
    required double constrainedWidth,
    required double preferredRowHeight,
  }) {
    return GalleryLayout(
      rows: rows,
      width: constrainedWidth,
      height: rows.fold(
        0.0,
        (accumulator, row) => accumulator + row.ratio * preferredRowHeight,
      ),
    );
  }

  @override
  int compareTo(_AStarOption other) {
    return score.compareTo(other.score);
  }
}

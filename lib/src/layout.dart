import 'package:fling_gallery/src/render_object.dart';
import 'package:flutter/rendering.dart';

/// Represents the space taken up by a single item in the gallery.
typedef GallerySlot = ({RenderBox child, double width});

/// Represents a row in the finished layout.
///
/// This stores all the children that belong in the row, as well as the row's
/// calculated height.
typedef GalleryRow = ({
  List<GallerySlot> slots,
  double ratio,
});

/// Represents the finished layout.
class GalleryLayout {
  final double width;
  final double height;
  final List<GalleryRow> rows;

  const GalleryLayout({
    this.rows = const [],
    this.width = 0.0,
    this.height = 0.0,
  });

  Size get size => Size(width, height);
}

/// Base class for gallery layout strategies.
abstract class GalleryLayoutStrategy {
  final double preferredRowHeight;
  final double verticalSpacing;
  final double horizontalSpacing;

  /// Constructor.
  GalleryLayoutStrategy({
    required this.preferredRowHeight,
    required this.verticalSpacing,
    required this.horizontalSpacing,
  });

  /// Calculates the finished layout given parent constraints.
  GalleryLayout build(GalleryRenderObject renderer, BoxConstraints constraints);
}

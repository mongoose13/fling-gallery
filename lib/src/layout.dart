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

  GalleryLayout({
    this.rows = const [],
    this.width = 0.0,
    this.height = 0.0,
  });

  Size get size => Size(width, height);
}

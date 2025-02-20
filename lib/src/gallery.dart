import 'package:fling_gallery/src/layout.dart';
import 'package:fling_gallery/src/render_object.dart';
import 'package:flutter/widgets.dart';

/// A widget that lays out its children into tight rows.
class Gallery extends MultiChildRenderObjectWidget {
  final GalleryLayoutStrategy layoutStrategy;

  /// A widget that lays out its children into tight rows.
  ///
  /// The exact behavior will vary depending on the layout strategy provided.
  const Gallery({
    super.key,
    required this.layoutStrategy,
    super.children = const [],
  });

  @override
  RenderObject createRenderObject(BuildContext context) => GalleryRenderObject(
        layoutStrategy: layoutStrategy,
      );
}

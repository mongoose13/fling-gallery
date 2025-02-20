import 'package:fling_gallery/src/layout.dart';
import 'package:fling_gallery/src/render_object.dart';
import 'package:flutter/widgets.dart';

class Gallery extends MultiChildRenderObjectWidget {
  final GalleryLayoutStrategy layoutStrategy;

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

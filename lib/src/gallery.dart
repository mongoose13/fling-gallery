import 'package:fling_gallery/src/render_object.dart';
import 'package:flutter/widgets.dart';

class Gallery extends MultiChildRenderObjectWidget {
  final double preferredRowHeight;
  final double horizontalSpacing;
  final double verticalSpacing;
  final double maxScaleRatio;
  final bool forceFill;

  const Gallery({
    super.key,
    required this.preferredRowHeight,
    this.horizontalSpacing = 4.0,
    this.verticalSpacing = 4.0,
    this.maxScaleRatio = 2.0,
    this.forceFill = false,
    super.children = const [],
  });

  @override
  RenderObject createRenderObject(BuildContext context) => GalleryRenderObject(
        preferredRowHeight: preferredRowHeight,
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing,
        maxScaleRatio: maxScaleRatio,
        forceFill: forceFill,
      );
}

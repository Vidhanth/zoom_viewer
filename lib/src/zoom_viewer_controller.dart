import 'package:flutter/material.dart';

class ZoomController {
  late Function resetZoom;
  bool isZoomed = false;
  late TransformationController? Function() getTransformationController;

  ZoomController({resetZoom, getTransformationController}) {
    this.resetZoom = resetZoom ?? () {};
    this.getTransformationController = getTransformationController ?? () {};
  }
}

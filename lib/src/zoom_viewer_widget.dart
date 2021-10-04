import 'package:flutter/material.dart';
import 'package:zoom_viewer/src/zoom_viewer_controller.dart';

class ZoomViewer extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;
  final Function? onPressed;
  final Function(ScaleStartDetails)? onZoomStart;
  final Function(ScaleUpdateDetails)? onZoomUpdate;
  final Function(ScaleEndDetails)? onZoomEnd;
  final ZoomController? controller;

  const ZoomViewer({
    Key? key,
    required this.child,
    this.scale = 3.0,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.fastOutSlowIn,
    this.controller,
    this.onPressed,
    this.onZoomStart,
    this.onZoomUpdate,
    this.onZoomEnd,
  }) : super(key: key);

  @override
  State<ZoomViewer> createState() => _ZoomViewerState();
}

class _ZoomViewerState extends State<ZoomViewer>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;

  Offset? _position;

  Matrix4 end = Matrix4.identity();

  @override
  void initState() {
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animationController.addListener(() {
      _transformationController.value = _animation.value;
    });
    widget.controller?.resetZoom = zoomOut;
    widget.controller?.getTransformationController = () {
      return _transformationController;
    };
    super.initState();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _position = details.localPosition;
      },
      onDoubleTap: () {
        if (_transformationController.value.isIdentity()) {
          zoomIn();
        } else {
          zoomOut();
        }
      },
      onTap: () {
        widget.onPressed?.call();
      },
      child: InteractiveViewer(
        onInteractionStart: (details) {
          widget.onZoomStart?.call(details);
        },
        onInteractionUpdate: (details) {
          widget.controller?.isZoomed =
              !_transformationController.value.isIdentity();
          widget.onZoomUpdate?.call(details);
        },
        onInteractionEnd: (details) {
          widget.onZoomEnd?.call(details);
        },
        maxScale: widget.scale,
        transformationController: _transformationController,
        clipBehavior: Clip.none,
        child: widget.child,
      ),
    );
  }

  void zoomIn() {
    final double x = -_position!.dx * (widget.scale - 1);
    final double y = -_position!.dy * (widget.scale - 1);
    final zoom = Matrix4.identity()
      ..translate(x, y)
      ..scale(widget.scale);
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: zoom,
    ).animate(
      CurveTween(
        curve: widget.curve,
      ).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }

  void zoomOut() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
      CurveTween(
        curve: widget.curve,
      ).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }
}

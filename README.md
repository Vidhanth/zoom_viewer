<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## zoom_viewer

Widget to make any widget zoomable using mouse/touch. Provides callbacks like onZoomStart, onZoomUpdate and onZoomEnd along with a controller to control zoom externally.

## Getting started

Add this to your pubspec.yaml:

```
zoom_viewer:
  git:
    url: git://github.com/Vidhanth/zoom_viewer.git
    ref: master
```

## Usage

```dart

ZoomViewer(
    onZoomStart: (ScrollStartDetails details) {
      print(details);
    },
    controller: zoomController, //instance of ZoomController
    scale: 5.0, //maximum scale to zoom to
    onPressed: () {
      print('Widget was tapped');
    },
    curve: Curves.fastOutSlowIn, //curve of zoom animation on double tap
    duration: Duration(milliseconds: 300), //duration of zoom animation on double tap
    child: Image.network(
      src,
      fit: BoxFit.cover,
    ),
)


```
# Flutter Assets Cache

This Dart package provides a convenient way to cache images and SVG assets in Flutter applications, supporting both local and network sources. It utilizes a custom cache manager to efficiently manage asset caching, reducing load times and improving app performance.

## Features

- Caching of network images with a custom cache manager.
- Support for both SVG and traditional image formats.
- Placeholder widget display while images are loading.
- Performance metrics logging for cache hits and misses.
- Easy integration with existing Flutter projects.

## Getting Started

To use this package in your project, follow these steps:

1. **Add the dependency**: Include `flutter_assets_cache` in your `pubspec.yaml` file.

    ```yaml
    dependencies:
      flutter_assets_cache: latest_version
    ```

2. **Import the package**: Add the following import to your Dart file.

    ```dart
    import 'package:flutter_assets_cache/flutter_assets_cache.dart';
    ```

3. **Use the `getImageWidget` function**: Replace your image loading logic with calls to `getImageWidget`, specifying the image URL and any optional parameters like height, width, and fit.

    ```dart
    Widget myImageWidget = getImageWidget(
      'https://example.com/myimage.png',
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    );
    ```

## Example Usage

Below is an example of how to use the `getImageWidget` function to load an image from a network source with caching:

```dart
class MyImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getImageWidget(
        'https://example.com/image.svg',
        height: 200,
        width: 200,
        fit: BoxFit.fill,
      ),
    );
  }
}
library flutter_assets_cache;

import 'package:flutter/material.dart';
import 'package:flutter_assets_cache/twid_custom_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';





Widget getImageWidget(String imageUrl, {double? height, double? width, Color? color, BoxFit? fit,String? cacheDir,}) {

  // Check if the URL is pointing to a local asset
  final bool isLocalAsset = imageUrl.startsWith('assets/');

  if (isLocalAsset) {
    // Handle local SVG assets
    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        imageUrl,
        height: height,
        width: width,
        color: color, // Update this as per your package name if needed
      );
    } else {
      // Handle other local image assets
      return Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: fit, // Update this as per your package name if needed
      );
    }
  } else {


    // For network images, use the existing caching logic
    final cacheManager = CustomCacheManager(cacheDirName: cacheDir??'assets_cache');
    // Initialize start time
    final startTime = DateTime.now();

    return FutureBuilder<Map<String, dynamic>>(
      future: cacheManager.getImage(imageUrl), // This is your async operation
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a placeholder widget while waiting for the operation to complete
          return Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey.withOpacity(0.1),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        } else {
          if (snapshot.hasError) {
            // Handle any errors
            return const Icon(Icons.error);
          } else {
            final endTime = DateTime.now();
            final timeSaved = endTime.difference(startTime);
            final wasCached = snapshot.data!['isCached'] as bool;

            // Display toast message based on whether the image was cached
            debugPrint("Image Downloaded by using ${wasCached ? 'cache' : 'download'}: in ${timeSaved.inMilliseconds} milliseconds ");

            // Once the data is available, check the image type and return the appropriate widget
            if (imageUrl.toLowerCase().endsWith('.svg')) {
              return SvgPicture.file(
                snapshot.data!['file'],
                height: height,
                width: width,
                color: color,
              );
            } else {
              return Image.file(
                snapshot.data!['file'],
                height: height,
                width: width,
                fit: fit,
              );
            }
          }
        }
      },
    );
  }
}

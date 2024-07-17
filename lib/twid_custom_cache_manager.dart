import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CustomCacheManager {
  static CustomCacheManager? _instance;
  final String cacheDirName;

  factory CustomCacheManager({required String cacheDirName}) {
    if (_instance == null || _instance!.cacheDirName != cacheDirName) {
      _instance = CustomCacheManager._internal(cacheDirName);
    }
    return _instance!;
  }

  CustomCacheManager._internal(this.cacheDirName);

  Future<void> clearCache() async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${directory.path}/$cacheDirName');
    if (cacheDir.existsSync()) {
      cacheDir.listSync().forEach((file) {
        file.deleteSync();
      });
    }
  }

  Future<bool> isCacheCleared() async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${directory.path}/$cacheDirName');
    await clearCache();
    if (cacheDir.existsSync()) {
      List<FileSystemEntity> files = cacheDir.listSync();
      return files.isEmpty; // Return true if the cache directory is empty
    }
    return false; // Return false if the cache directory does not exist or is not empty
  }

  Future<String> get _cacheDir async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${directory.path}/$cacheDirName');
    if (!cacheDir.existsSync()) {
      cacheDir.createSync();
    }
    return cacheDir.path;
  }

  Future<File> _getFile(String url) async {
    final cacheDir = await _cacheDir;
    final fileName = path.basename(url);
    return File('$cacheDir/$fileName');
  }

  Future<bool> isCached(String url) async {
    final file = await _getFile(url);
    return file.exists();
  }

  Future<File> cacheImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final file = await _getFile(url);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<Map<String, dynamic>> getImage(String url) async {
    bool _isCached = await isCached(url);
    File file;
    if (_isCached) {
      file = await _getFile(url);
    } else {
      file = await cacheImage(url);
    }
    return {'file': file, 'isCached': isCached};
  }
}
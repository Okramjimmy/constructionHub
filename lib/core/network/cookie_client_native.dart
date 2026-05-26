// Native implementation (dart:io — Android, iOS, Desktop).
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Wires a [PersistCookieJar] into [dio] using the device filesystem.
/// Session cookies survive app restarts so users stay logged in.
Future<void> attachCookieJar(Dio dio, Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final jar = PersistCookieJar(
    storage: FileStorage('${dir.path}/.cookies/'),
  );
  dio.interceptors.add(CookieManager(jar));
}

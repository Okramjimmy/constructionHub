// Web implementation (dart:html — Chrome, Firefox, Safari).
// The browser manages cookies automatically when withCredentials is true.
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// No-op on web: browsers send session cookies automatically via
/// the `withCredentials: true` flag set in BaseOptions.extra.
Future<void> attachCookieJar(Dio dio, Ref ref) async {}

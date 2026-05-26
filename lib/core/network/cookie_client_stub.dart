// Default stub — satisfies the analyzer when neither dart:io nor dart:html
// is available (e.g., during static analysis of the common code).
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> attachCookieJar(Dio dio, Ref ref) async {}

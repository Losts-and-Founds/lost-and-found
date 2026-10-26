import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../secure_storage/secure_storage.dart';

class HttpInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  HttpInterceptor(this._storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final language = await _storage.read(key: LOCALE);
    if (language != null && language.isNotEmpty) {
      options.headers['Accept-Language'] = language;
    }

    // Firebase Auth now owns authentication state; the legacy custom backend token
    // refresh flow is intentionally removed.
    return handler.next(options);
  }
}

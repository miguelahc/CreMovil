import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoiYWx2YXJvcG9sbyIsImEiOiJja3dqdHp4cncxbHZlMnZxcWp4Zno2cjJtIn0.xhggLqxuD5DTMW4JBPt7Lw';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters
        .addAll({'access_token': accessToken, 'language': 'es', 'limit': 7});

    super.onRequest(options, handler);
  }
}

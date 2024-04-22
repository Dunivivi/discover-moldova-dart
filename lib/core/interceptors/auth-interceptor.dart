import 'package:dio/dio.dart';
import 'package:discounttour/api/account.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  String token;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    token = await Account().token();

    String clearToken = token.replaceAll("?token=", "");

    options.headers.addAll({'Authorization': 'Bearer $clearToken'});

    print(options.headers);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }
}

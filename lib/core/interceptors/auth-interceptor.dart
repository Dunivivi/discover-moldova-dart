import 'package:discounttour/api/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class AuthInterceptor implements InterceptorContract {
  String token;

  @override
  Future<RequestData> interceptRequest({@required RequestData data}) async {
    token = await Account().token();

    print(77777777);

    data.headers.addAll({'Authorization': 'Bearer $token'});
    print(data);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}

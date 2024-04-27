import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:discounttour/api/api.dart';
import 'package:discounttour/core/interceptors/auth-interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Account {
  token() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '$token';
  }

  login(data) async {
    var fullUrl = '${Api.resourceUrl()}/api/authenticate';

    http.Response response = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  registerUser(data) async {
    var fullUrl = '${Api.resourceUrl()}/api/register/user';

    http.Response response = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  registerCompany(data) async {
    var fullUrl = '${Api.resourceUrl()}/api/register/user-company';

    http.Response response = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
  }

  fetchAccount() async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/account';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      final response = await dio.get(fullUrl);
      return response;
    } catch (error) {
      print('eeerrrr' + error);
    }
  }
}

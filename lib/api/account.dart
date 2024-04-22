import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:discounttour/core/interceptors/auth-interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Account {
  token() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  login(data) async {
    var fullUrl = 'http://localhost:8080/api/authenticate';

    http.Response response = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  account() async {
    var dio = Dio();
    var fullUrl = 'http://localhost:8080/api/account';
    // dio.options.baseUrl = fullUrl;

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      final response = await dio.get(fullUrl);

      print(response);
      return response;
    } catch (error) {
      print('eeerrrr' + error);
    }
  }
}

import 'package:discounttour/core/interceptors/auth-interceptor.dart';
import 'package:discounttour/views/auth/auth.dart';
import 'package:discounttour/views/auth/register.dart';
import 'package:discounttour/views/auth/welcome.dart';
import 'package:discounttour/views/home.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

void main() {
  runApp(MyApp());
  final http.Client client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiscountTour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
      routes: {
        Home.routeName: (context) => Home(),
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        AuthScreen.routeName: (context) => AuthScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
      },
    );
  }
}

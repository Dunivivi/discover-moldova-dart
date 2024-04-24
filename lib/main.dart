import 'package:dio/dio.dart';
import 'package:discounttour/views/auth/auth.dart';
import 'package:discounttour/views/auth/register.dart';
import 'package:discounttour/views/auth/welcome.dart';
import 'package:discounttour/views/events/events.dart';
import 'package:discounttour/views/favorites.dart';
import 'package:discounttour/views/home.dart';
import 'package:discounttour/views/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  final dio = Dio();
  dio.interceptors.add(LogInterceptor());
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
        ProfileScreen.routeName: (context) => ProfileScreen(),
        FavoritesScreen.routeName: (context) => FavoritesScreen(),
        EventsScreen.routeName: (context) => EventsScreen(),
      },
    );
  }
}

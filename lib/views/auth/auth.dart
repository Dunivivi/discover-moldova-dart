import 'dart:convert';

import 'package:discounttour/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/account.dart';
import '../../components/components.dart';
import '../../constants/constants.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _email;
  String _password;
  bool _saving = false;

  login() async {
    var data = {
      'username': _email,
      'password': _password,
    };

    var res = await Account().login(data);
    var body = json.decode(res.body);

    print(body);

    if (body['status'] == 401 || body['status'] == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sau parolă greșită')));
    }

    if (body['id_token'] != null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['id_token']);

      Navigator.of(context).pushNamedAndRemoveUntil(Home.routeName, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: [
      Stack(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const TopScreenImage(screenImageName: '3787309.png'),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ScreenTitle(title: 'Autentificare'),
                            CustomTextField(
                              textField: TextField(
                                  onChanged: (value) {
                                    _email = value;
                                  },
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  decoration: kTextInputDecoration.copyWith(
                                      hintText: 'Email')),
                            ),
                            CustomTextField(
                              textField: TextField(
                                obscureText: true,
                                onChanged: (value) {
                                  _password = value;
                                },
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                decoration: kTextInputDecoration.copyWith(
                                    hintText: 'Parolă'),
                              ),
                            ),
                            CustomBottomScreen(
                              textButton: 'Autentificare',
                              heroTag: 'login_btn',
                              question: '',
                              buttonPressed: () async {
                                // FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  _saving = true;
                                });
                                login();
                              },
                              questionPressed: () {
                                // signUpAlert(
                                //   onPressed: () async {
                                //     await FirebaseAuth.instance
                                //         .sendPasswordResetEmail(email: _email);
                                //   },
                                //   title: 'RESET YOUR PASSWORD',
                                //   desc: 'Click on the button to reset your password',
                                //   btnText: 'Reset Now',
                                //   context: context,
                                // ).show();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    ]))));
  }
}

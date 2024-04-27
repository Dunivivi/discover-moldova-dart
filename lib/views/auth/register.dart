import 'dart:convert';

import 'package:discounttour/views/auth/auth.dart';
import 'package:discounttour/views/auth/welcome.dart';
import 'package:flutter/material.dart';

import '../../api/account.dart';
import '../../components/components.dart';
import '../../constants/constants.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register-screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _userType = 0; // 0: User, 1: Company
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _companyName = '';

  void _handleUserTypeChange(int value) {
    setState(() {
      _userType = value;
    });
  }

  bool _validateAndSubmit() {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      var req = {
        'firstName': _firstName,
        'lastName': _lastName,
        'email': _email,
        'password': _password,
      };

      if (_userType == 1) {
        req = {...req, 'companyName': _companyName};
      }

      register(req);
      return true;
    } else {
      return false;
    }
  }

  register(data) async {
    var res;

    if (_userType == 0) {
      res = await Account().registerUser(data);
    } else {
      res = await Account().registerCompany(data);
    }

    print(res.body);
    var body = json.decode(res.body);

    if (body == 'CREATED') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Înregistrare finalizată ! '),
        ),
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AuthScreen.routeName, (_) => false);
    } else if (body['status'] == 400) {
      if (body['errorKey'] == 'emailexists') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Email existent !')));
      }
      if (body['errorKey'] == 'companyexists') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Companie existentă !')));
      }
    }
  }

  // Show a success message or navigate to another screen

  // Shared decoration for a more cohesive look
  final InputDecoration _sharedDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(
        width: 2.5,
        color: kTextColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(
        width: 2.5,
        color: Colors.blue, // Highlight color on focus (optional)
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Înregistrare",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfffafafa),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Context:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: _userType,
                    onChanged: _handleUserTypeChange,
                  ),
                  Text('Utilizator'),
                  SizedBox(width: 10.0),
                  Radio(
                    value: 1,
                    groupValue: _userType,
                    onChanged: _handleUserTypeChange,
                  ),
                  Text('Companie'),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: _sharedDecoration.copyWith(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: _sharedDecoration.copyWith(labelText: 'Nume'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Numele este obligatoriu';
                  }
                  return null;
                },
                onSaved: (value) => _firstName = value,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: _sharedDecoration.copyWith(labelText: 'Prenume'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Prenumele este obligatoriu';
                  }
                  return null;
                },
                onSaved: (value) => _lastName = value,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: _sharedDecoration.copyWith(labelText: 'Parola'),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Parola este obligatorie';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
              SizedBox(height: 15),
              if (_userType == 1)
                TextFormField(
                  decoration:
                      _sharedDecoration.copyWith(labelText: 'Nume companie'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Numele companiei este obligatoriu';
                    }
                    return null;
                  },
                  onSaved: (value) => _companyName = value,
                ),
              SizedBox(height: 20.0),
              CustomBottomScreen(
                textButton: 'Înregistrare',
                heroTag: 'register_btn',
                question: '',
                buttonPressed: () async {
                  _validateAndSubmit();
                  // FocusManager.instance.primaryFocus?.unfocus();
                  // setState(() {
                  //   _saving = true;
                  // });
                  // login();
                },
                questionPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

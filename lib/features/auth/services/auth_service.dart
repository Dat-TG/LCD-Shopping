import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/constants/errors_handling.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/home/screens/home_screen.dart';
import 'package:shopping/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/providers/user_provider.dart';

class AuthService {
  // Sign Up
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      User user = User(
          id: '',
          email: email,
          name: name,
          password: password,
          address: '',
          type: '',
          token: '');
      http.Response res = await http.post(Uri.parse('$uri/user/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Create account successful');
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Sign In
  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/user/signin'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              showSnackBar(context, 'Sign in successful');
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.setString(
                  'x-auth-code', jsonDecode(res.body)['token']);
              if (context.mounted) {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(res.body);
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);
              }
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

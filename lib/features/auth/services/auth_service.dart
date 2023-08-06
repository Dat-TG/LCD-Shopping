import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/common/widgets/bottom_bar.dart';
import 'package:shopping/constants/errors_handling.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/admin/services/admin_services.dart';
import 'package:shopping/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/providers/user_provider.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart' as cloudinary_sdk;

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
          token: '',
          cart: [],
          avatar: '',
          wishList: []);
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
                  'x-auth-token', jsonDecode(res.body)['token']);
              if (context.mounted) {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(res.body);
                Navigator.pushNamedAndRemoveUntil(
                    context, BottomBar.routeName, (route) => false);
              }
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get data of user
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      http.Response tokenRes = await http
          .post(Uri.parse('$uri/user/tokenIsValid'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      });
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(Uri.parse('$uri/user/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });
        if (context.mounted) {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(userRes.body);
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // edit information
  void editInformation(
      {required BuildContext context,
      required String email,
      required String address,
      required String name,
      File? image}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cloudinary1 = cloudinary_sdk.Cloudinary.full(
      apiKey: AdminServices.apiKey,
      apiSecret: AdminServices.apiSecret,
      cloudName: AdminServices.cloudName,
    );
    try {
      User user = userProvider.user
          .copyWith(address: address, email: email, name: name);
      final cloudinary =
          CloudinaryPublic(AdminServices.cloudName, AdminServices.uploadPreset);
      if (image != null) {
        CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path,
                folder: 'LCDShopping/user/$email'));
        String old = user.avatar;
        user = user.copyWith(avatar: res.secureUrl);
        if (old.isNotEmpty) {
          final response = await cloudinary1.deleteResources(
              urls: [old],
              resourceType: cloudinary_sdk.CloudinaryResourceType.image);
          if (response.isSuccessful) {
            // ignore: unused_local_variable
            Map<String, dynamic> deleted = response
                .deleted!; //in deleted Map you will find all the public ids and the status 'deleted'
          }
        }
      }

      http.Response res = await http.patch(
          Uri.parse('$uri/user/edit-information'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              showSnackBar(context, 'Edit account information successful');
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.setString(
                  'x-auth-token', jsonDecode(res.body)['token']);
              userProvider.setUser(res.body);
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, BottomBar.routeName, (route) => false);
              }
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

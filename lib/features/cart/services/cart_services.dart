import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants/errors_handling.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/user.dart';
import 'package:shopping/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class CartServices {
  void changeQuantityCartItem(
      {required BuildContext context,
      required Product product,
      required int quantity}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.patch(
          Uri.parse('$uri/user/change-quantity-cart-item'),
          body: jsonEncode({'id': product.id, 'quantity': quantity}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              User user = userProvider.user
                  .copyWith(cart: jsonDecode(res.body)['cart']);

              userProvider.setUserFromModel(user);
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void removeItemFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
          Uri.parse('$uri/user/remove-item/${product.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              User user = userProvider.user
                  .copyWith(cart: jsonDecode(res.body)['cart']);

              userProvider.setUserFromModel(user);
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

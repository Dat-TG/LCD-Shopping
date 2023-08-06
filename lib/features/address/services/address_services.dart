import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/bottom_bar.dart';
import 'package:shopping/constants/errors_handling.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/cart/screens/cart_screen.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/models/user.dart';
import 'package:shopping/providers/user_provider.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/user/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
        }),
      );
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User user = userProvider.user.copyWith(
              address: jsonDecode(res.body)['address'],
            );

            userProvider.setUserFromModel(user);
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // place order
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$uri/user/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'totalPrice': totalSum,
            'isCheck': CartScreen.isCheck
          }));
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Your order has been placed!');
            User user = userProvider.user.copyWith(
              cart: jsonDecode(res.body),
            );
            userProvider.setUserFromModel(user);
            CartScreen.isCheck = List.filled(user.cart.length, false).toList();
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // buy now
  void buyNow(
      {required BuildContext context,
      required String address,
      required double totalSum,
      required String productId,
      required int quantity}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$uri/user/buy-now'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'address': address,
            'totalPrice': totalSum,
            'productId': productId,
            'quantity': quantity
          }));
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Your order has been placed!');
            Navigator.of(context)
                .popUntil(ModalRoute.withName(ProductDetailsScreen.routeName));
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants/errors_handling.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/user.dart';
import 'package:shopping/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsServices {
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(Uri.parse('$uri/user/add-to-cart'),
          body: jsonEncode({'id': product.id}),
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

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
    required String content,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response res = await http.post(Uri.parse('$uri/product/rating'),
          body: jsonEncode({
            'id': product.id,
            'rating': rating,
            'content': content,
            'userName': userProvider.name,
            'avatar': userProvider.avatar,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Review product successfully');
              Navigator.pushReplacementNamed(
                context,
                ProductDetailsScreen.routeName,
                arguments: Product.fromJson(res.body),
              );
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> isValidRating({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    bool isValid = false;
    try {
      http.Response res = await http.get(
          Uri.parse('$uri/product/check-rating/${product.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              isValid = jsonDecode(res.body)['isValid'] as bool;
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return isValid;
  }

  Future<Product> getProduct(
      {required BuildContext context, required String id}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    Product product = Product(
      name: '',
      description: '',
      price: 0,
      quantity: 0,
      category: '',
      images: [],
    );
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/product/get?id=$id'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.token
      });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              product = Product.fromJson(res.body);
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return product;
  }

  void addToWishList(
      {required BuildContext context,
      required Product product,
      required bool isFavorite,
      VoidCallback? onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/user/add-to-wishList'),
          body: jsonEncode({'id': product.id}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              if (!isFavorite) {
                showSnackBar(context, 'Add product to wish list successfully');
              } else {
                showSnackBar(
                    context, 'Remove product from wish list successfully');
              }
              User user = userProvider.user.copyWith(
                  wishList:
                      List<String>.from(jsonDecode(res.body)['wishList']));

              userProvider.setUserFromModel(user);
              if (onSuccess != null) {
                onSuccess();
              }
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // fetch wish list
  Future<List<Product>> getWishList({required BuildContext context}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> products = [];
    try {
      for (int i = 0; i < user.wishList.length; i++) {
        Product product =
            await getProduct(context: context, id: user.wishList[i]);
        products.add(product);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return products;
  }
}

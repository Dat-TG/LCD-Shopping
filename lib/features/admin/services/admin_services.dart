import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart' as cloudinary_sdk;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants/errors_handling.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/features/admin/screens/admin_screen.dart';
import 'package:shopping/models/order.dart';
import 'package:shopping/providers/user_provider.dart';

import '../../../models/product.dart';
import '../models/sales.dart';

class AdminServices {
  static String cloudName = dotenv.get('CLOUD_NAME');
  static String uploadPreset = dotenv.get('UPLOAD_PRESET');
  static String apiKey = dotenv.get('API_KEY');
  static String apiSecret = dotenv.get('API_SECRET');
  void sellProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required int quantity,
      required String category,
      required List<File> images}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    try {
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path,
                folder: 'LCDShopping/products/$name'));
        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
          name: name,
          description: description,
          price: price,
          quantity: quantity,
          category: category,
          images: imageUrls);
      http.Response res = await http.post(Uri.parse('$uri/admin/add-product'),
          body: product.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              showSnackBar(context, 'Product added successful');
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AdminScreen.routeName, (route) => false);
              }
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-products'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              for (int i = 0; i < jsonDecode(res.body).length; i++) {
                productList.add(
                  Product.fromJson(
                    jsonEncode(
                      jsonDecode(res.body)[i],
                    ),
                  ),
                );
              }
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  // Delete products
  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    final cloudinary = cloudinary_sdk.Cloudinary.full(
      apiKey: apiKey,
      apiSecret: apiSecret,
      cloudName: cloudName,
    );
    try {
      final response = await cloudinary.deleteResources(
          urls: product.images,
          resourceType: cloudinary_sdk.CloudinaryResourceType.image);
      if (response.isSuccessful) {
        // ignore: unused_local_variable
        Map<String, dynamic> deleted = response
            .deleted!; //in deleted Map you will find all the public ids and the status 'deleted'
      }
      http.Response res = await http.delete(
          Uri.parse('$uri/admin/product/${product.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              showSnackBar(context, 'Product deleted successful');
              onSuccess();
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get orders
  Future<List<Order>> getOrders(BuildContext context, int status) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/admin/get-orders?status=$status'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList.add(
                Order.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.patch(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: onSuccess,
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    double totalEarning = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var response = jsonDecode(res.body);
            totalEarning = response['totalEarnings'] + .0;
            sales = [
              Sales('Mobiles', response['mobileEarnings'] + .0),
              Sales('Essentials', response['essentialEarnings'] + .0),
              Sales('Books', response['booksEarnings'] + .0),
              Sales('Appliances', response['applianceEarnings'] + .0),
              Sales('Fashion', response['fashionEarnings'] + .0),
            ];
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  void editProduct(
      {required BuildContext context,
      required Product product,
      required List<File> images,
      required List<String> removeOldImages}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    final cloudinary1 = cloudinary_sdk.Cloudinary.full(
      apiKey: apiKey,
      apiSecret: apiSecret,
      cloudName: cloudName,
    );
    try {
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path,
                folder: 'LCDShopping/products/${product.name}'));
        product.images.add(res.secureUrl);
      }
      final response = await cloudinary1.deleteResources(
          urls: removeOldImages,
          resourceType: cloudinary_sdk.CloudinaryResourceType.image);
      if (response.isSuccessful) {
        // ignore: unused_local_variable
        Map<String, dynamic> deleted = response
            .deleted!; //in deleted Map you will find all the public ids and the status 'deleted'
      }
      http.Response res = await http.patch(Uri.parse('$uri/admin/edit-product'),
          body: product.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.token
          });
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              showSnackBar(context, 'Product edited successful');
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AdminScreen.routeName, (route) => false);
              }
            });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

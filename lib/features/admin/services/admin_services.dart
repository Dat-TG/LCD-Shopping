import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart' as cloudinarySDK;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants/errors_handling.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/features/admin/screens/admin_screen.dart';
import 'package:shopping/providers/user_provider.dart';

import '../../../models/product.dart';

class AdminServices {
  String cloudName = dotenv.get('CLOUD_NAME');
  String uploadPreset = dotenv.get('UPLOAD_PRESET');
  String apiKey = dotenv.get('API_KEY');
  String apiSecret = dotenv.get('API_SECRET');
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
    final cloudinary = cloudinarySDK.Cloudinary.full(
      apiKey: apiKey,
      apiSecret: apiSecret,
      cloudName: cloudName,
    );
    try {
      final response = await cloudinary.deleteResources(
          urls: product.images,
          resourceType: cloudinarySDK.CloudinaryResourceType.image);
      if (response.isSuccessful) {
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
}
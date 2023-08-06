import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopping/common/widgets/loader.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/features/product-details/services/product_details_services.dart';
import 'package:shopping/features/search/widgets/searched_product.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/user.dart';
import 'package:shopping/providers/user_provider.dart';

class WishListScreen extends StatefulWidget {
  static const String routeName = '/wish-list-screen';
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  List<Product>? productsList;
  void fetchProductsList() async {
    productsList = await productDetailsServices.getWishList(context: context);
    setState(() {});
  }

  void showAlertDialog(
      BuildContext context, VoidCallback onConfirm, Product product) {
    // set up the button
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalVariables.selectedNavBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        onConfirm();
      },
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white),
      ),
    );

    Widget cancelButton = TextButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: GlobalVariables.selectedNavBarColor,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "Cancel",
        style: TextStyle(color: GlobalVariables.selectedNavBarColor),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm remove product from your wish list"),
      content: RichText(
          text: TextSpan(
              text: "Are you sure you want to remove this product: ",
              style: const TextStyle(color: Colors.black),
              children: [
            TextSpan(
              text: product.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: GlobalVariables.selectedNavBarColor),
            ),
            const TextSpan(text: "?", style: TextStyle(color: Colors.black))
          ])),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProductsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: const Text(
            'My Wish List',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
      ),
      body: (productsList == null)
          ? const Loader()
          : productsList!.isEmpty
              ? const Center(
                  child: Text('There are no products'),
                )
              : ListView.builder(
                  itemCount: productsList!.length,
                  itemBuilder: (context, index) {
                    final product = productsList![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ProductDetailsScreen.routeName,
                            arguments: product);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchedProduct(
                              product: product,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 135,
                                ),
                                IconButton(
                                    onPressed: () {
                                      showAlertDialog(
                                        context,
                                        () async {
                                          productDetailsServices.addToWishList(
                                              context: context,
                                              product: product,
                                              isFavorite: true,
                                              onSuccess: () {
                                                Navigator.pushReplacementNamed(
                                                    context,
                                                    WishListScreen.routeName);
                                              });
                                        },
                                        product,
                                      );
                                    },
                                    icon: const Icon(
                                        Icons.delete_outline_outlined)),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

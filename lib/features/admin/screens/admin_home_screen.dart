import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/loader.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/account/widgets/single_product.dart';
import 'package:shopping/features/admin/screens/add_product_screen.dart';
import 'package:shopping/features/admin/services/admin_services.dart';
import 'package:shopping/models/product.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Product>? products;
  final adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void showAlertDialog(
      BuildContext context, VoidCallback onConfirm, Product product) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
        onConfirm();
      },
      child: const Text("OK"),
    );

    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Cancel"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm delete product"),
      content: RichText(
          text: TextSpan(
              text: "Are you sure you want to delete this product: ",
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
        okButton,
        cancelButton,
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

  void deleteProduct(Product product, int index) => {
        adminServices.deleteProduct(
            context: context,
            product: product,
            onSuccess: () {
              products!.removeAt(index);
              setState(() {});
            })
      };

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: products!.isEmpty
                ? const Center(
                    child: Text('There are not any products'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: products!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      final productData = products![index];
                      return Column(
                        children: [
                          SizedBox(
                              height: 140,
                              child: SingleProduct(img: productData.images[0])),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    productData.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => showAlertDialog(
                                        context,
                                        () => deleteProduct(productData, index),
                                        productData),
                                    icon: const Icon(Icons.delete_outline))
                              ],
                            ),
                          )
                        ],
                      );
                    }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AddProductScreen.routeName);
              },
              tooltip: 'Add a product',
              child: const Icon(
                Icons.add,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

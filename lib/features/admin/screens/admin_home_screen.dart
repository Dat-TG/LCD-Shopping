import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/loader.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/account/widgets/single_product.dart';
import 'package:shopping/features/admin/screens/add_product_screen.dart';
import 'package:shopping/features/admin/screens/edit_product_screen.dart';
import 'package:shopping/features/admin/services/admin_services.dart';
import 'package:shopping/features/admin/widgets/menu_product.dart';
import 'package:shopping/features/home/services/home_services.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/models/product.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int choice = 0;
  List<Product>? products;
  final AdminServices adminServices = AdminServices();
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    setState(() {
      products = null;
    });
    if (choice == 0) {
      products = await adminServices.fetchAllProducts(context);
    } else {
      products = await homeServices.fetchProductsByCategory(
          context: context,
          category: GlobalVariables.categoryImages[choice - 1]['title'] ?? '');
    }
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              color: Colors.white,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: GlobalVariables.categoryImages.length,
                  itemExtent: 75,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          if (choice != index + 1) {
                            choice = index + 1;
                          } else {
                            choice = 0;
                          }
                        });
                        fetchAllProducts();
                      },
                      child: DecoratedBox(
                        decoration: (choice == index + 1)
                            ? BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                color: GlobalVariables.secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              )
                            : const BoxDecoration(),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  GlobalVariables.categoryImages[index]
                                      ['image']!,
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                GlobalVariables.categoryImages[index]['title']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: (choice == index + 1
                                      ? Colors.white
                                      : Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            products == null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 230,
                    child: const Loader())
                : products!.isEmpty
                    ? const Center(
                        child: Text('There are not any products'),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 230,
                          child: GridView.builder(
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
                                        child: SingleProduct(
                                            img: productData.images[0])),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              productData.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          MenuProduct(
                                              onPreview: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  ProductDetailsScreen
                                                      .routeName,
                                                  arguments: productData,
                                                );
                                              },
                                              onEdit: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  EditProductScreen.routeName,
                                                  arguments: productData,
                                                );
                                              },
                                              onDelete: () => showAlertDialog(
                                                  context,
                                                  () => deleteProduct(
                                                      productData, index),
                                                  productData))
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
        tooltip: 'Add a product',
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

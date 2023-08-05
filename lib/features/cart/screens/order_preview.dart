import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/address/screens/address_screen.dart';
import 'package:shopping/features/cart/screens/cart_screen.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/user.dart';
import 'package:shopping/providers/user_provider.dart';

class OrderPreview extends StatelessWidget {
  final double sum;
  static const String routeName = '/order-preview';
  const OrderPreview({super.key, required this.sum});

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    void naviagteToAddressScreen(double sum) {
      Navigator.pushNamed(
        context,
        AddressScreen.routeName,
        arguments: sum.toString(),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: const Text(
            "Order Preview",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
                children: user.cart
                    .asMap()
                    .map((index, item) {
                      if (CartScreen.isCheck[index] == false) {
                        return MapEntry(index, const SizedBox());
                      }
                      Product product = Product.fromMap(item['product']);
                      return MapEntry(
                        index,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Image.network(
                                product.images[0],
                                height: 120,
                                width: 120,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/image_not_available.png',
                                    height: 120,
                                    width: 120,
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text('\$${product.price}'),
                                    ),
                                    Text('Qty: ${item['quantity']}'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
                    .values
                    .toList()),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Subtotal: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '\$${sum.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: 'Next',
              onTap: () {
                naviagteToAddressScreen(sum);
              },
            )
          ],
        ),
      ),
    );
  }
}

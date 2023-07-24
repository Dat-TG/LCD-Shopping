import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/features/product-details/services/product_details_services.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/providers/user_provider.dart';

class CartItem extends StatefulWidget {
  final int index;
  const CartItem({super.key, required this.index});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final productServices = ProductDetailsServices();

  void increaseQuantity(Product product) {
    productServices.addToCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 235,
                    child: Text(
                      product.name,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    width: 235,
                    child: Text(
                      "\$${product.price}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    width: 235,
                    child: const Text(
                      "Eligibale for FREE Shipping",
                      style: TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    width: 235,
                    child: const Text(
                      "In Stock",
                      style: TextStyle(fontSize: 16, color: Colors.teal),
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12),
                child: Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.remove,
                        size: 18,
                      ),
                    ),
                    Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 1.5),
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white),
                        alignment: Alignment.center,
                        child: Text(productCart['quantity'].toString())),
                    InkWell(
                      onTap: () => increaseQuantity(product),
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

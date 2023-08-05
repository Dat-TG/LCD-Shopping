import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/custom_textfield.dart';
import 'package:shopping/features/cart/screens/cart_screen.dart';
import 'package:shopping/features/cart/services/cart_services.dart';
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
  final cartServices = CartServices();
  final TextEditingController _quantityController = TextEditingController();

  void increaseQuantity(Product product) {
    productServices.addToCart(context: context, product: product);
  }

  void updateQuantity(Product product, int quantity) {
    cartServices.changeQuantityCartItem(
        context: context, product: product, quantity: quantity);
  }

  void removeItem(Product product) {
    CartScreen.isCheck.removeAt(widget.index);
    cartServices.removeItemFromCart(context: context, product: product);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
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
                height: 100,
                width: 100,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 235,
                    child: Text(
                      product.name,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
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
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    width: 235,
                    child: const Text(
                      "In Stock",
                      style: TextStyle(fontSize: 14, color: Colors.teal),
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => {
                        if ((productCart['quantity'] as int) > 1)
                          updateQuantity(
                              product, (productCart['quantity'] as int) - 1)
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _quantityController.text =
                            productCart['quantity'].toString();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                                top: 20,
                                right: 20,
                              ),
                              title: const Text('Input Quantity'),
                              content: CustomTextField(
                                controller: _quantityController,
                                hint: 'Enter quantity',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    updateQuantity(product,
                                        int.parse(_quantityController.text));
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                          constraints: const BoxConstraints(minWidth: 25),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 25,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.white),
                          alignment: Alignment.center,
                          child: Text(productCart['quantity'].toString())),
                    ),
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
              ),
              InkWell(
                onTap: () => removeItem(product),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black26,
                  ),
                  child: const Icon(
                    Icons.delete_outline_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

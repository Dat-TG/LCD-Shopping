import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/common/widgets/custom_textfield.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/buy-now/screens/address_by_now.dart';
import 'package:shopping/models/product.dart';

class BuyNowScreen extends StatefulWidget {
  static const String routeName = '/buy-now';
  final Product product;
  const BuyNowScreen({super.key, required this.product});

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  double subtotal = 0;
  int _quantity = 1;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = '1';
    subtotal = widget.product.price;
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
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
            "Buy Now",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Image.network(
                  widget.product.images[0],
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
                        widget.product.name,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      width: 235,
                      child: Text(
                        "\$${widget.product.price}",
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
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                            subtotal = widget.product.price * _quantity;
                          });
                        }
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
                        _quantityController.text = _quantity.toString();
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
                                    setState(() {
                                      _quantity =
                                          int.parse(_quantityController.text);
                                      subtotal =
                                          widget.product.price * _quantity;
                                    });
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
                        child: Text(_quantity.toString()),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _quantity++;
                          subtotal = widget.product.price * _quantity;
                        });
                      },
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
              Row(
                children: [
                  const Text(
                    'Subtotal: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              text: 'Next',
              onTap: () {
                Navigator.pushNamed(context, AddressBuyNowScreen.routeName,
                    arguments: AddressBuyNowScreenArguments(
                        subtotal.toString(), widget.product.id!, _quantity));
              },
            ),
          )
        ],
      ),
    );
  }
}

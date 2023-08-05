import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/cart/screens/order_preview.dart';
import 'package:shopping/features/cart/widgets/cart_item.dart';
import 'package:shopping/features/home/screens/speech_screen.dart';
import 'package:shopping/features/home/widgets/address_box.dart';
import 'package:shopping/features/search/screens/search_screen.dart';
import 'package:shopping/providers/user_provider.dart';

class CartScreen extends StatefulWidget {
  static List<bool> isCheck = [];
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int chooseItems = 0;
  double sum = 0;

  void naviagteToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void navigateToOrderPreview() {
    Navigator.pushNamed(context, OrderPreview.routeName, arguments: sum);
  }

  void naviagteToSpeechScreen() {
    Navigator.pushNamed(context, SpeechScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (CartScreen.isCheck.isEmpty) {
      CartScreen.isCheck = List.filled(user.cart.length, false).toList();
    }

    while (CartScreen.isCheck.length < user.cart.length) {
      CartScreen.isCheck.add(false);
    }

    sum = 0;
    for (int i = 0; i < user.cart.length; i++) {
      if (CartScreen.isCheck[i] == true) {
        sum += (user.cart[i]['quantity'] + .0) *
            (user.cart[i]['product']['price'] + .0) as double;
      }
    }

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: GlobalVariables.appBarGradient),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          height: 42,
                          margin: const EdgeInsets.only(left: 15),
                          child: Material(
                            borderRadius: BorderRadius.circular(7),
                            elevation: 1,
                            child: TextFormField(
                              onFieldSubmitted: naviagteToSearchScreen,
                              decoration: InputDecoration(
                                  hintText: 'Search LCDShopping',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                  prefixIcon: InkWell(
                                    onTap: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 23,
                                      ),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding:
                                      const EdgeInsets.only(top: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: Colors.black38, width: 1),
                                  )),
                            ),
                          )),
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                          icon: const Icon(
                            Icons.mic,
                            size: 25,
                          ),
                          onPressed: naviagteToSpeechScreen,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const AddressBox(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Proceed to Buy ($chooseItems) items",
                    onTap: () {
                      if (chooseItems == 0) {
                        showSnackBar(
                            context, 'Please select products you want to buy');
                      } else {
                        navigateToOrderPreview();
                      }
                    },
                    backgroundColor: Colors.yellow[600],
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    for (int index = 0; index < user.cart.length; index++)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Checkbox(
                              shape: const CircleBorder(),
                              value: CartScreen.isCheck[index],
                              onChanged: (value) {
                                setState(() {
                                  CartScreen.isCheck[index] = value!;
                                  chooseItems = CartScreen.isCheck
                                      .where((element) => element == true)
                                      .length;
                                  sum = 0;
                                  for (int i = 0; i < user.cart.length; i++) {
                                    if (CartScreen.isCheck[i] == true) {
                                      sum += ((user.cart[i]['quantity'] + .0) *
                                          (user.cart[i]['product']['price'] +
                                              .0)) as double;
                                    }
                                  }
                                });
                              },
                            ),
                            CartItem(
                              index: index,
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

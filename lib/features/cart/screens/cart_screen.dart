import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/address/screens/address_screen.dart';
import 'package:shopping/features/cart/widgets/cart_item.dart';
import 'package:shopping/features/cart/widgets/cart_subtotal.dart';
import 'package:shopping/features/home/widgets/address_box.dart';
import 'package:shopping/features/search/screens/search_screen.dart';
import 'package:shopping/providers/user_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void naviagteToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void naviagteToAddressScreen(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
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
                                  fontWeight: FontWeight.w500, fontSize: 17),
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
                              contentPadding: const EdgeInsets.only(top: 10),
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.mic,
                      size: 25,
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
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Proceed to Buy (${user.cart.length}) items",
                onTap: () => naviagteToAddressScreen(sum),
                backgroundColor: Colors.yellow[600],
                textColor: Colors.black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return CartItem(index: index);
              },
              shrinkWrap: true,
              itemCount: user.cart.length,
            )
          ],
        ),
      ),
    );
  }
}

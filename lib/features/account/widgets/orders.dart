import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/loader.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/account/screens/see_all_orders.dart';
import 'package:shopping/features/account/services/account_services.dart';
import 'package:shopping/features/account/widgets/single_product.dart';
import 'package:shopping/features/order-details/screens/order_details_screen.dart';
import 'package:shopping/models/order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final AccountServices accountServices = AccountServices();
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  void fetchAllOrders() async {
    orders = await accountServices.fetchAllOrders(context: context);
    if (mounted) setState(() {});
  }

  void naviagteToOrderDetails(Order order) {
    Navigator.pushNamed(context, OrderDetailsScreen.routeName,
        arguments: order);
  }

  void naviagteToAllOrders() {
    Navigator.pushNamed(
      context,
      SeeAllOrders.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Your Orders',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: naviagteToAllOrders,
                      child: Text(
                        'See all',
                        style: TextStyle(
                            color: GlobalVariables.selectedNavBarColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ),
              // Orders
              Container(
                height: 170,
                padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orders!.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () => naviagteToOrderDetails(orders![index]),
                        child: SingleProduct(
                            img: orders![index].products[0].images[0]),
                      );
                    })),
              )
            ],
          );
  }
}

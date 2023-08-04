import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping/common/widgets/loader.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/admin/services/admin_services.dart';
import 'package:shopping/features/order-details/screens/order_details_screen.dart';
import 'package:shopping/models/order.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  int status = -1;
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders(status);
  }

  void fetchOrders(int status) async {
    orders = await adminServices.getOrders(context, status);
    setState(() {});
  }

  void chooseStatus(int val) async {
    setState(() {
      status = val;
      orders = null;
    });
    fetchOrders(status);
  }

  void navigateToOrderDetails(Order order) {
    Navigator.pushNamed(context, OrderDetailsScreen.routeName,
        arguments: order);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Oders Management",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        chooseStatus(-1);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: (status == -1)
                                  ? const BorderSide(
                                      color: GlobalVariables.secondaryColor,
                                      width: 2,
                                    )
                                  : BorderSide.none),
                        ),
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 16,
                            color: status == -1
                                ? GlobalVariables.secondaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        chooseStatus(0);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: (status == 0)
                                  ? const BorderSide(
                                      color: GlobalVariables.secondaryColor,
                                      width: 2,
                                    )
                                  : BorderSide.none),
                        ),
                        child: Text(
                          'To Pay',
                          style: TextStyle(
                            fontSize: 16,
                            color: status == 0
                                ? GlobalVariables.secondaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        chooseStatus(1);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: (status == 1)
                                  ? const BorderSide(
                                      color: GlobalVariables.secondaryColor,
                                      width: 2,
                                    )
                                  : BorderSide.none),
                        ),
                        child: Text(
                          'To Ship',
                          style: TextStyle(
                            fontSize: 16,
                            color: status == 1
                                ? GlobalVariables.secondaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        chooseStatus(2);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: (status == 2)
                                  ? const BorderSide(
                                      color: GlobalVariables.secondaryColor,
                                      width: 2,
                                    )
                                  : BorderSide.none),
                        ),
                        child: Text(
                          'To Receive',
                          style: TextStyle(
                            fontSize: 16,
                            color: status == 2
                                ? GlobalVariables.secondaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        chooseStatus(3);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: (status == 3)
                                  ? const BorderSide(
                                      color: GlobalVariables.secondaryColor,
                                      width: 2,
                                    )
                                  : BorderSide.none),
                        ),
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 16,
                            color: status == 3
                                ? GlobalVariables.secondaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (orders == null)
                ? const Loader()
                : orders!.isEmpty
                    ? const Center(
                        child: Text('There are not any orders'),
                      )
                    : Column(
                        children: [
                          for (int i = 0; i < orders!.length; i++)
                            GestureDetector(
                              onTap: () => navigateToOrderDetails(orders![i]),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black12, width: 1))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(DateFormat().format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  orders![i].orderedAt))),
                                          Text(
                                            GlobalVariables
                                                .orderStatus[orders![i].status],
                                            style: const TextStyle(
                                                color: GlobalVariables
                                                    .secondaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.network(
                                          orders![i].products[0].images[0],
                                          height: 120,
                                          width: 120,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/image_not_available.png',
                                              width: 120,
                                              height: 120,
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                orders![i].products[0].name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 5,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'x${orders![i].quantity[0]}'),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '\$${orders![i].quantity[0] * orders![i].products[0].price}',
                                                style: const TextStyle(
                                                  color: GlobalVariables
                                                      .secondaryColor,
                                                ),
                                              ),
                                              if (orders![i].products.length >
                                                  1)
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    'View all products',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Text('Order Total: '),
                                                  Text(
                                                    '\$${orders![i].totalPrice}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: GlobalVariables
                                                          .secondaryColor,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
          ],
        ),
      ),
    );
  }
}

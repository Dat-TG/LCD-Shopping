import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/admin/services/admin_services.dart';
import 'package:shopping/features/home/screens/speech_screen.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/features/product-details/services/product_details_services.dart';
import 'package:shopping/features/search/screens/search_screen.dart';
import 'package:shopping/models/order.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/providers/user_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  void naviagteToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void navigateToProductDetails(Product product) async {
    final ProductDetailsServices productDetailsServices =
        ProductDetailsServices();
    Product curProduct = await productDetailsServices.getProduct(
        context: context, id: product.id!);
    if (mounted) {
      if (curProduct.name.isNotEmpty) {
        Navigator.pushNamed(context, ProductDetailsScreen.routeName,
            arguments: curProduct);
      } else {
        Navigator.pushNamed(context, ProductDetailsScreen.routeName,
            arguments: product);
        showSnackBar(context, 'This product is now not available');
      }
    }
  }

  void naviagteToSpeechScreen() {
    Navigator.pushNamed(context, SpeechScreen.routeName);
  }

  // !!! ONLY FOR ADMIN!!!
  void changeOrderStatus(int status) {
    if (status < 3) {
      adminServices.changeOrderStatus(
        context: context,
        status: status + 1,
        order: widget.order,
        onSuccess: () {
          setState(() {
            currentStep += 1;
          });
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                      height: 42,
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'View Order Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('Order Date:      ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt),
                    )}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('Order ID:          ${widget.order.id}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child:
                        Text('Order Total:     \$${widget.order.totalPrice}'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Purchase Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < widget.order.products.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          navigateToProductDetails(widget.order.products[i]),
                      child: Row(
                        children: [
                          Image.network(
                            widget.order.products[i].images[0],
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
                                  widget.order.products[i].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                                Text('Qty: ${widget.order.quantity[i]}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Tracking',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: Stepper(
                physics: const ClampingScrollPhysics(),
                currentStep: currentStep,
                controlsBuilder: (context, details) {
                  if (user.type == 'admin') {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        text: 'Done',
                        onTap: () => changeOrderStatus(details.currentStep),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                steps: [
                  Step(
                    title: const Text('Order Success'),
                    content: const Text(
                      'Your order is going to be packed',
                    ),
                    isActive: currentStep >= 0,
                    state: currentStep >= 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('To Ship'),
                    content: const Text(
                      'Your order is yet to be delivered',
                    ),
                    isActive: currentStep > 0,
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('To Receive'),
                    content: const Text(
                      'Your order is being delivered.',
                    ),
                    isActive: currentStep > 1,
                    state: currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Completed'),
                    content: const Text(
                      'Your order has been delivered and signed by you.',
                    ),
                    isActive: currentStep > 2,
                    state: currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shopping/features/account/screens/see_all_orders.dart';
import 'package:shopping/features/account/services/account_services.dart';
import 'package:shopping/features/account/widgets/account_button.dart';
import 'package:shopping/features/wish-list/screens/wish_list_screen.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  final AccountServices accountServices = AccountServices();

  void navigateToOrdersScreen() {
    Navigator.pushNamed(context, SeeAllOrders.routeName);
  }

  void navigateToWishListScreen() {
    Navigator.pushNamed(context, WishListScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your Orders',
              onTap: navigateToOrdersScreen,
            ),
            AccountButton(text: 'Turn Seller', onTap: () {}),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Logout', onTap: () => accountServices.logOut(context)),
            AccountButton(
              text: 'Your Wish List',
              onTap: navigateToWishListScreen,
            ),
          ],
        )
      ],
    );
  }
}

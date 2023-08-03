import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/account/screens/edit_account_screen.dart';
import 'package:shopping/features/account/services/account_services.dart';
import 'package:shopping/features/account/widgets/list_tile_account.dart';
import 'package:shopping/features/order-details/screens/order_details_screen.dart';
import 'package:shopping/models/order.dart';
import 'package:shopping/models/user.dart';
import 'package:shopping/providers/user_provider.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
  }

  void naviagteToOrderDetails(Order order) {
    Navigator.pushNamed(context, OrderDetailsScreen.routeName,
        arguments: order);
  }

  void naviagteToEditAccountScreen(
      String email, String name, String address, String avatar) {
    Navigator.pushNamed(
      context,
      EditAccountScreen.routeName,
      arguments: EditAccountScreenArguments(email, name, address, avatar),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              child: const Text(
                'Your Information',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () => naviagteToEditAccountScreen(
                    user.email, user.name, user.address, user.avatar),
                child: Text(
                  'Edit',
                  style: TextStyle(
                      color: GlobalVariables.selectedNavBarColor,
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CircleAvatar(
          backgroundImage: (user.avatar.isNotEmpty)
              ? NetworkImage(user.avatar) as ImageProvider
              : const AssetImage('assets/images/avatar.png'),
          radius: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTileAccount(
                leading: 'ID',
                title: user.id,
              ),
              ListTileAccount(
                leading: 'Name',
                title: user.name,
              ),
              ListTileAccount(
                leading: 'Email',
                title: user.email,
              ),
              ListTileAccount(
                leading: 'Address',
                title: user.address,
              ),
            ],
          ),
        )
      ],
    );
  }
}

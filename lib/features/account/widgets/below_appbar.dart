import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/providers/user_provider.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).user.name;
    return Container(
      decoration: const BoxDecoration(gradient: GlobalVariables.appBarGradient),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          RichText(
              text: TextSpan(
                  text: 'Hello, ',
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                  children: [
                TextSpan(
                  text: username,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                )
              ])),
        ],
      ),
    );
  }
}

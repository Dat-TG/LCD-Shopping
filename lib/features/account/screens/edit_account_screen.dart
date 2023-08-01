import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/common/widgets/custom_textfield.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/auth/services/auth_service.dart';

class EditAccountScreenArguments {
  final String email;
  final String name;
  final String address;
  EditAccountScreenArguments(this.email, this.name, this.address);
}

class EditAccountScreen extends StatefulWidget {
  static const String routeName = '/edit-information';
  final String email;
  final String name;
  final String address;
  const EditAccountScreen({
    super.key,
    required this.email,
    required this.address,
    required this.name,
  });

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final editAccountFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _nameController.text = widget.name;
    _addressController.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Information'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: GlobalVariables.appBarGradient),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: editAccountFormKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _emailController,
                  hint: 'Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _nameController,
                  hint: 'Name',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _addressController,
                  hint: 'Address',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: 'Save',
                  onTap: () {
                    if (editAccountFormKey.currentState!.validate()) {
                      authService.editInformation(
                        context: context,
                        email: _emailController.text,
                        address: _addressController.text,
                        name: _nameController.text,
                      );
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}

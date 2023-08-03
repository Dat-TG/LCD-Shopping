import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/common/widgets/custom_textfield.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/auth/services/auth_service.dart';

class EditAccountScreenArguments {
  final String email;
  final String name;
  final String address;
  final String avatar;
  EditAccountScreenArguments(this.email, this.name, this.address, this.avatar);
}

class EditAccountScreen extends StatefulWidget {
  static const String routeName = '/edit-information';
  final String email;
  final String name;
  final String address;
  final String avatar;
  const EditAccountScreen({
    super.key,
    required this.email,
    required this.address,
    required this.name,
    required this.avatar,
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

  File? uploadImage;

  void selectImages() async {
    var res = await pickImage();
    setState(() {
      uploadImage = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _nameController.text = widget.name;
    _addressController.text = widget.address;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Information',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: GlobalVariables.appBarGradient),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: CircleAvatar(
                  backgroundImage: (uploadImage != null)
                      ? FileImage(uploadImage!)
                      : (widget.avatar.isNotEmpty)
                          ? NetworkImage(widget.avatar) as ImageProvider
                          : const AssetImage('assets/images/avatar.png'),
                  radius: 50,
                ),
              ),
              Positioned(
                bottom: -10,
                left: 25,
                child: IconButton(
                  onPressed: selectImages,
                  icon: const Icon(Icons.add_a_photo_outlined),
                ),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Form(
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
                            image: uploadImage,
                          );
                        }
                      },
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

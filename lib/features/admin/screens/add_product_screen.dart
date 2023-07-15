import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/common/widgets/custom_textfield.dart';

import '../../../constants/global_variables.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  List<String> categoryList = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];
  String category = 'Mobiles';
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient),
              ),
              title: const Text(
                'Add Product',
                style: TextStyle(color: Colors.black),
              ))),
      body: SingleChildScrollView(
        child: Form(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 4],
                  radius: const Radius.circular(10),
                  strokeCap: StrokeCap.round,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.folder_open,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Select Product Images',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade400),
                        )
                      ],
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: productNameController,
                hint: 'Product Name',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: descriptionController,
                hint: 'Description',
                maxLines: 7,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: priceController,
                hint: 'Price',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: quantityController,
                hint: 'Quantity',
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: DropdownButton(
                  items: categoryList
                      .map((String item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                  value: category,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Sell',
                onTap: () {},
              )
            ],
          ),
        )),
      ),
    );
  }
}

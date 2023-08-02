import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/common/widgets/custom_textfield.dart';
import 'package:shopping/constants/utils.dart';
import 'package:shopping/features/admin/screens/admin_screen.dart';
import 'package:shopping/features/admin/services/admin_services.dart';
import 'package:shopping/models/product.dart';

import '../../../constants/global_variables.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  final Product product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminService = AdminServices();
  final _addProductFormKey = GlobalKey<FormState>();
  List<File> images = [];
  List<String> oldImages = [];
  List<String> removeOldImages = [];
  List<String> categoryList = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];
  String category = 'Mobiles';

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void addMoreImages() async {
    var res = await pickImages();
    setState(() {
      images = images + res;
    });
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() &&
        (images.isNotEmpty || oldImages.isNotEmpty)) {
      Product newproduct = widget.product.copyWith(
        category: category,
        description: descriptionController.text,
        images: oldImages,
        name: productNameController.text,
        price: double.parse(priceController.text),
        quantity: int.parse(quantityController.text),
      );
      adminService.editProduct(
          context: context,
          images: images,
          product: newproduct,
          removeOldImages: removeOldImages);
    }
  }

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    quantityController.text = widget.product.quantity.toString();
    category = widget.product.category;
    oldImages = widget.product.images;
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  void showAlertDialog(BuildContext context, VoidCallback onConfirm) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        onConfirm();
      },
      child: const Text("Save"),
    );

    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, AdminScreen.routeName, (route) => false);
      },
      child: const Text("Don't Save"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Do you want to save changes?"),
      actions: [
        okButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showAlertDialog(
          context,
          () {
            sellProduct();
          },
        );
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: GlobalVariables.appBarGradient),
                ),
                title: const Text(
                  'Edit Product',
                  style: TextStyle(color: Colors.black),
                ))),
        body: SingleChildScrollView(
          child: Form(
              key: _addProductFormKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    (images.isNotEmpty || oldImages.isNotEmpty)
                        ? Column(
                            children: [
                              CarouselSlider(
                                items: images
                                        .asMap()
                                        .map((index, item) {
                                          return MapEntry(
                                              index,
                                              Builder(
                                                builder:
                                                    (BuildContext context) =>
                                                        Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.file(
                                                      item,
                                                      fit: BoxFit.cover,
                                                      height: 200,
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: -10,
                                                      child: IconButton(
                                                        tooltip:
                                                            'Remove this image',
                                                        onPressed: () {
                                                          setState(() {
                                                            images.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.cancel),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                        })
                                        .values
                                        .toList() +
                                    oldImages
                                        .asMap()
                                        .map((index, item) {
                                          return MapEntry(
                                              index + images.length,
                                              Builder(
                                                builder:
                                                    (BuildContext context) =>
                                                        Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.network(
                                                      item,
                                                      fit: BoxFit.cover,
                                                      height: 200,
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: -10,
                                                      child: IconButton(
                                                        tooltip:
                                                            'Remove this image',
                                                        onPressed: () {
                                                          setState(() {
                                                            removeOldImages.add(
                                                                oldImages[
                                                                    index]);
                                                            oldImages.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.cancel),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                        })
                                        .values
                                        .toList(),
                                options: CarouselOptions(
                                    viewportFraction: 1, height: 200),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: CustomButton(
                                  text: 'Add More Images',
                                  onTap: addMoreImages,
                                ),
                              )
                            ],
                          )
                        : GestureDetector(
                            onTap: selectImages,
                            child: DottedBorder(
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
                                            fontSize: 15,
                                            color: Colors.grey.shade400),
                                      )
                                    ],
                                  ),
                                )),
                          ),
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
                            .map((String item) => DropdownMenuItem(
                                value: item, child: Text(item)))
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
                      text: 'Save changes',
                      onTap: sellProduct,
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

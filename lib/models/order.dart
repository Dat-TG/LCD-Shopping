import 'dart:convert';

import 'package:shopping/models/product.dart';

class Order {
  final String id;
  final String userId;
  final List<Product> products;
  final List<int> quantity;
  final int orderedAt;
  final int status;
  final int totalPrice;
  final String address;
  Order({
    required this.id,
    required this.userId,
    required this.products,
    required this.quantity,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
      'address': address,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      userId: map['userId'] ?? '',
      products: List<Product>.from(
          map['products']?.map((x) => Product.fromMap(x['product']))),
      quantity: List<int>.from(map['products']?.map((x) => x['quantity'])),
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toInt() ?? 0,
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}

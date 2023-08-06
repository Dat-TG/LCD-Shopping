import 'dart:convert';

class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;
  final String avatar;
  final List<String> wishList;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.password,
      required this.address,
      required this.type,
      required this.token,
      required this.cart,
      required this.avatar,
      required this.wishList});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
      'avatar': avatar,
      'wishList': wishList
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        address: map['address'] ?? '',
        type: map['type'] ?? '',
        token: map['token'] ?? '',
        cart: List<Map<String, dynamic>>.from(
          map['cart'].map(
            (x) => Map<String, dynamic>.from(x),
          ),
        ),
        avatar: map['avatar'] ?? '',
        wishList: List<String>.from(map['wishList']));
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith(
      {String? id,
      String? email,
      String? name,
      String? password,
      String? address,
      String? type,
      String? token,
      List<dynamic>? cart,
      String? avatar,
      List<String>? wishList}) {
    return User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        password: password ?? this.password,
        address: address ?? this.address,
        type: type ?? this.type,
        token: token ?? this.token,
        cart: cart ?? this.cart,
        avatar: avatar ?? this.avatar,
        wishList: wishList ?? this.wishList);
  }
}

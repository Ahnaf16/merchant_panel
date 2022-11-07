import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String id;
  final String img;
  final String name;
  final int price;
  final int quantity;
  final int total;
  final bool isSelected;
  final String? category;
  CartModel({
    required this.id,
    required this.img,
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.isSelected,
    required this.category,
  });

  factory CartModel.fromDocument(DocumentSnapshot doc) {
    return CartModel(
      id: doc['productId'],
      img: doc['img'],
      name: doc['productName'],
      price: doc['productPrice'],
      quantity: doc['quantity'],
      total: doc['total'],
      isSelected: doc['isSelected'],
      category: doc['category'],
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['productId'],
      img: json['img'],
      name: json['productName'],
      price: json['productPrice'],
      quantity: json['quantity'],
      total: json['total'],
      isSelected: json['isSelected'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': id,
        'productName': name,
        'productPrice': price,
        'img': img,
        'quantity': quantity,
        'total': total,
        'isSelected': isSelected,
        'category': category,
      };
}

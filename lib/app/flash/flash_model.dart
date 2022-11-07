import 'package:cloud_firestore/cloud_firestore.dart';

class FlashModel {
  final String name;
  final int price;
  final int flashPrice;
  final String image;
  final String id;
  final String category;

  FlashModel({
    required this.name,
    required this.price,
    required this.flashPrice,
    required this.image,
    required this.id,
    required this.category,
  });

  factory FlashModel.fromDocument(DocumentSnapshot document) {
    return FlashModel(
      name: document['name'],
      price: document['price'],
      flashPrice: document['flash'],
      image: document['img'],
      id: document['id'],
      category: document['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'flash': flashPrice,
      'img': image,
      'id': id,
      'category': category,
    };
  }
}

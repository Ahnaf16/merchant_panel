// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final int price;
  final int discountPrice;
  final bool haveDiscount;
  final String brand;
  final List imgUrls;
  final String description;
  final Map specifications;
  final String category;
  final bool inStock;
  final Timestamp date;
  final String employeeName;
  final int priority;

  ProductModel({
    required this.name,
    required this.brand,
    required this.price,
    required this.discountPrice,
    required this.haveDiscount,
    required this.imgUrls,
    required this.description,
    required this.category,
    required this.inStock,
    required this.id,
    required this.date,
    required this.employeeName,
    required this.priority,
    required this.specifications,
  });

  factory ProductModel.fromDocument(DocumentSnapshot document) {
    return ProductModel(
      id: document.id,
      name: document['name'],
      brand: document['brand'],
      price: document['price'],
      discountPrice: document['discount_price'],
      haveDiscount: document['haveDiscount'],
      imgUrls: document['imgs'],
      // imgUrls: document['img'] ,
      description: document['product_desc'],
      category: document['category'],
      date: document['date'],
      employeeName: document['Employee']['name'],
      inStock: document['inStock'], priority: document['preority'],
      specifications: document['specifications'],
    );
  }
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'],
      discountPrice: json['discount_price'],
      haveDiscount: json['haveDiscount'],
      imgUrls: json['imgs'],
      // imgUrls: document['img'] ,
      description: json['product_desc'],
      category: json['category'],
      date: json['date'],
      employeeName: json['Employee']['name'],
      inStock: json['inStock'], priority: json['preority'],
      specifications: json['specifications'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'brand': brand,
        'price': price,
        'discount_price': discountPrice,
        'haveDiscount': haveDiscount,
        'imgs': imgUrls,
        'product_desc': description,
        'category': category,
        'inStock': inStock,
        'date': date,
        'Employee': {
          'name': employeeName,
        },
        'preority': priority,
        'specifications': specifications,
      };

  ProductModel copyWith({
    String? id,
    String? name,
    int? price,
    int? discountPrice,
    bool? haveDiscount,
    String? brand,
    List? imgUrls,
    String? description,
    Map? specifications,
    String? category,
    bool? inStock,
    Timestamp? date,
    String? employeeName,
    int? priority,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      haveDiscount: haveDiscount ?? this.haveDiscount,
      brand: brand ?? this.brand,
      imgUrls: imgUrls ?? this.imgUrls,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      category: category ?? this.category,
      inStock: inStock ?? this.inStock,
      date: date ?? this.date,
      employeeName: employeeName ?? this.employeeName,
      priority: priority ?? this.priority,
    );
  }
}

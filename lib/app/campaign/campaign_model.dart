import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  final String title;
  final String image;

  CampaignModel({
    required this.title,
    required this.image,
  });

  factory CampaignModel.fromDocument(DocumentSnapshot document) {
    return CampaignModel(
      image: document['img'],
      title: document['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'img': image,
    };
  }
}

class CampaignItemModel {
  final String img;
  final String name;
  final int price;
  final int discount;
  final bool haveDiscount;
  final String id;

  CampaignItemModel({
    required this.img,
    required this.name,
    required this.price,
    required this.id,
    required this.discount,
    required this.haveDiscount,
  });

  factory CampaignItemModel.fromDocument(DocumentSnapshot document) {
    return CampaignItemModel(
      img: document['img'],
      name: document['name'],
      price: document['price'],
      id: document['id'],
      discount: document['discount'],
      haveDiscount: document['haveDiscount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'img': img,
      'name': name,
      'price': price,
      'id': id,
      'discount': discount,
      'haveDiscount': haveDiscount,
    };
  }
}

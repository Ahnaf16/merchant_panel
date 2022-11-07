import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/customer models/cart_model.dart';
import '../../auth/customer models/user_address_model.dart';
import '../setting/users/user_model.dart';

class OrderModel {
  final String? docID;
  final String invoice;
  final AddressModel address;
  final List<CartModel> items;
  final int total;
  final int paidAmount;
  final String paymentMethod;
  final String status;
  final Timestamp orderDate;
  final UserModel user;
  final List<OrderTimelineModel> timeLine;
  final int deliveryCharge;
  final int voucher;
  final Timestamp? lastMod;

  OrderModel({
    this.docID,
    required this.invoice,
    required this.address,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.orderDate,
    required this.user,
    required this.timeLine,
    required this.paidAmount,
    required this.deliveryCharge,
    required this.voucher,
    required this.lastMod,
  });

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    return OrderModel(
      invoice: doc['invoice'],
      total: doc['total'],
      paymentMethod: doc['paymentMethod'],
      status: doc['status'],
      orderDate: doc['orderDate'],
      address: AddressModel.fromJson(doc['address']),
      user: UserModel.fromJson(doc['user']),
      items: (doc['items'] as List<dynamic>)
          .map((item) => CartModel.fromJson(item))
          .toList(),
      docID: doc.id,
      timeLine: (doc['timeLine'] as List<dynamic>)
          .map((item) => OrderTimelineModel.fromJson(item))
          .toList(),
      paidAmount: doc['paidAmount'],
      deliveryCharge: doc['deliveryCharge'],
      voucher: doc.data()!.toString().contains('voucher') ? doc['voucher'] : 0,
      lastMod:
          doc.data()!.toString().contains('lastMod') ? doc['lastMod'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice': invoice,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'orderDate': orderDate,
      'address': address.toJson(),
      'user': user.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'timeLine': timeLine.map((e) => e.toJson()).toList(),
      'paidAmount': paidAmount,
      'deliveryCharge': deliveryCharge,
      'voucher': voucher,
      'lastMod': lastMod,
    };
  }
}

class OrderTimelineModel {
  final String status;
  final Timestamp date;
  final String comment;
  final String? userName;

  OrderTimelineModel({
    required this.status,
    required this.date,
    required this.comment,
    this.userName,
  });

  factory OrderTimelineModel.fromJson(Map<String, dynamic> json) {
    return OrderTimelineModel(
      status: json['status'],
      date: json['date'],
      comment: json['comment'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'date': date,
      'comment': comment,
      'userName': userName,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String name;
  final String division;
  final String district;
  final String address;
  final String billingNumber;
  final String type;
  final bool isDefault;

  AddressModel({
    required this.name,
    required this.division,
    required this.district,
    required this.address,
    required this.billingNumber,
    required this.type,
    required this.isDefault,
  });

  factory AddressModel.fromDocument(DocumentSnapshot doc) => AddressModel(
        name: doc['name'] as String,
        division: doc['divition'] as String,
        district: doc['district'] as String,
        address: doc['address'] as String,
        billingNumber: doc['billingNumber'] as String,
        type: doc['type'] as String,
        isDefault: doc['isDefault'] as bool,
      );
  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        name: json['name'] as String,
        division: json['divition'] as String,
        district: json['district'] as String,
        address: json['address'] as String,
        billingNumber: json['billingNumber'] as String,
        type: json['type'] as String,
        isDefault: json['isDefault'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'divition': division,
        'district': district,
        'address': address,
        'billingNumber': billingNumber,
        'type': type,
        'isDefault': isDefault,
      };
}

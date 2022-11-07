// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.displayName,
    required this.loginMethod,
    required this.createdAt,
    required this.dob,
    required this.age,
    required this.gender,
    required this.totalOrders,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      phone: doc['phone'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      loginMethod: doc['loginMethod'],
      createdAt: doc['createdAt'],
      dob: doc['dob'],
      age: doc['age'],
      gender: doc['gender'],
      totalOrders: doc.data()!.toString().contains('totalOrders')
          ? doc['totalOrders']
          : -1,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      displayName: json['displayName'],
      loginMethod: json['loginMethod'],
      createdAt: json['createdAt'],
      dob: json['dob'],
      age: json['age'],
      gender: json['gender'],
      totalOrders: json.containsKey('totalOrders') ? json['totalOrders'] : 0,
    );
  }

  final int age;
  final Timestamp createdAt;
  final String displayName;
  final String dob;
  final String email;
  final String gender;
  final String loginMethod;
  final String phone;
  final String photoUrl;
  final int totalOrders;
  final String uid;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'displayName': displayName,
        'loginMethod': loginMethod,
        'createdAt': createdAt,
        'dob': dob,
        'age': age,
        'gender': gender,
        'totalOrders': totalOrders,
      };

  UserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? photoUrl,
    String? displayName,
    String? loginMethod,
    Timestamp? createdAt,
    String? dob,
    int? age,
    String? gender,
    int? totalOrders,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      loginMethod: loginMethod ?? this.loginMethod,
      createdAt: createdAt ?? this.createdAt,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      totalOrders: totalOrders ?? this.totalOrders,
    );
  }
}

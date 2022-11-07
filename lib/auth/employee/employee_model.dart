import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  EmployeeModel({
    required this.name,
    required this.uid,
    required this.role,
    required this.email,
    required this.password,
  });

  final String email;
  final String name;
  final String password;
  final String role;
  final String uid;

  factory EmployeeModel.fromDoc(DocumentSnapshot doc) {
    return EmployeeModel(
      name: doc['name'],
      uid: doc['uid'],
      role: doc['role'],
      email: doc['email'],
      password: doc['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'role': role,
      'email': email,
      'password': password,
    };
  }
}

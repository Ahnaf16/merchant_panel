import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeServices {
  final firestore = FirebaseFirestore.instance;

  changeRole(String uid, String role) async {
    EasyLoading.show(status: 'Changing Role to $role');
    final snap = firestore.collection('employess').doc(uid);

    await snap.update({
      'role': role,
    });
    EasyLoading.showSuccess('Role Changed to $role');
  }
}

final employeeServicesProvider = Provider<EmployeeServices>((ref) {
  return EmployeeServices();
});

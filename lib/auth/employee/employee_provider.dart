import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/auth/employee/employee_model.dart';

final employeeStreamProvider =
    StreamProvider.family<EmployeeModel, String?>((ref, uid) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ref = firestore.collection('employess').doc(uid).snapshots();

  return ref.map((snapshot) => EmployeeModel.fromDoc(snapshot));
});

class RolesCheck {
  final String role;

  RolesCheck(this.role);

  bool canDeleteItem() {
    if (role == 'admin' || role == 'dev') {
      return true;
    }
    return false;
  }

  bool canDeleteOrder() {
    if (role == 'dev') {
      return true;
    }
    return false;
  }

  bool canAddOffers() {
    if (role == 'admin' || role == 'dev') {
      return true;
    }
    return false;
  }

  bool canAddVoucher() {
    if (role == 'dev' || role == 'admin') {
      return true;
    }
    return false;
  }

  bool onlyMonitor() {
    if (role == 'monitor') {
      return true;
    }
    return false;
  }

  bool canManageAccounts() {
    if (role == 'dev') {
      return true;
    }
    return false;
  }

  bool canChangeVersion() {
    if (role == 'dev') {
      return true;
    }
    return false;
  }

  bool canChangeDeliveryOptions() {
    if (role == 'dev') {
      return true;
    }
    return false;
  }

  bool canViewUsers() {
    if (role == 'dev') {
      return true;
    }
    return false;
  }
}

final roleProvider =
    Provider.family.autoDispose<RolesCheck, String?>((ref, uid) {
  final employeeStream = ref.watch(employeeStreamProvider(uid));

  return employeeStream.maybeWhen(
    data: (employee) => RolesCheck(employee.role),
    orElse: () => RolesCheck('monitor'),
  );
  // return RolesCheck();
});

final employeeListProvider =
    StreamProvider.autoDispose<List<EmployeeModel>>((ref) {
  final firestore = FirebaseFirestore.instance;

  final snap =
      firestore.collection('employess').where('role', isNotEqualTo: 'dev');

  return snap.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return EmployeeModel.fromDoc(doc);
    }).toList();
  });
});

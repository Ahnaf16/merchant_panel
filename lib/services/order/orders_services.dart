import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/auth/auth_provider.dart';

class OrderServices {
  static updateOrderStatus(
    String docId,
    String status,
    String comment,
  ) async {
    EasyLoading.show(status: 'Updating Order Status...');
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('orders').doc(docId).update({
        'status': status,
        'lastMod': Timestamp.now(),
        'timeLine': FieldValue.arrayUnion([
          {
            'status': status,
            'comment': comment,
            'date': Timestamp.now(),
            'userName': getUser?.displayName,
          }
        ])
      });
      EasyLoading.showSuccess('Order Status Updated Successfully');
    } on FirebaseException catch (e, st) {
      EasyLoading.showError(e.message ?? 'something went wrong');
      log(e.message.toString(), name: 'massage');
      log(st.toString(), name: 'stacktrace');
    } on Exception catch (e, st) {
      EasyLoading.showError(e.toString());
      log(e.toString(), name: 'massage');
      log(st.toString(), name: 'stacktrace');
    }
  }

  static updatePaidAmount(
    String orderId,
    int paidAmount,
  ) async {
    EasyLoading.show(status: 'Updating Paid Amount...');
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('orders').doc(orderId).update({
      "paidAmount": paidAmount,
      'lastMod': Timestamp.now(),
    });
    EasyLoading.showSuccess('Paid Amount Updated');
  }

  static Future<bool> deleteOrder(
    String orderId,
  ) async {
    EasyLoading.show(status: 'Deleting Order...');

    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('orders').doc(orderId).delete();
      EasyLoading.showSuccess('Order Deleted Successfully');
      return true;
    } on FirebaseException catch (e, st) {
      EasyLoading.showError(e.message ?? 'something went wrong');

      log(e.message.toString(), name: 'massage');

      log(st.toString(), name: 'stacktrace');
      return false;
    }
  }
}

final orderDetailsProvider =
    StreamProvider.family.autoDispose<OrderModel, String>((ref, docId) {
  final firestore = FirebaseFirestore.instance;

  final ref = firestore.collection('orders').doc(docId).snapshots();

  return ref.map((snapshot) => OrderModel.fromDocument(snapshot));
});

final ordersByUser =
    StreamProvider.family.autoDispose<List<OrderModel>, String>((ref, uid) {
  final firestore = FirebaseFirestore.instance;
  final snap = firestore
      .collection('orders')
      .where('user.uid', isEqualTo: uid)
      .snapshots();

  return snap.map((snapshot) =>
      snapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList());
});

class ExtLogic {
  static Color colorLog(String status) {
    switch (status) {
      case 'Pending':
        return Colors.yellow;
      case 'Processing':
        return Colors.orange;
      case 'Picked':
        return Colors.magenta;
      case 'Shipped':
        return Colors.teal;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'Duplicate':
        return Colors.red.darkest;
      default:
        return Colors.white;
    }
  }

  static int sortLogic(String status) {
    switch (status) {
      case 'Pending':
        return 1;
      case 'Processing':
        return 2;
      case 'Picked':
        return 3;
      case 'Shipped':
        return 4;
      case 'Delivered':
        return 5;
      case 'Cancelled':
        return 6;
      case 'Duplicate':
        return 7;
      default:
        return 1;
    }
  }
}

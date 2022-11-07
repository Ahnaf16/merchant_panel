import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/order/order_enums.dart';
import '../../app/order/order_model.dart';

final fromDate = StateProvider.autoDispose<DateTime>((ref) {
  final now = DateTime.now();
  final current = DateTime(now.year, now.month, now.day);
  return current;
});

final toDate = StateProvider.autoDispose<DateTime>((ref) {
  final now = DateTime.now();
  final current = DateTime(now.year, now.month, now.day);
  return current;
});

final selectedStatus = StateProvider.autoDispose<OrderStatus?>((ref) {
  return null;
});

final exportOrderList =
    StreamProvider.autoDispose<List<OrderModel>>((ref) async* {
  final fire = FirebaseFirestore.instance;
  final status = ref.watch(selectedStatus);

  final selectedTo = ref.watch(toDate);
  final to = DateTime(selectedTo.year, selectedTo.month, selectedTo.day).add(
    const Duration(days: 1),
  );

  final selectedFrom = ref.watch(fromDate);
  final from =
      DateTime(selectedFrom.year, selectedFrom.month, selectedFrom.day);

  final snap = fire
      .collection('orders')
      .where('orderDate', isGreaterThanOrEqualTo: from)
      .where('orderDate', isLessThanOrEqualTo: to)
      .where('status', isEqualTo: status?.toString())
      .orderBy('orderDate', descending: true)
      .snapshots();

  yield* snap.map(
    (snapshot) =>
        snapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList(),
  );
});

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_model.dart';

import '../../app/order/order_enums.dart';

final ordersPaginationProvider = StateNotifierProvider<OrderPaginationNotifier,
    AsyncValue<List<OrderModel>>>(
  (ref) {
    return OrderPaginationNotifier()..firstFetch();
  },
);

//

class OrderPaginationNotifier
    extends StateNotifier<AsyncValue<List<OrderModel>>> {
  OrderPaginationNotifier() : super(const AsyncValue.loading());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final int limit = 20;
  final searchCtrl = TextEditingController();
  final focus = FocusNode();

  void search() {
    final searchSnap = firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots();

    final searchByPhn = firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .where('address.billingNumber', isEqualTo: searchCtrl.text)
        .snapshots();

    if (searchCtrl.text.startsWith('01') && searchCtrl.text.length == 11) {
      final orders = searchByPhn.map((snapshot) =>
          snapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList());

      putData(orders);
    } else if (searchCtrl.text.startsWith('n/')) {
      final orders = searchSnap.map((snapshot) => snapshot.docs
          .where((DocumentSnapshot doc) {
            // final UserModel user = doc['user'];
            return doc['user']['displayName'].toString().toLowerCase().contains(
                  searchCtrl.text.replaceAll('n/', '').toLowerCase(),
                );
          })
          .map((doc) => OrderModel.fromDocument(doc))
          .toList());

      putData(orders);
    } else if (searchCtrl.text.startsWith('p/')) {
      final orders = searchSnap.map((snapshot) => snapshot.docs
          .where((DocumentSnapshot doc) {
            // final UserModel user = doc['user'];
            return doc['address']['billingNumber']
                .toString()
                .toLowerCase()
                .contains(
                  searchCtrl.text.replaceAll('p/', '').toLowerCase(),
                );
          })
          .map((doc) => OrderModel.fromDocument(doc))
          .toList());

      putData(orders);
    } else {
      final orders = searchSnap.map((snapshot) => snapshot.docs
          .where((DocumentSnapshot doc) {
            return doc['invoice'].toString().toLowerCase().contains(
                  searchCtrl.text.replaceAll('#', '').toLowerCase(),
                );
          })
          .map((doc) => OrderModel.fromDocument(doc))
          .toList());

      putData(orders);
    }
  }

  void filter({
    String? paySys,
    OrderStatus? status,
    DateTime? from,
    required DateTime to,
  }) async {
    final snap = firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .where('status', isEqualTo: status?.toString())
        .where('paymentMethod', isEqualTo: paySys == 'All' ? null : paySys)
        .where('orderDate', isGreaterThanOrEqualTo: from)
        .where('orderDate',
            isLessThanOrEqualTo: to.add(const Duration(days: 1)))
        .limit(limit)
        .snapshots();

    final orders = snap.map((snapshot) =>
        snapshot.docs.map((docs) => OrderModel.fromDocument(docs)).toList());
    putData(orders);
  }

  void firstFetch() async {
    final snap = firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .limit(limit)
        .snapshots();

    final orders = snap.map((snapshot) =>
        snapshot.docs.map((docs) => OrderModel.fromDocument(docs)).toList());
    putData(orders);
  }

  void loadMore(
    OrderModel last, {
    String? paySys,
    OrderStatus? status,
    DateTime? from,
    required DateTime to,
  }) async {
    final ref = firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .where('paymentMethod', isEqualTo: paySys == 'All' ? null : paySys)
        .where('status', isEqualTo: status?.toString())
        .where('orderDate', isGreaterThanOrEqualTo: from)
        .where('orderDate',
            isLessThanOrEqualTo: to.add(const Duration(days: 1)))
        .limit(limit)
        .startAfter([last.orderDate]).snapshots();

    final orders = ref.map((snap) =>
        snap.docs.map((docs) => OrderModel.fromDocument(docs)).toList());

    final List<OrderModel> stateItem = state.maybeWhen(
      data: (data) => data,
      orElse: () => List.empty(),
    );
    await for (final order in orders) {
      state = AsyncValue.data(stateItem + order);
    }
  }

  putData(Stream<List<OrderModel>> ordersStream) async {
    await for (final orders in ordersStream) {
      state = AsyncValue.data(orders);
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    focus.dispose();
    super.dispose();
  }
}

final orderStatusProvider = StreamProvider.family<int, String?>((ref, status) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  if (status != null) {
    final snap = firestore
        .collection('orders')
        .where('status', isEqualTo: status)
        .snapshots();

    final total = snap.map((snapshot) => snapshot.docs.length);

    return total;
  } else {
    final snap = firestore.collection('orders').snapshots();

    final total = snap.map((snapshot) => snapshot.docs.length);

    return total;
  }
});

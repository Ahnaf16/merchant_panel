import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/dash/model.dart';
import 'package:merchant_panel/app/order/order_enums.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/extension/extensions.dart';

final allOrderForChartProvider = FutureProvider<List<ChartModel>>((ref) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final chartDateRange = ref.watch(orderChartDateRangeProvider);

  final current = DateTime.now();
  // final current = DateTime(now.year, now.month, now.day);

  final statusList = OrderStatus.values
      .where((element) =>
          element == OrderStatus.picked ||
          element == OrderStatus.shipped ||
          element == OrderStatus.delivered)
      .toList()
      .map((e) => e.toString())
      .toList();

  try {
    final snap = await firestore
        .collection('orders')
        .where(
          'orderDate',
          isGreaterThanOrEqualTo: chartDateRange == 0
              ? null
              : current.subtract(
                  Duration(days: chartDateRange - 1),
                ),
        )
        .where(
          'orderDate',
          isLessThanOrEqualTo: chartDateRange == 0 ? null : current,
        )
        .where('status', whereIn: statusList)
        .orderBy('orderDate', descending: true)
        .get();

    final ordersList =
        snap.docs.map((doc) => OrderModel.fromDocument(doc)).toList();

    List<ChartModel> chartList = [];

    final groupeByDate = groupBy(
        ordersList, (OrderModel obj) => obj.orderDate.toDate().toFormatDate());

    groupeByDate.forEach((date, list) {
      chartList.add(
        ChartModel(
          groupedOrders: list,
        ),
      );
    });

    return chartList.reversed.toList();
  } on Exception catch (e) {
    EasyLoading.showError(e.toString());
    return List.empty();
  }
});

final orderChartDateRangeProvider = StateProvider<int>((ref) {
  return 30;
});

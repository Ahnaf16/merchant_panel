// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:collection/collection.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/extension/extensions.dart';

class ChartModel {
  ChartModel({
    required List<OrderModel> groupedOrders,
  })  : date = groupedOrders.first.orderDate.toDate(),
        totalCashAmount = groupedOrders.fold(0, (a, b) => a + b.total),
        productSold = groupedOrders.length,
        bKashProductSold = groupedOrders.matchPayment('Bkash').length,
        bkashSaleAmount = groupedOrders
            .matchPayment('Bkash')
            .toList()
            .fold(0, (previousValue, element) => previousValue + element.total),
        nagadProductSold = groupedOrders.matchPayment('Nagad').length,
        nagadSaleAmount = groupedOrders
            .matchPayment('Nagad')
            .toList()
            .fold(0, (previousValue, element) => previousValue + element.total),
        codProductSold = groupedOrders.matchPayment('COD').length,
        codSaleAmount = groupedOrders
            .matchPayment('COD')
            .toList()
            .fold(0, (previousValue, element) => previousValue + element.total),
        otherProductSold = groupedOrders.matchPayment('Not Selected').length,
        otherSaleAmount = groupedOrders
            .matchPayment('Not Selected')
            .fold(0, (previousValue, element) => previousValue + element.total),
        pieData = groupBy(groupedOrders, (OrderModel obj) => obj.paymentMethod);

  final int bKashProductSold;
  final int bkashSaleAmount;
  final int codProductSold;
  final int codSaleAmount;
  final DateTime date;
  final int nagadProductSold;
  final int nagadSaleAmount;
  final int otherProductSold;
  final int otherSaleAmount;
  final Map<String, List<OrderModel>> pieData;
  final int productSold;
  final int totalCashAmount;

  @override
  String toString() {
    return 'ChartModel(date: $date, productSold: $productSold, saleAmountDay: $totalCashAmount, bKashProductSold: $bKashProductSold, bkashSaleAmount: $bkashSaleAmount, nagadProductSold: $nagadProductSold, nagadSaleAmount: $nagadSaleAmount, codProductSold: $codProductSold, codSaleAmount: $codSaleAmount, otherProductSold: $otherProductSold, otherSaleAmount: $otherSaleAmount)';
  }
}

extension ChartEx on ChartModel {
  List<PieChartModel> get toPieData {
    List<PieChartModel> pieData = [];
    this.pieData.forEach(
      (key, value) {
        pieData.add(
          PieChartModel(
            paymentMethod: value.first.paymentMethod,
            cashAmount: value.fold(
              0,
              (previousValue, element) => previousValue + element.total,
            ),
            count: value.length,
          ),
        );
      },
    );

    return pieData;
  }
}

class PieChartModel {
  PieChartModel({
    required this.paymentMethod,
    required this.cashAmount,
    required this.count,
  }) : color = colorOf(paymentMethod);

  final int cashAmount;
  final Color color;
  final int count;
  final String paymentMethod;

  @override
  String toString() => '''\nPieChartModel(
         paymentMethod: $paymentMethod,
         cashAmount: $cashAmount, 
         count: $count
         )''';

  static Color colorOf(String method) {
    switch (method) {
      case 'Bkash':
        return const Color(0xffdf146e);
      case 'Nagad':
        return const Color(0xfff39120);
      case 'COD':
        return const Color.fromARGB(255, 49, 160, 91);

      default:
        return const Color.fromARGB(190, 170, 170, 170);
    }
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'order_enums.dart';

List<String> get getOrderStatusList => [
      'Pending',
      'Processing',
      'Picked',
      'Shipped',
      'Delivered',
      'Cancelled',
    ];

List<Color> get getStatusCOlor => [
      Colors.yellow.darker,
      Colors.orange,
      Colors.magenta,
      Colors.teal,
      Colors.green,
      Colors.red,
    ];

final paymentMethodList = Provider<List<String>>((ref) {
  return [
    'All',
    'Not Selected',
    'Bkash',
    'Nagad',
    'COD',
    'SSL',
  ];
});

final exportDates = Provider<List<int>>((ref) {
  return [
    1,
    7,
    30,
  ];
});

final columnTitlesProvider = Provider<List<String>>((ref) {
  return [
    'No',
    'INVOICE',
    'Name',
    'Contact',
    'Total',
    'Note',
    'Mathod',
    'Status',
    'Date',
  ];
});

extension OrderEx on String {
  Widget toIcon() {
    if (this == 'Bkash') {
      return Image.asset(
        'assets/misc/bkash1.png',
        height: 30,
        width: 30,
        fit: BoxFit.cover,
      );
    } else if (this == 'Nagad') {
      return Image.asset(
        'assets/misc/nagad1.png',
        height: 30,
        width: 30,
        fit: BoxFit.cover,
      );
    } else if (this == 'COD') {
      return Container(
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(5)),
        child: Text(
          'COD',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 5,
          ),
        ),
      );
    } else if (this == 'SSL') {
      return Image.asset(
        'assets/misc/ssl.png',
        height: 30,
        width: 30,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(
        MdiIcons.progressQuestion,
        size: 20,
        color: Colors.grey[100],
      );
    }
  }
}

final selectedExportDateProvider = StateProvider<int>((ref) {
  return 0;
});

final selectedPaymentMathod = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final selectedOrderStatus = StateProvider.autoDispose<OrderStatus?>((ref) {
  return null;
});

final selectedOrderStatsUpdate = StateProvider.autoDispose<OrderStatus?>((ref) {
  return null;
});

final orderStatusComment = StateProvider.autoDispose<String>((ref) {
  return '';
});

final paidAmountCtrl = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final addedToSheet = StateProvider<bool>((ref) {
  return false;
});

final selectedFromDate = StateProvider.autoDispose<DateTime?>((ref) {
  // final now = DateTime.now();
  // final current = DateTime(now.year, now.month, now.day);

  return null;
});

final selectedToDate = StateProvider.autoDispose<DateTime>((ref) {
  final now = DateTime.now();
  final current = DateTime(now.year, now.month, now.day);

  return current;
});

final openPdfProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

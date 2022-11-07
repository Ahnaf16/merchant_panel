import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:intl/intl.dart';

extension IntOperations on int {
  String toCurrency({bool useName = false}) {
    return NumberFormat.currency(
      locale: 'en_BD',
      symbol: useName ? null : '৳',
      name: useName ? 'BDT ' : null,
      decimalDigits: 0,
      customPattern: '${useName ? 'BDT ' : '৳'} ##,##,##,##,###',
    ).format(this);
  }
}

extension Calculations on int {
  String discountPercent(int discount) {
    return '${((this - discount) / this * 100).round()}%';
  }
}

extension TimestampFormat on Timestamp {
  String toFormatDate([String pattern = 'dd-MM-yyyy']) {
    return DateFormat(pattern).format(toDate());
  }
}

extension DateTimeFormat on DateTime {
  String toFormatDate([String pattern = 'dd-MM-yyyy']) {
    return DateFormat(pattern).format(this);
  }
}

extension Convert on String {
  int get asInt {
    if (isEmpty) {
      return 0;
    } else {
      return int.parse(this);
    }
  }

  double get asDouble {
    if (isEmpty) {
      return 0.0;
    } else {
      return double.parse(this);
    }
  }

  String showUntil(int end, [int start = 0]) {
    if (length >= end) {
      return '${substring(start, end)}...';
    } else {
      return this;
    }
  }

  String ifEmpty([String? emptyText = 'Empty']) {
    if (isEmpty) {
      return '$emptyText';
    } else {
      return this;
    }
  }
}

extension StringValidation on String {
  bool get isEmail {
    final emailRegEx = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailRegEx.hasMatch(this);
  }

  bool get isPhnNum {
    final regEx = RegExp(r'\d');
    if (startsWith('01') && length == 11 && regEx.hasMatch(this)) {
      return true;
    }
    return false;
  }
}

extension OrderExt on List<OrderModel> {
  List<OrderModel> matchPayment(
    Object match,
  ) {
    return where((element) => element.paymentMethod == match).toList();
  }
}

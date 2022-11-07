import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherModel {
  VoucherModel({
    required this.createDate,
    required this.expireDate,
    required this.customerId,
    required this.title,
    required this.amount,
    required this.code,
    required this.isUsed,
    required this.isExpired,
    required this.minimumSpend,
    required this.type,
    this.usedBy = 0,
    this.couponType = CouponType.alphabetic,
  });

  final int amount;
  final String code;
  final DateTime createDate;
  final String customerId;
  final DateTime expireDate;
  final bool isExpired;
  final bool isUsed;
  final int minimumSpend;
  final String title;
  final VoucherType? type;
  final int usedBy;
  final CouponType couponType;

  factory VoucherModel.fromDoc(DocumentSnapshot doc) {
    final Timestamp create = doc['createDate'];
    final Timestamp expire = doc['expireDate'];
    final String type = doc['type'];
    return VoucherModel(
      createDate: create.toDate(),
      expireDate: expire.toDate(),
      customerId: doc['customerId'] as String,
      title: doc['title'] as String,
      amount: doc['amount'] as int,
      code: doc['code'] as String,
      isUsed: doc['isUsed'] as bool,
      isExpired: doc['isExpired'] as bool,
      minimumSpend: doc['minimumSpend'] as int,
      type: VoucherType.fromString(type),
      usedBy: doc['usedBy'],
    );
  }

  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    final Timestamp create = map['createDate'];
    final Timestamp expire = map['expireDate'];
    final String type = map['type'];

    return VoucherModel(
      createDate: create.toDate(),
      expireDate: expire.toDate(),
      customerId: map['customerId'] as String,
      title: map['title'] as String,
      amount: map['amount'] as int,
      code: map['code'] as String,
      isUsed: map['isUsed'] as bool,
      isExpired: map['isExpired'] as bool,
      minimumSpend: map['minimumSpend'] as int,
      type: VoucherType.fromString(type),
      usedBy: map['usedBy'],
    );
  }

  @override
  String toString() {
    return 'VoucherModel(createDate: $createDate, expireDate: $expireDate, customerId: $customerId, title: $title, amount: $amount, code: $code, isUsed: $isUsed, isExpired: $isExpired, minimumSpend: $minimumSpend, type: $type, usedBy: $usedBy)';
  }

  VoucherModel copyWith(
      {DateTime? createDate,
      DateTime? expireDate,
      String? customerId,
      String? title,
      int? amount,
      String? code,
      bool? isUsed,
      bool? isExpired,
      int? minimumSpend,
      VoucherType? type,
      int? usedBy,
      CouponType? couponType}) {
    return VoucherModel(
      createDate: createDate ?? this.createDate,
      expireDate: expireDate ?? this.expireDate,
      customerId: customerId ?? this.customerId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      code: code ?? this.code,
      isUsed: isUsed ?? this.isUsed,
      isExpired: isExpired ?? this.isExpired,
      minimumSpend: minimumSpend ?? this.minimumSpend,
      type: type ?? this.type,
      usedBy: usedBy ?? this.usedBy,
      couponType: couponType ?? this.couponType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createDate': createDate,
      'expireDate': expireDate,
      'customerId': customerId,
      'title': title,
      'amount': amount,
      'code': code,
      'isUsed': isUsed,
      'isExpired': isExpired,
      'minimumSpend': minimumSpend,
      'type': type?.name,
      'usedBy': usedBy,
    };
  }
}

enum VoucherType {
  global,
  individual,
  singleUse;

  factory VoucherType.fromString(String type) {
    if (type == 'global') {
      return VoucherType.global;
    } else if (type == 'singleUse') {
      return VoucherType.singleUse;
    } else {
      return VoucherType.individual;
    }
  }
}

enum CouponType {
  alphabetic('abd'),
  numeric_9('9'),
  numeric_16('16');

  final String text;
  const CouponType(this.text);
}

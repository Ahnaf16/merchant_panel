import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/setting/users/user_model.dart';
import 'package:nanoid/nanoid.dart';
import 'package:merchant_panel/extension/extensions.dart';
import '../../app/voucher/voucher_model.dart';

final voucherProvider =
    StateNotifierProvider.autoDispose<VoucherNotifier, VoucherModel>((ref) {
  final VoucherModel voucher = VoucherModel(
    createDate: DateTime.now(),
    expireDate: DateTime.now().add(const Duration(days: 7)),
    customerId: '',
    title: '',
    amount: 0,
    code: '',
    isUsed: false,
    isExpired: false,
    minimumSpend: 1,
    type: null,
  );
  return VoucherNotifier(voucher)..generateCode();
});

class VoucherNotifier extends StateNotifier<VoucherModel> {
  VoucherNotifier(VoucherModel voucher) : super(voucher);

  final amountCtrl = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();
  final fire = FirebaseFirestore.instance;
  final minimumSpend = TextEditingController();
  final titleCtrl = TextEditingController(text: 'Gift Voucher');

  List<String> amountDropDown = const [
    '1',
    '50',
    '100',
    '150',
    '200',
    '250',
    '500',
    '1000',
    '2000',
  ];
  @override
  void dispose() {
    titleCtrl.dispose();
    amountCtrl.dispose();
    codeCtrl.dispose();
    minimumSpend.dispose();
    super.dispose();
  }

  setCreateDate(DateTime createDate) {
    state = state.copyWith(createDate: createDate);
  }

  setExpireDate(DateTime expireDate) {
    state = state.copyWith(expireDate: expireDate);
  }

  setVoucherType(VoucherType type) {
    if (type == VoucherType.singleUse) {
      generateCode(16);
      state = state.copyWith(type: type);
    } else {
      generateCode();
      state = state.copyWith(type: type);
    }
  }

  generateCode([length = 9]) {
    String code() {
      if (state.couponType == CouponType.numeric_9) {
        return customAlphabet('0123456789', 9);
      } else if (state.couponType == CouponType.numeric_16) {
        return customAlphabet('0123456789', 16);
      } else {
        return nanoid(length);
      }
    }

    codeCtrl = TextEditingController(text: code());
    state = state.copyWith(code: code());
  }

  changeCouponType(CouponType type) {
    state = state.copyWith(couponType: type);

    generateCode();
  }

  set({String? userID}) {
    state = state.copyWith(
      title: titleCtrl.text,
      amount: amountCtrl.text.asInt,
      customerId: userID,
      minimumSpend: minimumSpend.text.asInt,
      code: codeCtrl.text,
    );
  }

  individualVoucherList(UserModel user) async {
    try {
      await set(userID: user.uid);
      state = state.copyWith(usedBy: 1);
      if (state.type == null) {
        EasyLoading.showError('Select a type');
      } else if (state.type != VoucherType.individual) {
        EasyLoading.showError('Invalid Voucher type');
      } else if (titleCtrl.text.isEmpty) {
        EasyLoading.showError('Title is Empty');
      } else if (amountCtrl.text.isEmpty) {
        EasyLoading.showError('Amount is Empty');
      } else if (minimumSpend.text.isEmpty) {
        EasyLoading.showError('Min. Spend is Empty');
      } else if (state.expireDate.isBefore(state.createDate)) {
        EasyLoading.showError(
            'Initial ExpireDate can\'t be smaller then CreateDate');
      } else {
        EasyLoading.show();

        final ref = fire
            .collection('inApp')
            .doc('vouchers')
            .collection('IndividualVoucher')
            .doc(state.code);

        await ref.set(state.toMap());

        await uploadToUser(user);

        EasyLoading.showSuccess('Voucher sent to\n${user.displayName}');
      }
    } on FirebaseException catch (err, st) {
      EasyLoading.showError('error :\n$err');
      debugPrint('where: [uploadToMainVoucher] \n error : $err \n st : $st');
    }
  }

  uploadToUser(UserModel user) async {
    try {
      final userRef = fire
          .collection('users')
          .doc(user.uid)
          .collection('voucher')
          .doc(state.code);

      await userRef.set(state.toMap());

      await fire.collection('users').doc(user.uid).update({
        'voucherCount': FieldValue.increment(1),
      });
    } on FirebaseException catch (err, st) {
      EasyLoading.showError('error :\n$err');
      debugPrint('where: [uploadToUser] \n error : $err \n st : $st');
    }
  }

  uploadGlobalVoucher() async {
    try {
      await set();
      if (state.type == null) {
        EasyLoading.showError('Select a type');
      } else if (state.type == VoucherType.individual) {
        EasyLoading.showError('Invalid Voucher type');
      } else if (state.code.isEmpty || codeCtrl.text.isEmpty) {
        EasyLoading.showError('Code is Empty');
      } else if (titleCtrl.text.isEmpty) {
        EasyLoading.showError('Title is Empty');
      } else if (amountCtrl.text.isEmpty) {
        EasyLoading.showError('Amount is Empty');
      } else if (minimumSpend.text.isEmpty) {
        EasyLoading.showError('Min. Spend is Empty');
      } else if (state.expireDate.isBefore(state.createDate)) {
        EasyLoading.showError(
            'Initial ExpireDate can\'t be smaller then CreateDate');
      } else {
        EasyLoading.show();
        final ref = fire
            .collection('inApp')
            .doc('vouchers')
            .collection('global')
            .doc(state.code);

        await ref.set(state.toMap());

        EasyLoading.showSuccess('Global Voucher Added');
      }
    } on FirebaseException catch (err, st) {
      EasyLoading.showError('error :\n$err');
      debugPrint('where: [uploadToMainVoucher] \n error : $err \n st : $st');
    }
  }

  deleteVoucher(VoucherModel voucher) async {
    try {
      if (voucher.type == VoucherType.individual) {
        EasyLoading.show();
        final ref = fire
            .collection('inApp')
            .doc('vouchers')
            .collection('IndividualVoucher')
            .doc(voucher.code);

        final userRef = fire
            .collection('users')
            .doc(voucher.customerId)
            .collection('voucher')
            .doc(voucher.code);

        await ref.delete();
        await userRef.delete();
        EasyLoading.showSuccess('Individual Voucher Deleted');
      } else {
        EasyLoading.show();
        final ref = fire
            .collection('inApp')
            .doc('vouchers')
            .collection('global')
            .doc(voucher.code);

        await ref.delete();
        EasyLoading.showSuccess('Globle Voucher Deleted');
      }
    } on FirebaseException catch (err, st) {
      EasyLoading.showError('error :\n$err');
      debugPrint('where: [deleteVoucher] \n error : $err \n st : $st');
    }
  }

  markAsExpired(VoucherModel voucher) async {
    try {
      if (voucher.type == VoucherType.individual) {
        EasyLoading.show();
        final ref = fire
            .collection('inApp')
            .doc('vouchers')
            .collection('IndividualVoucher')
            .doc(voucher.code);

        final userRef = fire
            .collection('users')
            .doc(voucher.customerId)
            .collection('voucher')
            .doc(voucher.code);

        await ref.update({
          'isExpired': !voucher.isExpired,
        });
        await userRef.update({
          'isExpired': !voucher.isExpired,
        });
        EasyLoading.showSuccess('Voucher Expired State Changed');
      } else {
        EasyLoading.showError('Global voucher can\'t be Expired');
      }
    } on FirebaseException catch (err, st) {
      EasyLoading.showError('error :\n$err');
      debugPrint('where: [markAsExpired] \n error : $err \n st : $st');
    }
  }

  reset() {
    titleCtrl.clear();
    amountCtrl.clear();
    minimumSpend.clear();
    state = VoucherModel(
      createDate: DateTime.now(),
      expireDate: DateTime.now().add(const Duration(days: 7)),
      customerId: '',
      title: '',
      amount: 0,
      code: '',
      isUsed: false,
      isExpired: false,
      minimumSpend: 1,
      type: null,
    );
    generateCode();
  }
}

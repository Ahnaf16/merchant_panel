import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/voucher/voucher_model.dart';

final voucherPaginationProvider = StateNotifierProvider.family.autoDispose<
    VoucherPaginationNotifier, AsyncValue<List<VoucherModel>>, VoucherType>(
  (ref, type) {
    return VoucherPaginationNotifier(type)..firstFetch();
  },
);

//

class VoucherPaginationNotifier
    extends StateNotifier<AsyncValue<List<VoucherModel>>> {
  VoucherPaginationNotifier(this.type) : super(const AsyncValue.loading());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final int limit = 12;
  final VoucherType type;

  void firstFetch() async {
    try {
      final ref = firestore
          .collection('inApp')
          .doc('vouchers')
          .collection('IndividualVoucher')
          .orderBy('isUsed')
          .orderBy('createDate', descending: true)
          .limit(limit);

      final refGlobal = firestore
          .collection('inApp')
          .doc('vouchers')
          .collection('global')
          .where('type', isEqualTo: type.name)
          .orderBy('createDate', descending: true)
          .limit(limit);

      final snap = type != VoucherType.individual
          ? refGlobal.snapshots()
          : ref.snapshots();

      final vouchers = snap.map((snapshot) =>
          snapshot.docs.map((docs) => VoucherModel.fromDoc(docs)).toList());

      putData(vouchers);
    } on FirebaseException catch (error, st) {
      state = AsyncValue.error(error, st);
    } catch (error, st) {
      state = AsyncValue.error(error, st);
    }
  }

  void nextPage(VoucherModel last) async {
    final ref = firestore
        .collection('inApp')
        .doc('vouchers')
        .collection('IndividualVoucher')
        .orderBy('createDate', descending: true)
        .startAfter([last.createDate]).limit(limit);

    final refGlobal = firestore
        .collection('inApp')
        .doc('vouchers')
        .collection('global')
        .where('type', isEqualTo: type.name)
        .orderBy('createDate', descending: true)
        .startAfter([last.createDate]).limit(limit);

    final snap = type != VoucherType.individual
        ? refGlobal.snapshots()
        : ref.snapshots();

    final vouchers = snap.map((snapshot) =>
        snapshot.docs.map((docs) => VoucherModel.fromDoc(docs)).toList());

    putData(vouchers);
  }

  putData(Stream<List<VoucherModel>> voucherStream) async {
    final List<VoucherModel> stateItem = state.maybeWhen(
      data: (data) => data,
      orElse: () => List.empty(),
    );

    await for (final voucher in voucherStream) {
      state = AsyncValue.data(stateItem + voucher);
    }
  }
}

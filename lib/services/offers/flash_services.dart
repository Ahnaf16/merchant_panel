import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:merchant_panel/app/flash/flash_model.dart';

class FlashServices {
  static addFlash({
    required List<FlashModel> flash,
  }) async {
    EasyLoading.show(status: 'Adding Flash');
    final firestore = FirebaseFirestore.instance;

    for (final item in flash) {
      final flashRef = firestore
          .collection('flash')
          .doc('flash')
          .collection('flash')
          .doc(item.id);
      await flashRef.set(item.toJson());
    }

    EasyLoading.showSuccess('Flash Added');
  }

  static deleteFlash({
    required String flashId,
  }) async {
    EasyLoading.show(status: 'Deleting Flash');
    final firestore = FirebaseFirestore.instance;

    final flashRef = firestore
        .collection('flash')
        .doc('flash')
        .collection('flash')
        .doc(flashId);

    await flashRef.delete();

    EasyLoading.showSuccess('Flash Deleted');
  }
}

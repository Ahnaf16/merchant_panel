import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/slider/slider_model.dart';

final sliderImgProvider = StreamProvider.autoDispose<List<SliderModel>>((ref) {
  final fire = FirebaseFirestore.instance;
  final snap = fire.collection('slider').snapshots();
  return snap.map((snapshot) {
    return snapshot.docs.map((doc) {
      return SliderModel.fromDoc(doc);
    }).toList();
  });
});

final sliderServicesProvider = Provider<SliderPrvider>((ref) {
  return SliderPrvider();
});

class SliderPrvider {
  final fire = FirebaseFirestore.instance;

  Future<void> addImg(SliderModel slider) async {
    EasyLoading.show(status: 'Adding...');

    await fire.collection('slider').doc(slider.id).set(slider.toMap());

    EasyLoading.showSuccess('Added');
  }

  Future<void> deleteImg(String id) async {
    EasyLoading.show(status: 'Deleting...');
    await fire.collection('slider').doc(id).delete();
    EasyLoading.showSuccess('Deleted');
  }
}

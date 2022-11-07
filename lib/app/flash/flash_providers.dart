import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/flash/flash_model.dart';

final flashProvider = StreamProvider<List<FlashModel>>((ref) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final snap = firestore
      .collection("flash")
      .doc('flash')
      .collection('flash')
      .snapshots();
  return snap.map(
    (snapshot) {
      return snapshot.docs.map((doc) {
        return FlashModel.fromDocument(doc);
      }).toList();
    },
  );
});

class SelectedFlashItem extends StateNotifier<List<FlashModel>> {
  SelectedFlashItem() : super([]);
  void add(FlashModel item) {
    if (state.any((element) => element.id == item.id)) {
      return;
    }
    state = [...state, item];
  }

  void remove(int index) {
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void clear() {
    state = [];
  }

  bool doseContains(String id) {
    return state.any((item) => item.id == id);
  }
}

final selectedFlashItemsNotifier =
    StateNotifierProvider.autoDispose<SelectedFlashItem, List<FlashModel>>(
        (ref) {
  return SelectedFlashItem();
});

final flashPriceProvider = StateProvider<int>((ref) {
  return 0;
});

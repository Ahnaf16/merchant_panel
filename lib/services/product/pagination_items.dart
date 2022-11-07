import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/product_model.dart';

final itemsProviderNew = StateNotifierProvider.autoDispose<
    ItemPaginationNotifierNew, AsyncValue<List<ProductModel>>>((ref) {
  return ItemPaginationNotifierNew()..firstFetch();
});

class ItemPaginationNotifierNew
    extends StateNotifier<AsyncValue<List<ProductModel>>> {
  ItemPaginationNotifierNew() : super(const AsyncValue.loading());

  final int limit = 20;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final searchCtrl = TextEditingController();

  filter(String? category) {
    final ref = firestore
        .collection('items')
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots();

    final items = ref.map((snapshot) =>
        snapshot.docs.map((docs) => ProductModel.fromDocument(docs)).toList());

    putData(items);
  }

  search() {
    final ref = firestore
        .collection('items')
        .orderBy('date', descending: true)
        .snapshots();

    final items = ref.map(
      (snapshot) => snapshot.docs
          .where(
            (DocumentSnapshot doc) => doc['name']
                .toString()
                .toLowerCase()
                .replaceAll(' ', '')
                .contains(
                  searchCtrl.text.toLowerCase().replaceAll(' ', ''),
                ),
          )
          .map((DocumentSnapshot doc) => ProductModel.fromDocument(doc))
          .toList(),
    );

    putData(items);
  }

  firstFetch() async {
    final itemRef = firestore
        .collection('items')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots();

    final items = itemRef.map((snapshot) =>
        snapshot.docs.map((docs) => ProductModel.fromDocument(docs)).toList());

    putData(items);
  }

  void loadMore(
    ProductModel last, {
    String? category,
  }) async {
    final ref = firestore
        .collection('items')
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .limit(limit)
        .startAfter([last.date]).snapshots();

    final items = ref.map((snap) =>
        snap.docs.map((docs) => ProductModel.fromDocument(docs)).toList());

    final List<ProductModel> stateItem = state.maybeWhen(
      data: (data) => data,
      orElse: () => List.empty(),
    );
    await for (final order in items) {
      state = AsyncValue.data(stateItem + order);
    }
  }

  putData(Stream<List<ProductModel>> productStream) async {
    await for (final items in productStream) {
      state = AsyncValue.data(items);
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/product_model.dart';

class ProductServices {
  static addProducts({required ProductModel product}) async {
    EasyLoading.show(status: 'Adding Product');
    final firestore = FirebaseFirestore.instance;

    final ref = firestore.collection('items');

    await ref.add(product.toJson());

    EasyLoading.showSuccess('Product Added');
  }

  static updateProducts({required ProductModel product}) async {
    EasyLoading.show(status: 'Updating Product');
    final firestore = FirebaseFirestore.instance;

    final ref = firestore.collection('items').doc(product.id);

    await ref.update(product.toJson());

    EasyLoading.showSuccess('Product Updated');
  }

  static deleteProducts({required ProductModel product}) async {
    EasyLoading.show(status: 'Deleting Product');
    final firestore = FirebaseFirestore.instance;

    final ref = firestore.collection('items');

    await ref.doc(product.id).delete();

    EasyLoading.showSuccess('Product Deleted');
  }

  static updatePrice({required ProductModel product}) async {
    EasyLoading.show(status: 'Price updating');

    final firestore = FirebaseFirestore.instance;

    final ref = firestore.collection('items');

    await ref.doc(product.id).update(product.toJson());

    EasyLoading.showSuccess('Price Updated');
  }

  static stockChange({required ProductModel product}) async {
    EasyLoading.show(status: 'Changing Stock');
    final firestore = FirebaseFirestore.instance;

    final ref = firestore.collection('items');

    await ref.doc(product.id).update({
      'inStock': !product.inStock,
    });

    EasyLoading.showSuccess('Product Stock Changed');
  }

  static changePriority({
    required ProductModel product,
    required bool isIncrement,
  }) async {
    EasyLoading.show(status: 'Changing Priority');
    final firestore = FirebaseFirestore.instance;

    final ref = firestore.collection('items');

    await ref.doc(product.id).update({
      'preority':
          isIncrement ? FieldValue.increment(1) : FieldValue.increment(-1),
    });

    EasyLoading.showSuccess('Priority Changed');
  }
}

final singleItemProvider =
    StreamProvider.autoDispose.family<ProductModel, String>((ref, itemID) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ref = firestore.collection('items').doc(itemID);
  final doc = ref.snapshots();
  final itemStream = doc.map((snapshot) => ProductModel.fromDocument(snapshot));
  return itemStream;
});

final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

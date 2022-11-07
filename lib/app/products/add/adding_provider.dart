import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/product_model.dart';

import '../../../services/image_services.dart';

final discountSwitchProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final inStockProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final categoryCtrl = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final brandListProvider = Provider<List>((ref) {
  return [
    'Apple',
    'Samsung',
    'Google',
    'Sony',
    'OnePlus',
    'Xiaomi',
    'Realme',
    'Tecno',
    'Infinix'
  ];
});

class SpecificationNotifier extends StateNotifier<Map<String, String>> {
  SpecificationNotifier() : super({});

  void addSpecification(String specText) {
    state = {
      ...state,
      specText.substring(0, specText.indexOf('~')):
          specText.substring(specText.indexOf('~') + 1)
    };
  }

  void removeSpecification(String key) {
    state = {...state, key: ''};
    state.remove(key);
  }

  void clear() {
    state = {};
  }
}

final specificationProvider = StateNotifierProvider.autoDispose<
    SpecificationNotifier, Map<String, String>>((ref) {
  return SpecificationNotifier();
});

//.........................

class AddProductsNotifier extends StateNotifier<ProductModel?> {
  AddProductsNotifier({
    required this.images,
    required this.specification,
  }) : super(null);

  final SelectImage images;
  final SpecificationNotifier specification;

  final nameC = TextEditingController();
  final brandC = TextEditingController();
  final desC = TextEditingController();
  final priceC = TextEditingController();
  final discountC = TextEditingController();
  final specificationC = TextEditingController();
  final searchQuarryC = TextEditingController();

  void clear() {
    nameC.clear();
    brandC.clear();
    desC.clear();
    priceC.clear();
    discountC.clear();
    specificationC.clear();
    images.clearImagePath();
    specification.clear();
  }

  @override
  void dispose() {
    nameC.dispose();
    brandC.dispose();
    desC.dispose();
    priceC.dispose();
    discountC.dispose();
    specificationC.dispose();
    searchQuarryC.dispose();
    super.dispose();
  }
}

final fieldCtrlProvider =
    StateNotifierProvider<AddProductsNotifier, ProductModel?>((ref) {
  final imgs = ref.read(imgSelectionProvider.notifier);
  final spec = ref.read(specificationProvider.notifier);

  return AddProductsNotifier(
    images: imgs,
    specification: spec,
  );
});

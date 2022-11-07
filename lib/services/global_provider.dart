import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryListProvider = Provider.autoDispose<List<String>>((ref) {
  return [
    'Smart Phone',
    'Pre Owned Devices',
    'Feature phone',
    'Apple Gadget',
    'Smart Watch',
    'Analog Watch',
    'Head Phone',
    'Wire Earphone',
    'Neckband',
    'TWS',
    'Adapter & Cable',
    'Power Bank',
    'Sound Box',
    'Smart TV',
    'Router',
    'Leptop',
    'Computer & Accessories',
    'Smart Gadget',
    'Others',
  ];
});

final selectedCategory = StateProvider<String?>((ref) {
  return null;
});

final pinIconProvider = StateProvider<bool>((ref) {
  return false;
});

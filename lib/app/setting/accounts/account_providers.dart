import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedRoleProvider = StateProvider<int>((ref) {
  final rolesList = ref.watch(rolesListProvider);
  return rolesList.indexOf('monitor');
});

final rolesListProvider = Provider<List<String>>((ref) {
  return [
    'admin',
    'dev',
    'productManager',
    'orderManager',
    'monitor',
  ];
});

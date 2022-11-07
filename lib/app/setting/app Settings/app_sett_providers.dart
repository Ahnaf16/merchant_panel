import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/layout_manager.dart';

//
final savedIndexPage = StateProvider<String>((ref) {
  return 'Dashboard';
});

final naviIndexProvider =
    StateNotifierProvider<WebNavigationIndexNotifier, int>((ref) {
  return WebNavigationIndexNotifier(ref)..init();
});

//

class WebNavigationIndexNotifier extends StateNotifier<int> {
  WebNavigationIndexNotifier(this.ref) : super(0);

  final Ref ref;

  init() async {
    final pref = await SharedPreferences.getInstance();

    final savedInt = pref.getInt('navigationIndex');

    state = savedInt ?? 0;

    ref.read(savedIndexPage.notifier).state = navTitles[state];
  }

  void setIndex(int index) {
    state = index;
  }

  void saveIndex(String page) async {
    final pref = await SharedPreferences.getInstance();

    pref.setInt('navigationIndex', navTitles.indexOf(page));
    log('savePage: $page');

    ref.read(savedIndexPage.notifier).state = page;
  }

  bool isPined(String page) {
    return page == navTitles[state];
  }
}

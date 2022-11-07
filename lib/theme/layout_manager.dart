// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/campaign/campaign_list.dart';
import 'package:merchant_panel/app/order/order_list.dart';
import 'package:merchant_panel/app/setting/settings_page.dart';
import 'package:merchant_panel/app/slider/slider.dart';
import 'package:merchant_panel/app/voucher/voucher.dart';

import '../app/dash/dashboard.dart';
import '../app/flash/flash_page.dart';
import '../app/newsfeed/newsfeed.dart';
import '../app/products/add/add_products.dart';
import '../app/products/products_page.dart';

final layoutProvider = Provider.family<AppLayout, BuildContext>((ref, context) {
  return AppLayout(context);
});

class AppLayout {
  AppLayout(this.context);

  final BuildContext context;

  Platforms get getLayout {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 640) {
      return Platforms.smallScreen;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Platforms.android;
    }
    if (kIsWeb || screenWidth > 640) {
      return Platforms.web;
    }
    return Platforms.web;
  }

  bool get isSmallScreen {
    return getLayout == Platforms.smallScreen || getLayout == Platforms.android;
  }

  bool get isAndroid {
    return getLayout == Platforms.android;
  }
}

enum Platforms {
  web,
  smallScreen,
  android,
}

List<NavigationPaneItem> paneItems = [
  PaneItem(
    icon: const Icon(FluentIcons.view_dashboard),
    title: const Text('Dashboard'),
    body: const Dash(),
  ),
];

class NavigationItems extends NavigationPaneItem {
  final String title;
  final IconData icon;
  final Widget body;

  NavigationItems({
    required this.title,
    required this.icon,
    required this.body,
  });
}

final navItemProvider = Provider.autoDispose<List>((ref) {
  // final uid = getUser?.uid;
  // final roles = ref.watch(roleProvider(uid));

  return [
    NavigationItems(
      title: 'Dashboard',
      icon: FluentIcons.view_dashboard,
      body: const Dash(),
    ),
    const SizedBox(),
    NavigationItems(
      title: 'Product',
      icon: FluentIcons.product_list,
      body: const AllProductsPage(),
    ),
    NavigationItems(
      title: 'Add Product',
      icon: FluentIcons.add_in,
      body: const AddProducts(),
    ),
    const SizedBox(),
    NavigationItems(
      title: 'Orders',
      icon: FluentIcons.activate_orders,
      body: const OrderList(),
    ),
    const SizedBox(),
    NavigationItems(
      title: 'Campaign',
      icon: FluentIcons.campaign_template,
      // body: roles.canAddOffers() ? const Campaign() : const NoAccessPage(),
      body: const Campaign(),
    ),
    NavigationItems(
      title: 'Flash',
      icon: FluentIcons.lightning_bolt,
      body: const FlashPage(),
      // body: roles.canAddOffers() ? const FlashPage() : const NoAccessPage(),
    ),
    const SizedBox(),
    NavigationItems(
      title: 'Newsfeed',
      icon: FluentIcons.news,
      body: const News(),
      // body: roles.canAddOffers() ? const News() : const NoAccessPage(),
    ),
    NavigationItems(
      title: 'Slider',
      icon: FluentIcons.image_pixel,
      body: const SliderPage(),
      // body: roles.canAddOffers() ? const SliderPage() : const NoAccessPage(),
    ),
    const SizedBox(),
    NavigationItems(
      title: 'Voucher',
      icon: FluentIcons.gift_card,
      body: const Voucher(),
      // body: roles.canAddVoucher() ? const Voucher() : const NoAccessPage(),
    ),
    NavigationItems(
      title: 'Settings',
      icon: FluentIcons.settings,
      body: const Settings(),
    ),
  ];
});

List<String> get navTitles => [
      'Dashboard',
      'Product',
      'Add Product',
      'Orders',
      'Campaign',
      'Flash',
      'Newsfeed',
      'Slider',
      'Voucher',
      'Settings',
    ];

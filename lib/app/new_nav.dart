// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:merchant_panel/app/flash/flash_page.dart';
// import 'package:merchant_panel/app/order/order_list.dart';
// import 'package:merchant_panel/app/products/add/add_products.dart';
// import 'package:merchant_panel/app/products/products_page.dart';
// import 'package:merchant_panel/app/slider/slider.dart';
// import 'package:merchant_panel/theme/theme_manager.dart';
// import 'package:go_router/go_router.dart';
// import '../auth/auth_provider.dart';
// import '../auth/employee/employee_provider.dart';
// import '../theme/layout_manager.dart';
// import 'campaign/campaign_list.dart';
// import 'dash/dashboard.dart';
// import 'newsfeed/newsfeed.dart';
// import 'setting/settings_page.dart';

// class NewNavigationPage extends ConsumerStatefulWidget {
//   NewNavigationPage({Key? key, required String tab})
//       : index = indexOf(tab),
//         super(key: key);
//   static const routeName = 'nav';

//   final int index;

//   static int indexOf(String tab) {
//     switch (tab) {
//       case 'Dashboard':
//         return 0;
//       case 'Products':
//         return 1;
//       case 'Add_Product':
//         return 2;
//       case 'Orders':
//         return 3;
//       case 'Campaign':
//         return 4;
//       case 'Flash':
//         return 5;
//       case 'News':
//         return 6;
//       case 'Slider':
//         return 7;
//       case 'Settings':
//         return 8;
//       default:
//         return 0;
//     }
//   }

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _NavigationPageState();
// }

// class _NavigationPageState extends ConsumerState<NewNavigationPage> {
//   late int _index;

//   @override
//   void initState() {
//     _index = widget.index;
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     _index = widget.index;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final layout = ref.read(layoutProvider(context));
//     final uid = getUser?.uid;
//     final roles = ref.watch(roleProvider(uid));
//     return SafeArea(
//       child: NavigationView(
//         contentShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         appBar: NavigationAppBar(
//           title: Text(layout.isSmallScreen ? navTitles[_index] : ''),
//           automaticallyImplyLeading: false,
//           actions: const Text('v2.1.2 (router2.0)'),
//         ),
//         pane: NavigationPane(
//           size: NavigationPaneSize(
//               openMaxWidth: layout.isSmallScreen ? null : 200),
//           selected: _index,
//           onChanged: (int index) {
//             setState(
//               () {
//                 _index = index;
//                 switch (index) {
//                   case 0:
//                     context.go('/dash');
//                     break;
//                   case 1:
//                     context.go('/products');
//                     break;
//                   case 2:
//                     context.go('/add_products');
//                     break;
//                   case 3:
//                     context.go('/orders');
//                     break;
//                   case 4:
//                     context.go('/campaign');
//                     break;
//                   case 5:
//                     context.go('/flash');
//                     break;
//                   case 6:
//                     context.go('/news');
//                     break;
//                   case 7:
//                     context.go('/slider');
//                     break;
//                   case 8:
//                     context.go('/settings');
//                     break;
//                   default:
//                     context.go('/dash');
//                     break;
//                 }
//               },
//             );
//           },
//           header: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: Image.asset(
//               'assets/logo/expanded_logo.png',
//               fit: BoxFit.cover,
//               width: 200,
//             ),
//           ),
//           displayMode: layout.isSmallScreen
//               ? PaneDisplayMode.minimal
//               : PaneDisplayMode.auto,
//           indicator: const StickyNavigationIndicator(),
//           items: [
//             ...List.generate(
//               navItems.length - 1,
//               (index) => navItems[index] is SizedBox
//                   ? PaneItemSeparator()
//                   : PaneItem(
//                       icon: Icon(navItems[index].icon),
//                       title: Text(navItems[index].title),
//                     ),
//             ).toList(),
//           ],
//           footerItems: [
//             PaneItemSeparator(),
//             PaneItem(
//               icon: const Icon(FluentIcons.settings),
//               title: const Text('Settings'),
//             ),
//             if (layout.isAndroid) PaneItemSeparator(),
//             if (layout.isAndroid) PaneItemSeparator(),
//             if (layout.isAndroid) PaneItemSeparator(),
//           ],
//         ),
//         content: FocusTraversalGroup(
//           child: IndexedStack(
//             index: _index,
//             children: const [
//               Dash(),
//               AllProductsPage(),
//               AddProducts(),
//               OrderList(),
//               Campaign(),
//               FlashPage(),
//               News(),
//               SliderPage(),
//               Settings(),
//             ],
//           ),
//           //    NavigationBody(
//           //     transitionBuilder: (child, animation) =>
//           //         EntrancePageTransition(animation: animation, child: child),
//           //     index: _index,
//           //     children: [
//           //       const Dash(),
//           //       const AllProductsPage(),
//           //       const AddProducts(),
//           //       const OrderList(),
//           //       roles.canAddOffers() ? const Campaign() : const NoAccessPage(),
//           //       roles.canAddOffers() ? const FlashPage() : const NoAccessPage(),
//           //       roles.canAddOffers() ? const Newsfeed() : const NoAccessPage(),
//           //       roles.canAddOffers() ? const SliderPage() : const NoAccessPage(),
//           //       const Settings(),
//           //     ],
//           //   ),
//           // ),
//         ),
//       ),
//     );
//   }
// }

// class NoAccessPage extends StatelessWidget {
//   const NoAccessPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldPage(
//       content: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               FluentIcons.bulk_page_block,
//               size: 100,
//               color: Colors.warningPrimaryColor,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'You are not authorized to access this page',
//               style: textTheme(context).title!.copyWith(
//                     color: Colors.warningPrimaryColor,
//                   ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:merchant_panel/app/new_nav.dart';
// import 'package:go_router/go_router.dart';

// import '../auth/auth_provider.dart';

// final routerProvider = Provider<GoRouter>((ref) {
//   final router = RouterNolifier(ref);
//   return GoRouter(
//     urlPathStrategy: UrlPathStrategy.path,
//     debugLogDiagnostics: true,
//     refreshListenable: router,
//     routes: router.routes,
//     initialLocation: '/',
//     errorBuilder: (context, state) => ErrorScreen(state: state),
//     redirect: (state) {
//       if (state.name == 'login') {
//         return state.namedLocation('root');
//       }
//       return null;
//     },
//   );
// });

// class RouterNolifier extends ChangeNotifier {
//   final Ref ref;

//   RouterNolifier(this.ref);

//   bool isLoggedIn() {
//     final userState = ref.watch(authStateProvider);

//     return userState.maybeWhen(
//       data: (user) => user != null,
//       orElse: () => false,
//     );
//   }

//   String? redirectLogic(state) {
//     return null;
//   }

//   List<GoRoute> get routes => [
//         GoRoute(
//             path: '/',
//             name: 'root',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'dash'});
//             }),
//         GoRoute(
//             path: '/login',
//             name: 'login',
//             redirect: (state) {
//               return null;

//               // return state.namedLocation('nav', params: {'tab': 'dash'});
//             }),
//         GoRoute(
//           path:
//               '/nav/:tab(dash|products|add_products|orders|campaign|flash|news|slider|settings)',
//           name: 'nav',
//           builder: (context, state) {
//             final tab = state.params['tab']!;
//             return NewNavigationPage(
//               tab: tab,
//               key: state.pageKey,
//             );
//           },
//         ),
//         GoRoute(
//             path: '/dash',
//             name: 'dash',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'dash'});
//             }),
//         GoRoute(
//             path: '/products',
//             name: 'products',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'products'});
//             }),
//         GoRoute(
//             path: '/add_products',
//             name: 'add_products',
//             redirect: (state) {
//               return state
//                   .namedLocation('nav', params: {'tab': 'add_products'});
//             }),
//         GoRoute(
//             path: '/orders',
//             name: 'orders',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'orders'});
//             }),
//         GoRoute(
//             path: '/campaign',
//             name: 'campaign',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'campaign'});
//             }),
//         GoRoute(
//             path: '/flash',
//             name: 'flash',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'flash'});
//             }),
//         GoRoute(
//             path: '/news',
//             name: 'news',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'news'});
//             }),
//         GoRoute(
//             path: '/slider',
//             name: 'slider',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'slider'});
//             }),
//         GoRoute(
//             path: '/settings',
//             name: 'settings',
//             redirect: (state) {
//               return state.namedLocation('nav', params: {'tab': 'settings'});
//             }),
//       ];
// }

// class ErrorScreen extends StatelessWidget {
//   const ErrorScreen({
//     Key? key,
//     required this.state,
//   }) : super(key: key);
//   final GoRouterState state;

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldPage(
//       content: Center(
//         child: Text(state.error.toString()),
//       ),
//     );
//   }
// }

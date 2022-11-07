import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/nav_pane.dart';
import 'package:merchant_panel/auth/login.dart';
import 'package:merchant_panel/routes/route.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'auth/auth_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
  configLoading();
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'GNG Merchant',
      themeMode: ThemeMode.light,
      theme: Themes.light,
      darkTheme: Themes.dark,
      builder: EasyLoading.init(),
      color: Colors.white,
      initialRoute: AuthGate.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 15.0
    ..userInteractions = true
    ..dismissOnTap = false
    ..maskColor = Colors.blue.withOpacity(0.5);
}

class AuthGate extends ConsumerWidget {
  const AuthGate({Key? key}) : super(key: key);
  static const String routeName = '/auth';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStats = ref.watch(authStateProvider);

    return authStats.when(
      data: (user) => user == null ? const LoginPage() : const NavigationPage(),
      error: (err, state) => const LoginPage(),
      loading: () => ScaffoldPage(
        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/logo.png',
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const ProgressBar(),
            ],
          ),
        ),
      ),
    );
  }
}

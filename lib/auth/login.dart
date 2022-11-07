import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/auth/auth_provider.dart';
import 'package:merchant_panel/auth/auth_services.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/theme/theme_manager.dart';

import '../theme/layout_manager.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscureText = ref.watch(obscureTextProvider);
    final authS = ref.watch(authServicesProvider);
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return ScaffoldPage(
      content: isSmall
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/logo/login.png',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                    loginForm(context, authS, obscureText, ref),
                  ],
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/logo/login.png',
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.height * 0.5,
                  ),
                ),
                Divider(
                  direction: Axis.vertical,
                  size: MediaQuery.of(context).size.height * 0.7,
                  style: const DividerThemeData(thickness: 4),
                ),
                Expanded(
                  child: loginForm(context, authS, obscureText, ref),
                ),
              ],
            ),
    );
  }

  Padding loginForm(
    BuildContext context,
    AuthServices authS,
    bool obscureText,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: textTheme(context).titleLarge,
          ),
          TextBox(
            header: 'Email',
            decoration: boxDecoration,
            controller: authS.emailCtrl,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          TextBox(
            header: 'Password',
            decoration: boxDecoration,
            controller: authS.passCtrl,
            obscureText: obscureText,
            onSubmitted: (value) => authS.login(),
            suffix: IconButton(
              icon: Icon(
                obscureText ? FluentIcons.hide3 : FluentIcons.view,
                size: 20,
              ),
              onPressed: () {
                ref.read(obscureTextProvider.notifier).state = !obscureText;
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                child: const Text('Login'),
                onPressed: () {
                  authS.login();
                },
              ),
              const SizedBox(width: 10),
              FilledButton(
                child: const Text('Guest Login'),
                onPressed: () {
                  authS.guestLogin();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

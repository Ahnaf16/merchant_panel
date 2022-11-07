import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';

import '../../../auth/auth_services.dart';
import '../../../theme/layout_manager.dart';
import '../../../theme/theme.dart';
import '../accounts/account_providers.dart';

class AddAccount extends ConsumerWidget {
  const AddAccount({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(selectedRoleProvider);
    final rolesList = ref.watch(rolesListProvider);
    final authServices = ref.watch(authServicesProvider);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: isSmall ? double.infinity : context.width / 1.8,
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextBox(
              header: 'Name',
              controller: authServices.nameCtrl,
              decoration: boxDecoration,
            ),
            const SizedBox(height: 20),
            TextBox(
              header: 'Email',
              controller: authServices.emailCtrl,
              decoration: boxDecoration,
            ),
            const SizedBox(height: 20),
            TextBox(
              header: 'Password',
              controller: authServices.passCtrl,
              decoration: boxDecoration,
            ),
            const SizedBox(height: 20),
            PillButtonBar(
              selected: selectedRole,
              onChanged: (value) {
                ref.read(selectedRoleProvider.notifier).state = value;
              },
              items: rolesList
                  .map(
                    (text) => PillButtonBarItem(
                      text: Text(text),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Button(
                  style: outlineButtonsStyle(
                    radius: 5,
                    bgColor: Colors.blue,
                    fgColor: Colors.white,
                    showBorder: false,
                  ),
                  child: const Text('Create'),
                  onPressed: () {
                    authServices.signUp(
                      rolesList[selectedRole],
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

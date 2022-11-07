import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/auth/auth_provider.dart';
import 'package:merchant_panel/widgets/body_base.dart';
import 'package:merchant_panel/widgets/error_widget.dart';

import '../../../auth/auth_services.dart';
import '../../../auth/employee/employee_provider.dart';
import '../../../theme/layout_manager.dart';
import '../local/add_account.dart';
import '../local/employee_info.dart';

class AccountManagementPage extends ConsumerWidget {
  const AccountManagementPage({Key? key}) : super(key: key);

  static const String routeName = '/account_management';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authS = ref.watch(authServicesProvider);
    final employeeList = ref.watch(employeeListProvider);
    final uid = getUser?.uid;
    final employeeStream = ref.watch(employeeStreamProvider(uid));
    final roles = ref.watch(roleProvider(uid));
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return SafeArea(
      child: ScaffoldPage(
        header: PageHeader(
          title: const Text('Employees'),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(FluentIcons.back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          commandBar: Row(
            children: [
              if (roles.canManageAccounts())
                FilledButton(
                  child: const Text('New Account'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => const AddAccount(),
                    );
                  },
                ),
              const SizedBox(width: 10),
              FilledButton(
                child: const Text('Log Out'),
                onPressed: () {
                  authS.logOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        content: BaseBody(
          widthFactor: isSmall ? 1 : 1.1,
          children: [
            employeeStream.when(
              data: (employeeData) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: InfoLabel(
                        label: 'Currently logged in as',
                        child: EmployeeCard(
                          isSmall: isSmall,
                          employee: employeeData,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (roles.canManageAccounts())
                      InfoLabel(
                        label: 'All Employees',
                        child: employeeList.when(
                          data: (employees) {
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(
                                employees.length,
                                (index) => EmployeeCard(
                                  isSmall: isSmall,
                                  employee: employees[index],
                                ),
                              ),
                            );
                          },
                          error: (error, st) =>
                              KErrorWidget(error: error, st: st),
                          loading: () => const LoadingWidget(),
                        ),
                      ),
                  ],
                ),
              ),
              error: (error, st) => KErrorWidget(error: error, st: st),
              loading: () => const LoadingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

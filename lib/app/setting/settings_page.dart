import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:merchant_panel/app/setting/app%20Settings/app_settings.dart';
import 'package:merchant_panel/app/setting/users/users.dart';
import 'package:merchant_panel/app/setting/version_control/version_control.dart';
import 'package:merchant_panel/widgets/card_button.dart';
import 'package:merchant_panel/widgets/header.dart';

import '../../auth/auth_provider.dart';
import '../../auth/employee/employee_provider.dart';
import '../../theme/layout_manager.dart';
import '../../widgets/body_base.dart';
import '../../widgets/error_widget.dart';
import 'accounts/manage_account.dart';
import 'live_stream/live_videos_page.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);
  static const routeName = '/settings';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = getUser?.uid;
    final employeeStream = ref.watch(employeeStreamProvider(uid));
    final roles = ref.watch(roleProvider(uid));
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return ScaffoldPage(
      header: layout.isSmallScreen
          ? null
          : const Header(
              title: 'Settings',
              showLeading: false,
            ),
      padding: isSmall ? EdgeInsets.zero : null,
      content: employeeStream.when(
        data: (employee) => BaseBody(
          widthFactor: isSmall ? 1 : 1.3,
          crossAxisAlignment: isSmall ? null : CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: [
                CardButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AccountManagementPage.routeName,
                    );
                  },
                  title: 'Employee Accounts',
                  icon: FluentIcons.account_management,
                  isExpanded: isSmall ? true : false,
                ),
                CardButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppSettings.routeName,
                    );
                  },
                  isExpanded: isSmall ? true : false,
                  title: 'App Settings',
                  icon: FluentIcons.settings,
                ),
                if (roles.canChangeVersion())
                  CardButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        VersionControl.routeName,
                      );
                    },
                    isExpanded: isSmall ? true : false,
                    title: 'Version Control Settings',
                    icon: FluentIcons.version_control_push,
                  ),
                CardButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LiveVideosPage.routeName);
                  },
                  isExpanded: isSmall ? true : false,
                  title: 'Live Video',
                  icon: FluentIcons.video,
                ),
                if (roles.canChangeDeliveryOptions())
                  CardButton(
                    onPressed: () {},
                    isExpanded: isSmall ? true : false,
                    title: 'Delivery Settings',
                    icon: FluentIcons.delivery_truck,
                  ),
                if (roles.canViewUsers())
                  CardButton(
                    onPressed: () {
                      Navigator.pushNamed(context, UsersList.routeName);
                    },
                    isExpanded: isSmall ? true : false,
                    title: 'App Users',
                    icon: FluentIcons.user_optional,
                  ),
              ],
            ),
          ],
        ),
        error: (error, st) => KErrorWidget(error: error, st: st),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}

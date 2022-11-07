import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/setting/app%20Settings/app_sett_providers.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/body_base.dart';

import '../../../theme/layout_manager.dart';

class AppSettings extends ConsumerWidget {
  const AppSettings({Key? key}) : super(key: key);
  static const String routeName = 'appSettings';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('App Settings'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            icon: const Icon(FluentIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      content: BaseBody(
        children: [
          const InitialPageBox(),
          const Divider(),
          ListTile(
            title: const Text('App Theme'),
            trailing: DropDownButton(
              disabled: true,
              buttonStyle: outlineButtonsStyle(radius: 5),
              leading: const Text('Light'),
              items: [
                MenuFlyoutItem(
                  text: const Text('Light'),
                  onPressed: () {},
                ),
                MenuFlyoutItem(
                  text: const Text('Dark'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Accent Color'),
            trailing: DropDownButton(
              buttonStyle: outlineButtonsStyle(radius: 5),
              disabled: true,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              items: [
                MenuFlyoutItem(
                  text: const Text('Blue'),
                  onPressed: () {},
                ),
                MenuFlyoutItem(
                  text: const Text('Orange'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InitialPageBox extends ConsumerWidget {
  const InitialPageBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.read(naviIndexProvider.notifier);
    final savedPage = ref.watch(savedIndexPage);
    final pages = navTitles;

    return ListTile(
      title: const Text('Initial Page'),
      trailing: DropDownButton(
        buttonStyle: outlineButtonsStyle(radius: 5),
        leading: Text(savedPage),
        items: pages
            .map(
              (title) => MenuFlyoutItem(
                text: Text(title),
                onPressed: () {
                  index.saveIndex(title);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

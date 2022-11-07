import 'package:fluent_ui/fluent_ui.dart';
import 'package:merchant_panel/app/setting/users/user_provider.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../theme/theme.dart';

class SearchUsers extends StatelessWidget {
  const SearchUsers({
    super.key,
    required this.userListFunc,
    required this.search,
  });

  final UsersListNotifier userListFunc;
  final String search;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoLabel.rich(
            label: TextSpan(
              text: 'Search Users   ',
              children: [
                const WidgetSpan(
                  child: Icon(MdiIcons.helpCircleOutline),
                ),
                const TextSpan(text: ' search with user '),
                TextSpan(
                  text: 'Display Name, Login Phone Number ',
                  style: context.textType.bodyStrong,
                ),
                const TextSpan(text: 'or '),
                TextSpan(
                  text: 'Email',
                  style: context.textType.bodyStrong,
                ),
              ],
            ),
            child: TextBox(
              decoration: boxDecoration,
              controller: userListFunc.searchCtrl,
              onSubmitted: (text) {
                userListFunc.search();
              },
              suffix: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () {
                  userListFunc.firstFetch();
                  userListFunc.searchCtrl.clear();
                },
              ),
              prefix: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: const Icon(FluentIcons.search),
                  onPressed: () {
                    userListFunc.search();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

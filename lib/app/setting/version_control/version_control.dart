import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/theme/layout_manager.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/body_base.dart';
import 'package:merchant_panel/widgets/header.dart';
import 'package:merchant_panel/widgets/text_icon.dart';

import 'client_app_provider.dart';
import 'merchant_provider.dart';

class VersionControl extends ConsumerWidget {
  const VersionControl({Key? key}) : super(key: key);
  static const String routeName = 'client_app_settings';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionN = ref.read(versionProvider.notifier);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    final cloudVersion = ref.watch(cloudVersionProvider);
    final merchantVerCtrls = ref.read(merchantVersionProvider.notifier);
    final merchantVer = ref.watch(merchantVersionProvider);
    String webVersion =
        merchantVerCtrls.toVersion(merchantVerCtrls.info.cloudWeb);
    String androVersion = merchantVerCtrls.toVersion(merchantVer.cloudAndro);
    return SafeArea(
      child: ScaffoldPage(
        header: const Header(title: 'Client App Settings'),
        content: BaseBody(
          widthFactor: isSmall ? 1 : 1.2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'Main App',
              child: Card(
                child: IncrementTextBox(
                  header: 'Current v$cloudVersion',
                  ctrl: versionN.versionCtrl,
                  extended: true,
                  onAccept: () => versionN.updateVersion(cloudVersion),
                  onAdd: () => versionN.incrementVersion(),
                  onSubtract: () => versionN.decrementVersion(),
                  onReset: () => versionN.reset(cloudVersion),
                ),
              ),
            ),
            const SizedBox(height: 30),
            InfoLabel(
              label: 'Merchant App',
              child: Card(
                child: Column(
                  children: [
                    IncrementTextBox(
                      header: 'Current Web $webVersion',
                      ctrl: merchantVerCtrls.versionCtrlWeb,
                      onReset: () => merchantVerCtrls.reset,
                      onAccept: () => merchantVerCtrls.updateVersion(),
                      onAdd: () =>
                          merchantVerCtrls.incrementVersion(isWeb: true),
                      onSubtract: () =>
                          merchantVerCtrls.decrementVersion(isWeb: true),
                    ),
                    const SizedBox(height: 20),
                    IncrementTextBox(
                      header: 'Current Android $androVersion',
                      ctrl: merchantVerCtrls.versionCtrlAndro,
                      onAccept: () => merchantVerCtrls.updateVersion(),
                      onReset: () => merchantVerCtrls.reset,
                      onAdd: () => merchantVerCtrls.incrementVersion(),
                      onSubtract: () => merchantVerCtrls.decrementVersion(),
                    ),
                    const SizedBox(height: 20),
                    IncrementTextBox(
                      header: 'Android app Download link',
                      ctrl: merchantVerCtrls.appLinkCtrl,
                      onAccept: () => merchantVerCtrls.updateVersion(),
                      extended: true,
                      extra: TextIcon(
                        icon: FluentIcons.open_in_new_tab,
                        margin: const EdgeInsets.only(left: 5),
                        showBorder: true,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncrementTextBox extends StatelessWidget {
  const IncrementTextBox({
    super.key,
    required this.ctrl,
    this.onAccept,
    this.onAdd,
    this.onSubtract,
    this.onReset,
    this.extended = false,
    this.extra,
    this.header,
  });
  final TextEditingController ctrl;
  final Function()? onAccept;
  final Function()? onAdd;
  final Function()? onSubtract;
  final Function()? onReset;
  final bool extended;
  final Widget? extra;
  final String? header;
  @override
  Widget build(BuildContext context) {
    return TextBox(
      header: header,
      controller: ctrl,
      decoration: boxDecoration,
      maxLines: extended ? null : 1,
      suffix: onAccept == null
          ? null
          : TextIcon(
              icon: FluentIcons.accept,
              onPressed: onAccept,
            ),
      outsideSuffix: Row(
        children: [
          if (onSubtract != null)
            TextIcon(
              icon: FluentIcons.remove,
              showBorder: true,
              margin: const EdgeInsets.only(left: 5),
              onPressed: onSubtract,
            ),
          if (onAdd != null)
            TextIcon(
              icon: FluentIcons.add,
              showBorder: true,
              margin: const EdgeInsets.only(left: 5),
              onPressed: onAdd,
            ),
          if (onReset != null)
            TextIcon(
              icon: FluentIcons.reset,
              showBorder: true,
              margin: const EdgeInsets.only(left: 5),
              onPressed: onReset,
            ),
          if (extra != null) extra!,
        ],
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_panel/app/setting/app%20Settings/app_sett_providers.dart';
import 'package:merchant_panel/app/setting/settings_page.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/theme/theme_manager.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/system/system_services.dart';
import '../theme/layout_manager.dart';
import 'package:universal_html/html.dart' as html;

final localVersionProvider = Provider.autoDispose<int>((ref) {
  return 232;
});

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    final layout = ref.read(layoutProvider(context));
    final indexWebN = ref.read(naviIndexProvider.notifier);
    final pageIndex = ref.watch(naviIndexProvider);
    final savedPage = ref.watch(savedIndexPage);
    final updateInfo = ref.watch(canUpdateProvider);
    final navItems = ref.watch(navItemProvider);
    final localVersion = ref.watch(localVersionProvider);
    final String versionName = localVersion
        .toString()
        .replaceAll('', '.')
        .substring(0, 6)
        .replaceFirst('.', 'v');

    return updateInfo.canUpdateAndro && !kIsWeb
        ? ContentDialog(
            title: const Text('Update Available'),
            content: Text.rich(
              TextSpan(
                text: 'New Version of GNG Merchant available.\n\n',
                children: [
                  TextSpan(
                      text: updateInfo.link,
                      style: TextStyle(
                        color: Colors.orange,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                            Uri.parse(updateInfo.link),
                          );
                        }),
                ],
              ),
            ),
            actions: [
              FilledButton(
                child: const Text('Update'),
                onPressed: () {
                  launchUrl(
                    Uri.parse(updateInfo.link),
                  );
                },
              ),
            ],
          )
        : Column(
            children: [
              Expanded(
                child: NavigationView(
                  contentShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  appBar: NavigationAppBar(
                    title: layout.isSmallScreen
                        ? Text(
                            navTitles[pageIndex],
                            style: context.textType.bodyLarge,
                          )
                        : null,
                    actions: Text(versionName),
                    automaticallyImplyLeading: false,
                    height: layout.isSmallScreen ? 50 : 30,
                  ),
                  pane: NavigationPane(
                    size: NavigationPaneSize(
                        openMaxWidth: layout.isSmallScreen ? null : 200),
                    selected: pageIndex,
                    onChanged: (int newIndex) {
                      indexWebN.setIndex(newIndex);
                    },
                    header: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'Merchant Panel',
                          style: GoogleFonts.catamaran(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    displayMode: layout.isSmallScreen
                        ? PaneDisplayMode.minimal
                        : PaneDisplayMode.auto,
                    indicator: const StickyNavigationIndicator(),
                    items: List.generate(
                      navItems.length - 1,
                      (index) {
                        if (navItems[index] is SizedBox) {
                          return PaneItemSeparator();
                        } else {
                          final NavigationItems item = navItems[index];
                          return PaneItem(
                            icon: Icon(item.icon),
                            title: Text(item.title),
                            body: item.body,
                            trailing: IconButton(
                              icon: Icon(
                                item.title == savedPage
                                    ? FluentIcons.pinned_solid
                                    : FluentIcons.pinned,
                              ),
                              onPressed: () {
                                indexWebN.saveIndex(item.title);
                                indexWebN.setIndex(
                                  navTitles.indexOf(item.title),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    footerItems: [
                      PaneItemSeparator(),
                      PaneItem(
                        icon: const Icon(FluentIcons.settings),
                        title: const Text('Settings'),
                        body: const Settings(),
                      ),
                    ],
                  ),
                ),
              ),
              if (kIsWeb) updateNotification(updateInfo, context),
            ],
          );
  }

  Acrylic updateNotification(VersionInfo updateInfo, BuildContext context) {
    return Acrylic(
      tintAlpha: 0.5,
      luminosityAlpha: 0.5,
      blurAmount: 50,
      elevation: 10,
      tint: const Color.fromARGB(255, 255, 218, 193),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        height: updateInfo.canUpdateWeb ? 60 : 0,
        width: context.width,
        child: updateInfo.canUpdateWeb
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: context.textType.bodyLarge!.copyWith(
                          color: Colors.orange.dark,
                        ),
                        text: 'Update Available\n',
                        children: [
                          TextSpan(
                            text: 'Please reload webpage to apply updates',
                            style: context.textType.body!.copyWith(
                              color: Colors.orange.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextIcon(
                      text: 'Reload',
                      icon: FluentIcons.refresh,
                      hoverColor: Colors.orange.withOpacity(.2),
                      onPressed: () => html.window.location.reload(),
                      margin: const EdgeInsets.only(right: 40),
                      textStyle: context.textType.bodyStrong!.copyWith(
                        color: Colors.orange.dark,
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}

class NoAccessPage extends StatelessWidget {
  const NoAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FluentIcons.bulk_page_block,
              size: 100,
              color: Colors.warningPrimaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'You are not authorized to access this page',
              style: textTheme(context).title!.copyWith(
                    color: Colors.warningPrimaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

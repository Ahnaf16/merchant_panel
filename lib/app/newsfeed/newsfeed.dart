import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/newsfeed/local/shout_out_dialog.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import '../../theme/layout_manager.dart';
import '../../widgets/header.dart';
import 'local/daily_dialog.dart';
import 'local/daily_news_widget.dart';
import 'local/shout_out_widget.dart';

class News extends ConsumerWidget {
  const News({Key? key}) : super(key: key);
  static const routeName = '/newsfeed';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    // final newsApi = ref.read(newsApiProvider.notifier);
    // final shoutOuts = ref.watch(shoutOutProvider);
    // final dailyNews = ref.watch(dailyNewsProvider);
    return ScaffoldPage(
      header: isSmall
          ? null
          : Header(
              showLeading: false,
              title: 'News',
              commandBar: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    child: const Text('Add Daily News'),
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => const DailyNewsDialog(),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    child: const Text('Add Shout Outs'),
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => const ShoutOutDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
      padding: isSmall ? EdgeInsets.zero : null,
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (isSmall)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextIcon(
                    text: 'Add Daily News',
                    icon: FluentIcons.news,
                    showBorder: true,
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => const DailyNewsDialog(),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  TextIcon(
                    text: 'Add Shout Outs',
                    icon: FluentIcons.news,
                    showBorder: true,
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => const ShoutOutDialog(),
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(height: 10),
            const DailyNewsList(),
            const SizedBox(height: 20),
            const ShoutOutList(),
          ],
        ),
      ),
    );
  }
}

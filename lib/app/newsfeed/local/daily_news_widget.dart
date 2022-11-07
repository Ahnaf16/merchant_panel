// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:merchant_panel/extension/context_extensions.dart';

import '../../../services/news_services.dart';
import '../../../theme/layout_manager.dart';
import '../../../theme/theme.dart';
import '../../../widgets/body_base.dart';
import '../../../widgets/cached_net_img.dart';
import '../../../widgets/delete_button.dart';
import '../../../widgets/error_widget.dart';
import '../news_provider.dart';

class DailyNewsList extends ConsumerWidget {
  const DailyNewsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    final newsApi = ref.read(newsApiProvider.notifier);
    final dailyNews = ref.watch(dailyNewsProvider);
    return BaseBody(
      widthFactor: isSmall ? 1 : 1.2,
      children: [
        InfoLabel(
          label: 'Daily News',
          child: dailyNews.when(
            data: (newses) {
              if (newses.isEmpty) {
                return Container(
                  height: 80,
                  decoration: boxDecoration.copyWith(color: Colors.grey[30]),
                  child: const Center(
                    child: Text('E M P T Y'),
                  ),
                );
              } else {
                if (isSmall) {
                  return Column(
                    children: [
                      ...newses.map(
                        (news) => Card(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetImg(
                                url: news.img,
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText(
                                      news.title,
                                      style: context.textType.bodyLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    SelectableText(news.news),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                style: outlineButtonsStyle(
                                  radius: 5,
                                  bgColor: Colors.errorSecondaryColor,
                                  fgColor: Colors.errorPrimaryColor,
                                ),
                                icon: const Icon(FluentIcons.delete),
                                onPressed: () {
                                  deleteButtonDialog(
                                    context: context,
                                    object: 'Daily News',
                                    onDelete: () {
                                      newsApi.deleteDailyNews(news);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return StaggeredGrid.count(
                    crossAxisCount: 5,
                    children: [
                      ...newses.map(
                        (news) => Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: CachedNetImg(
                                  url: news.img,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SelectableText(
                                news.title,
                                style: context.textType.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              SelectableText(news.news),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  style: outlineButtonsStyle(
                                    radius: 5,
                                    bgColor: Colors.errorSecondaryColor,
                                    fgColor: Colors.errorPrimaryColor,
                                  ),
                                  icon: const Icon(FluentIcons.delete),
                                  onPressed: () {
                                    deleteButtonDialog(
                                      context: context,
                                      object: 'Daily News',
                                      onDelete: () {
                                        newsApi.deleteDailyNews(news);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            },
            error: (error, st) => KErrorWidget(error: error, st: st),
            loading: () => const LoadingWidget(),
          ),
        ),
      ],
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../services/news_services.dart';
import '../../../theme/layout_manager.dart';
import '../../../theme/theme.dart';
import '../../../widgets/body_base.dart';
import '../../../widgets/delete_button.dart';
import '../../../widgets/error_widget.dart';
import '../news_provider.dart';

class ShoutOutList extends ConsumerWidget {
  const ShoutOutList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    final newsApi = ref.read(newsApiProvider.notifier);
    final shoutOuts = ref.watch(shoutOutProvider);
    return BaseBody(
      widthFactor: isSmall ? 1 : 1.2,
      children: [
        InfoLabel(
          label: 'Shout Outs',
          child: shoutOuts.when(
            data: (shouts) {
              if (shouts.isEmpty) {
                return Container(
                  height: 80,
                  decoration: boxDecoration.copyWith(color: Colors.grey[30]),
                  child: const Center(
                    child: Text('E M P T Y'),
                  ),
                );
              } else {
                return StaggeredGrid.count(
                  crossAxisCount: isSmall ? 1 : 5,
                  children: [
                    ...shouts.map(
                      (shout) => Card(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SelectableText(shout),
                            ),
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
                                  object: 'Shout Out',
                                  onDelete: () {
                                    newsApi.deleteShoutOut(shout);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
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

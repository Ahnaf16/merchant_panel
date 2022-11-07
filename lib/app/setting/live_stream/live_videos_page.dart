import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/setting/live_stream/live_provider.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/header.dart';
import '../../../services/live/live_api.dart';
import '../../../theme/layout_manager.dart';
import '../../../widgets/body_base.dart';
import 'local/new_video_popUp.dart';
import 'local/new_video.dart';

class LiveVideosPage extends ConsumerWidget {
  const LiveVideosPage({Key? key}) : super(key: key);
  static const String routeName = '/live_video';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveVideos = ref.watch(getLiveVideos);
    final linkFunc = ref.read(addLinkProvider.notifier);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return SafeArea(
      child: ScaffoldPage(
        header: Header(
          title: 'Videos',
          commandBar: FilledButton(
            child: const Text('New Video'),
            onPressed: () {
              context.getDialog(
                barrierDismissible: false,
                child: const NewVideoDialog(),
              );
            },
          ),
        ),
        content: BaseBody(
          widthFactor: isSmall ? 1 : 1.2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            liveVideos.when(
              data: (videos) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...List.generate(
                      videos.length,
                      (index) => VideoLuncher(
                        videoModel: videos[index],
                        linkFunc: linkFunc,
                      ),
                    ),
                  ],
                );
              },
              error: (error, st) => KErrorWidget(error: error, st: st),
              loading: () => const LoadingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

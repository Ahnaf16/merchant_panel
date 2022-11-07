import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/live/live_api.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/cached_net_img.dart';
import '../../../../widgets/delete_button.dart';
import '../link_model.dart';

class VideoLuncher extends StatelessWidget {
  const VideoLuncher({
    Key? key,
    required this.videoModel,
    required this.linkFunc,
  }) : super(key: key);
  final LiveLinkModel videoModel;
  final LiveLinkNotifier linkFunc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (videoModel.type == LinkType.youtube) {
          launchUrl(
            Uri.parse('https://www.youtube.com/watch?v=${videoModel.url}'),
          );
        } else {
          launchUrl(
            Uri.parse(videoModel.url),
          );
        }
      },
      child: Stack(
        children: [
          CachedNetImg(
            url: videoModel.img,
            height: 150,
            width: 300,
            fit: BoxFit.cover,
          ),
          if (videoModel.isLive)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
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
                  object: 'Video',
                  onDelete: () {
                    linkFunc.deleteVideoLink(videoModel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

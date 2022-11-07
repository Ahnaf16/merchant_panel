import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/extension/widget_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../services/image_services.dart';
import '../../../../services/live/live_api.dart';
import '../../../../theme/layout_manager.dart';
import '../../../../theme/theme.dart';
import '../../../../widgets/cached_net_img.dart';
import '../../../../widgets/img_view.dart';
import '../../../../widgets/text_icon.dart';
import '../link_model.dart';

class NewVideoDialog extends ConsumerWidget {
  const NewVideoDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkFunc = ref.read(addLinkProvider.notifier);
    final link = ref.watch(addLinkProvider);
    final imgFunc = ref.read(imgSelectionProvider.notifier);
    final img = ref.watch(imgSelectionProvider);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 800,
      ),
      actions: [
        Button(
          style: hoveringButtonsStyle(Colors.red),
          child: const Text('Cancel'),
          onPressed: () => context.pop,
        ),
        FilledButton(
          child: const Text('Upload'),
          onPressed: () {
            linkFunc.uploadToServer(img.isNotEmpty ? img.first : '');
          },
        ),
      ],
      content: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  if (img.isEmpty)
                    TextIcon(
                      text: 'select image',
                      icon: FluentIcons.photo2_add,
                      onPressed: () {
                        imgFunc.selectSingleImage();
                      },
                    ),
                  if (img.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        context.getDialog(
                          child: ImgView(
                            tag: img.first,
                            url: img.first,
                            isSmall: isSmall,
                          ),
                        );
                      },
                      child: CachedNetImg(
                        url: img.first,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (img.isNotEmpty)
                    IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: () {
                        imgFunc.clearImagePath();
                      },
                    ),
                ],
              ),
              10.hSpace,
              if (link.url.isEmpty)
                Container(
                  height: 150,
                  width: 300,
                  color: Colors.grey[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        link.type == LinkType.youtube
                            ? MdiIcons.youtube
                            : MdiIcons.web,
                        color: link.type == LinkType.youtube
                            ? Colors.red
                            : Colors.black,
                        size: 80,
                      ),
                      Text(link.type.name.toUpperCase())
                    ],
                  ),
                ),
              if (link.url.isNotEmpty)
                if (link.type == LinkType.youtube)
                  SizedBox(
                    height: 150,
                    width: 300,
                    child: YoutubePlayer(controller: linkFunc.ytCtrl),
                  ),
              if (link.url.isNotEmpty)
                if (link.type == LinkType.webView)
                  Container(
                    height: 150,
                    width: 300,
                    color: Colors.grey[50],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          MdiIcons.web,
                          color: Colors.black,
                          size: 60,
                        ),
                        const Text('Preview unavailable.'),
                        10.hSpace,
                        TextIcon(
                          text: 'Visit link',
                          textAlign: TextAlign.center,
                          onPressed: () async {
                            launchUrl(Uri.parse(link.url));
                          },
                          action: const [
                            Icon(FluentIcons.open_in_new_tab),
                          ],
                        )
                      ],
                    ),
                  ),
            ],
          ),
          SizedBox(
            width: 450,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBox(
                  controller: linkFunc.urlCtrl,
                  decoration: boxDecoration,
                  suffixMode: OverlayVisibilityMode.editing,
                  suffix: IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: () {
                        linkFunc.urlCtrl.clear();
                      }),
                  outsideSuffix: Button(
                    child: const Text('Check URL'),
                    onPressed: () {
                      linkFunc.checkLink();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                InfoLabel(
                  label: 'Mark as Live Video',
                  child: ToggleSwitch(
                    checked: link.isLive,
                    onChanged: (v) {
                      linkFunc.isLiveToggle(v);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ...LinkType.values
                        .map(
                          (type) => ToggleButton(
                            checked: link.type == type,
                            onChanged: (v) {
                              linkFunc.setUrlType(type);
                            },
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: hoveringButtonsStyle(Colors.red),
                  child: const Text('reset'),
                  onPressed: () {
                    imgFunc.clearImagePath();
                    linkFunc.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

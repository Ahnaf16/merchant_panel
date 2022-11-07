import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/services/news_services.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/cached_net_img.dart';
import 'package:merchant_panel/widgets/img_view.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import '../../../services/image_services.dart';
import '../../../theme/layout_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DailyNewsDialog extends ConsumerWidget {
  const DailyNewsDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    final selectImg = ref.read(imgSelectionProvider.notifier);
    final img = ref.watch(imgSelectionProvider);
    final newsApi = ref.read(newsApiProvider.notifier);
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: isSmall ? double.infinity : context.width / 2,
      ),
      actions: [
        Button(
          style: hoveringButtonsStyle(Colors.warningPrimaryColor),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Button(
          style: hoveringButtonsStyle(Colors.successPrimaryColor),
          child: const Text('Publish'),
          onPressed: () async {
            if (img.isNotEmpty) {
              await newsApi.setImg(img.first);
              await newsApi.addDailyNews();
            }
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (img.isEmpty)
            Container(
              height: 80,
              width: double.infinity,
              decoration: boxDecoration.copyWith(
                color: Colors.grey[30],
              ),
              child: IconButton(
                icon: const Icon(FluentIcons.file_image, size: 25),
                onPressed: () async {
                  await selectImg.selectSingleImage();
                },
              ),
            ),
          if (img.isNotEmpty)
            imgPreview(img.first, selectImg, context, isSmall, kIsWeb, newsApi),
          const SizedBox(height: 10),
          TextBox(
            header: 'News Title',
            controller: newsApi.titleCtrl,
            decoration: boxDecoration,
            suffixMode: OverlayVisibilityMode.editing,
            suffix: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: () {
                // newsApi.setTitle();
                newsApi.titleCtrl.clear();
              },
            ),
            // onChanged: (value) => newsApi.setTitle(title: value),
          ),
          const SizedBox(height: 10),
          TextBox(
            header: 'News Content',
            controller: newsApi.newsCtrl,
            decoration: boxDecoration,
            maxLines: null,
            minHeight: 110,
            suffixMode: OverlayVisibilityMode.editing,
            suffix: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: () {
                // newsApi.setNews();
                newsApi.newsCtrl.clear();
              },
            ),
            // onChanged: (value) => newsApi.setNews(text: value),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Row imgPreview(
    String img,
    SelectImage selectImg,
    BuildContext context,
    bool isSmall,
    bool isWeb,
    NewsApiNotifier newsApi,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: kIsWeb
              ? CachedNetImg(
                  url: img,
                  height: 80,
                  width: double.infinity,
                )
              : Image.file(
                  File(img),
                  height: 80,
                  width: double.infinity,
                ),
        ),
        Column(
          children: [
            TextIcon(
              icon: FluentIcons.clear,
              showBorder: true,
              iconSize: 13,
              onPressed: () {
                selectImg.clearImagePath();
                newsApi.resetImg();
              },
            ),
            const SizedBox(height: 5),
            TextIcon(
              icon: FluentIcons.view,
              showBorder: true,
              iconSize: 13,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ImgView(
                    tag: img,
                    url: img,
                    isSmall: isSmall,
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

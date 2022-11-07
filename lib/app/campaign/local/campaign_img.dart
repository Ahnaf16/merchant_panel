import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';

import '../../../services/image_services.dart';
import '../../../theme/layout_manager.dart';
import '../../../theme/theme.dart';
import '../../../widgets/cached_net_img.dart';
import '../../../widgets/img_view.dart';

class CampaignImg extends ConsumerWidget {
  const CampaignImg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignImg = ref.watch(imgSelectionProvider);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // IconButton(
        //   style: outlineButtonsStyle(radius: 5),
        // icon: const Icon(
        //   FluentIcons.file_image,
        //   size: 30,
        // ),
        //   onPressed: () {
        //     ref.read(imgSelectionProvider.notifier).selectSingleImage();
        //   },
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          //-----------------selected img
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: campaignImg.isEmpty ? 'tag' : campaignImg.first,
                  child: campaignImg.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            ref
                                .read(imgSelectionProvider.notifier)
                                .selectSingleImage();
                          },
                          child: Container(
                            color: Colors.grey[90],
                            height: 100,
                            width: isSmall
                                ? context.width * 0.7
                                : context.width * 0.2,
                            child: const Icon(
                              FluentIcons.file_image,
                              size: 30,
                            ),
                          ),
                        )
                      : (kIsWeb
                          ? CachedNetImg(
                              url: campaignImg.first,
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.2,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(campaignImg.first),
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.2,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
              const SizedBox(height: 10),
              if (campaignImg.isNotEmpty)
                Row(
                  children: [
                    Container(
                      decoration: boxDecoration,
                      child: IconButton(
                        icon: const Icon(FluentIcons.view),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => ImgView(
                              tag: campaignImg.first,
                              url: campaignImg.first,
                              isSmall: isSmall,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: boxDecoration,
                      child: IconButton(
                        icon: const Icon(FluentIcons.clear),
                        onPressed: () {
                          ref
                              .read(imgSelectionProvider.notifier)
                              .clearImagePath();
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/theme/layout_manager.dart';

import '../../../services/image_services.dart';
import '../../../widgets/cached_net_img.dart';
import '../../../widgets/img_view.dart';

class SelectedImageList extends ConsumerWidget {
  const SelectedImageList({
    Key? key,
    required this.image,
  }) : super(key: key);

  final List<String> image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return Wrap(
      children: List.generate(
        image.length,
        (index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                if (image.isNotEmpty && kIsWeb)
                  Hero(
                    tag: index.toString(),
                    child: CachedNetImg(
                      url: image[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (image.isNotEmpty && !kIsWeb)
                  Hero(
                    tag: index.toString(),
                    child: Image.file(
                      File(image[index]),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                Positioned(
                  left: 70,
                  child: Flyout(
                    openMode: FlyoutOpenMode.press,
                    content: (context) {
                      return MenuFlyout(
                        items: [
                          MenuFlyoutItem(
                            leading: const Icon(FluentIcons.view),
                            text: const Text('View'),
                            onPressed: () async {
                              await showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) => ImgView(
                                  tag: index.toString(),
                                  url: image[index],
                                  isSmall: isSmall,
                                ),
                              );
                            },
                          ),
                          MenuFlyoutItem(
                            leading: const Icon(FluentIcons.remove),
                            text: const Text('Remove'),
                            onPressed: () {
                              ref
                                  .read(imgSelectionProvider.notifier)
                                  .removeImagePath(index);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          FluentIcons.more,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merchant_panel/app/slider/slider_model.dart';
import 'package:merchant_panel/services/image_services.dart';
import 'package:merchant_panel/widgets/body_base.dart';
import 'package:merchant_panel/widgets/delete_button.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/img_view.dart';

import '../../services/slider_services.dart';
import '../../theme/layout_manager.dart';
import '../../theme/theme.dart';
import '../../widgets/cached_net_img.dart';
import '../../widgets/header.dart';

class SliderPage extends ConsumerWidget {
  const SliderPage({Key? key}) : super(key: key);
  static const String routeName = '/slider';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sliderImgs = ref.watch(sliderImgProvider);
    final sliderServices = ref.watch(sliderServicesProvider);
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;

    return ScaffoldPage(
      header: isSmall
          ? null
          : Header(
              title: 'Slider',
              showLeading: false,
              commandBar: FilledButton(
                child: const Text('Add'),
                onPressed: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) => const UploadImgDialog(),
                  );
                },
              ),
            ),
      content: BaseBody(
        widthFactor: isSmall ? 1 : 1.2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sliderImgs.when(
            data: (data) => data.isEmpty
                ? Container(
                    height: 80,
                    decoration: boxDecoration.copyWith(color: Colors.grey[30]),
                    child: const Center(
                      child: Text('E M P T Y'),
                    ),
                  )
                : MasonryGridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isSmall ? 2 : 4,
                    ),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CachedNetImg(
                            url: data[index].img,
                            width: 200,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: boxDecoration,
                                child: IconButton(
                                  icon: const Icon(FluentIcons.delete),
                                  onPressed: () async {
                                    await deleteButtonDialog(
                                      context: context,
                                      onDelete: () {
                                        sliderServices
                                            .deleteImg(data[index].id);
                                        UploadImage.deleteImage(
                                          fileName: data[index].id,
                                          path: 'slider',
                                        );
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: boxDecoration,
                                child: IconButton(
                                  icon: const Icon(FluentIcons.view),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) => ImgView(
                                        tag: index.toString(),
                                        url: data[index].img,
                                        isSmall: isSmall,
                                        isLocalPath: false,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            error: (error, st) => KErrorWidget(error: error, st: st),
            loading: () => const LoadingWidget(),
          ),
        ],
      ),
    );
  }
}

class UploadImgDialog extends ConsumerWidget {
  const UploadImgDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sliderServices = ref.watch(sliderServicesProvider);
    final selectedImg = ref.watch(imgSelectionProvider);
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      title: PageHeader(
        leading: IconButton(
          icon: const Icon(FluentIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Upload Slider Image'),
        commandBar: FilledButton(
          child: const Text('Upload'),
          onPressed: () async {
            final url = await UploadImage.uploadSingleImg(
              path: 'slider',
              imagePath: selectedImg.first,
              fileName: selectedImg.first.split('/').last,
            );
            await sliderServices.addImg(
              SliderModel(
                img: url,
                id: selectedImg.first.split('/').last,
              ),
            );
          },
        ),
      ),
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              InfoLabel(
                label: 'Select Image',
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: boxDecoration,
                  child: IconButton(
                    icon: const Icon(
                      FluentIcons.file_image,
                      size: 30,
                    ),
                    onPressed: () {
                      ref
                          .read(imgSelectionProvider.notifier)
                          .selectSingleImage();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (selectedImg.isNotEmpty)
                CachedNetImg(
                  url: selectedImg.first,
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

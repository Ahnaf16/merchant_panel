import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/flash/flash_model.dart';
import 'package:merchant_panel/app/flash/flash_providers.dart';
import 'package:merchant_panel/app/products/product_model.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/services/offers/flash_services.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/body_base.dart';
import 'package:merchant_panel/widgets/cached_net_img.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../services/product/pagination_items.dart';
import '../../theme/layout_manager.dart';
import '../../widgets/header.dart';

class FlashPage extends ConsumerWidget {
  const FlashPage({Key? key}) : super(key: key);
  static const routeName = '/flash';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(itemsProviderNew);
    final selectedItems = ref.watch(selectedFlashItemsNotifier);
    // final flashItems = ref.watch(flashProvider);
    final productsFunc = ref.read(itemsProviderNew.notifier);
    final scCtrl = ScrollController();
    final layout = ref.read(layoutProvider(context));
    final selectedFlashFunc = ref.read(selectedFlashItemsNotifier.notifier);
    final isSmall = layout.isSmallScreen;
    return ScaffoldPage(
      header: isSmall
          ? null
          : Header(
              title: 'Add Flash',
              showLeading: false,
              commandBar: FilledButton(
                child: const Text('Publish'),
                onPressed: () {
                  if (selectedItems.isNotEmpty) {
                    FlashServices.addFlash(
                      flash: selectedItems,
                    );
                    selectedFlashFunc.clear();
                  }
                },
              ),
            ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isSmall) phoneHeader(context, selectedItems, selectedFlashFunc),
          if (isSmall) const SizedBox(height: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                allProducts.when(
                  data: (products) => products.isEmpty
                      ? Container(
                          height: 80,
                          decoration:
                              boxDecoration.copyWith(color: Colors.grey[30]),
                          child: const Center(
                            child: Text('E M P T Y'),
                          ),
                        )
                      : Flexible(
                          flex: 2,
                          child: BaseBody(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            widthFactor: isSmall ? 1 : 1.2,
                            scrollController: scCtrl,
                            children: [
                              TextBox(
                                header: 'Search',
                                decoration: boxDecoration,
                                controller: productsFunc.searchCtrl,
                                suffix: IconButton(
                                  icon: const Icon(FluentIcons.clear),
                                  onPressed: () {
                                    productsFunc.firstFetch();
                                    productsFunc.searchCtrl.clear();
                                  },
                                ),
                                suffixMode: OverlayVisibilityMode.editing,
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    productsFunc.search();
                                  } else {
                                    productsFunc.firstFetch();
                                  }
                                },
                                prefix: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(FluentIcons.search),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return flashItemTile(
                                    selectedFlashFunc: selectedFlashFunc,
                                    products: products[index],
                                    context: context,
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                child: const Text('load more'),
                                onPressed: () {
                                  productsFunc.loadMore(products.last);
                                },
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                  error: (error, st) => KErrorWidget(error: error, st: st),
                  loading: () => const BaseBody(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    widthFactor: 2,
                    children: [
                      LoadingWidget(),
                    ],
                  ),
                ),
                if (!isSmall) const SizedBox(width: 10),
                if (!isSmall)
                  Flexible(
                    child: BaseBody(
                      scrollController: ScrollController(),
                      children: const [
                        AllFlashItems(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding phoneHeader(BuildContext context, List<FlashModel> selectedItems,
      SelectedFlashItem selectedFlashFunc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextIcon(
            text: 'Show',
            icon: MdiIcons.menu,
            horizontalMargin: 12,
            verticalMargin: 10,
            showBorder: true,
            onPressed: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) => ContentDialog(
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  actions: [
                    OutlinedButton(
                      child: const Text('go back'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                  content: const AllFlashItems(),
                ),
              );
            },
          ),
          if (selectedItems.isNotEmpty) const SizedBox(width: 10),
          if (selectedItems.isNotEmpty)
            TextIcon(
              text: 'Publish',
              icon: FluentIcons.upload,
              horizontalMargin: 12,
              verticalMargin: 10,
              showBorder: true,
              onPressed: () {
                FlashServices.addFlash(
                  flash: selectedItems,
                );
                selectedFlashFunc.clear();
              },
            ),
        ],
      ),
    );
  }

  ListTile flashItemTile({
    required SelectedFlashItem selectedFlashFunc,
    required BuildContext context,
    required ProductModel products,
  }) {
    return ListTile.selectable(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      selected: selectedFlashFunc.doseContains(products.id),
      trailing: IconButton(
        icon: const Icon(FluentIcons.chevron_right),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => FlashPriceDialog(product: products),
          );
        },
      ),
      leading: CachedNetImg(
        url: products.imgUrls[0],
        fit: BoxFit.contain,
        height: 60,
        width: 60,
      ),
      title: Text(products.name.showUntil(20)),
      subtitle: Row(
        children: [
          Text(
            products.price.toCurrency(),
            style: TextStyle(
              decoration:
                  products.haveDiscount ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(width: 10),
          if (products.haveDiscount) Text(products.discountPrice.toCurrency()),
        ],
      ),
    );
  }
}

class AllFlashItems extends ConsumerWidget {
  const AllFlashItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedFlashItemsNotifier);
    final flashItems = ref.watch(flashProvider);

    return flashItems.when(
      data: (flash) => SingleChildScrollView(
        child: Column(
          children: [
            if (selectedItems.isEmpty)
              Container(
                height: 80,
                decoration: boxDecoration.copyWith(color: Colors.grey[30]),
                child: const Center(
                  child: Text('E M P T Y'),
                ),
              ),
            ...List.generate(
              selectedItems.length,
              (index) => InfoLabel(
                label: 'Selected',
                child: tile(
                  ref,
                  index,
                  selectedItems,
                  false,
                  context,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (flash.isEmpty)
              Container(
                height: 80,
                decoration: boxDecoration.copyWith(color: Colors.grey[30]),
                child: const Center(
                  child: Text('E M P T Y'),
                ),
              ),
            ...List.generate(
              flash.length,
              (index) => flash.isEmpty
                  ? Container(
                      height: 80,
                      decoration:
                          boxDecoration.copyWith(color: Colors.grey[30]),
                      child: const Center(
                        child: Text('E M P T Y'),
                      ),
                    )
                  : InfoLabel(
                      label: 'Ongoing',
                      child: Stack(
                        children: [
                          tile(ref, index, flash, true, context),
                          const Positioned(
                            child: Icon(FluentIcons.lightning_bolt),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      error: (error, st) => KErrorWidget(error: error, st: st),
      loading: () => const LoadingWidget(),
    );
  }

  ListTile tile(WidgetRef ref, int index, List<FlashModel> flashItems,
      bool isOngoing, BuildContext context) {
    return ListTile(
      trailing: IconButton(
        icon: const Icon(FluentIcons.cancel),
        onPressed: () {
          if (isOngoing) {
            showDialog(
              context: context,
              builder: (context) =>
                  deleteFlashDialog(flashItems, index, context),
            );
          } else {
            ref.read(selectedFlashItemsNotifier.notifier).remove(index);
          }
        },
      ),
      leading: CachedNetImg(
        url: flashItems[index].image,
        fit: BoxFit.contain,
        height: 60,
        width: 60,
      ),
      title: Text(flashItems[index].name.showUntil(20)),
      subtitle: Row(
        children: [
          Text(
            flashItems[index].price.toCurrency(),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            flashItems[index].flashPrice.toCurrency(),
          ),
        ],
      ),
    );
  }

  ContentDialog deleteFlashDialog(
      List<FlashModel> flash, int index, BuildContext context) {
    return ContentDialog(
      title: const Text('Delete Flash'),
      content: const Text('Are you sure you want to delete this flash?'),
      actions: [
        TextButton(
          style: removeButtonsStyle(Colors.warningPrimaryColor),
          child: const Text('Delete'),
          onPressed: () {
            FlashServices.deleteFlash(flashId: flash[index].id);
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: removeButtonsStyle(Colors.blue),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  ButtonStyle removeButtonsStyle(Color color) {
    return ButtonStyle(
      shape: ButtonState.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      backgroundColor: ButtonState.resolveWith(
        (states) => states.isHovering ? color : Colors.transparent,
      ),
      foregroundColor: ButtonState.resolveWith(
        (states) => states.isHovering ? Colors.white : color,
      ),
    );
  }
}

class FlashPriceDialog extends ConsumerWidget {
  const FlashPriceDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashPrice = ref.watch(flashPriceProvider);
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      title: const Text('Flash Price'),
      actions: [
        OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ordinal Price: ${product.price.toCurrency()}',
          ),
          const SizedBox(height: 5),
          if (product.haveDiscount)
            Text(
              'Discount Price: ${product.discountPrice.toCurrency()}',
            ),
          const SizedBox(height: 5),
          SizedBox(
            width: 250,
            //---------------------flash box
            child: TextBox(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              autofocus: true,
              onChanged: (v) {
                ref.read(flashPriceProvider.notifier).state = int.parse(v);
              },
              outsideSuffix: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                //---------------------done button
                child: IconButton(
                  icon: const Icon(FluentIcons.accept),
                  onPressed: () {
                    if (flashPrice == 0) {
                      EasyLoading.showError('Flash Price is required');
                    } else {
                      ref.read(selectedFlashItemsNotifier.notifier).add(
                            FlashModel(
                              name: product.name,
                              price: product.price,
                              flashPrice: flashPrice,
                              image: product.imgUrls[0],
                              id: product.id,
                              category: product.category,
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              decoration: boxDecoration,
              header: 'Flesh Price',
            ),
          ),
        ],
      ),
    );
  }
}

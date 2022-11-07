// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/campaign/campaign_provider.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/services/offers/campaign_services.dart';
import 'package:merchant_panel/services/product/pagination_items.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/body_base.dart';
import 'package:merchant_panel/widgets/cached_net_img.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../services/image_services.dart';
import '../../services/product/product_services.dart';
import '../../theme/layout_manager.dart';
import '../products/product_model.dart';
import 'campaign_model.dart';
import 'local/campaign_img.dart';
import 'local/selected_campaign_item.dart';

class AddCampaign extends ConsumerWidget {
  const AddCampaign({Key? key}) : super(key: key);
  static const routeName = '/addCampaign';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(itemsProviderNew);
    final productsFunc = ref.read(itemsProviderNew.notifier);
    final selectedItems = ref.watch(selectedProductsNotifierProvider);
    final campaignImg = ref.watch(imgSelectionProvider);
    final campaignTitle = ref.watch(campaignTitleProvider);
    final scCtrl = ScrollController();
    final selectedNotifier =
        ref.read(selectedProductsNotifierProvider.notifier);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return SafeArea(
      child: ScaffoldPage(
        header: PageHeader(
          commandBar: FilledButton(
            child: const Text('Publish'),
            onPressed: () async {
              if (campaignTitle.isEmpty) {
                EasyLoading.showError('Campaign title is required');
              } else if (campaignImg.isEmpty) {
                EasyLoading.showError('Campaign image is required');
              } else if (selectedItems.isEmpty) {
                EasyLoading.showError('Select at least one product');
              } else {
                final url = await UploadImage.uploadSingleImg(
                    path: 'campaign_imgs',
                    imagePath: campaignImg.first,
                    fileName: campaignTitle);
                await CampaignServices.addCampaign(
                  campaign: CampaignModel(
                    title: campaignTitle,
                    image: url,
                  ),
                  campaignItem: selectedItems,
                );
                selectedNotifier.clear();
                Navigator.pop(context);
              }
            },
          ),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(FluentIcons.back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Text('Add Campaign'),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (isSmall) const CampaignImg(),
              if (isSmall) const SizedBox(height: 20),
              if (isSmall)
                TextBox(
                  onChanged: (value) =>
                      ref.read(campaignTitleProvider.notifier).state = value,
                  header: 'Campaign Title',
                  decoration: boxDecoration,
                  outsideSuffix: IconButton(
                    icon: const Icon(MdiIcons.menu, size: 25),
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => const ContentDialog(
                          constraints:
                              BoxConstraints(minWidth: double.infinity),
                          content: SelectedCampaignItems(),
                        ),
                      );
                    },
                  ),
                ),
              if (isSmall) const SizedBox(height: 20),
              TextBox(
                header: 'Search',
                decoration: boxDecoration,
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(FluentIcons.search),
                ),
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
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    allProducts.when(
                      data: (products) => Flexible(
                        child: BaseBody(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          widthFactor: isSmall ? 1 : 1.8,
                          scrollController: scCtrl,
                          children: [
                            ...products.map(
                              (product) => SearchResult(products: product),
                            ),
                            const SizedBox(height: 20),
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
                      loading: () => Flexible(
                        child: BaseBody(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          widthFactor: isSmall ? 1 : 1.8,
                          children: const [
                            LoadingWidget(),
                          ],
                        ),
                      ),
                    ),
                    if (!isSmall) const SizedBox(width: 10),
                    if (!isSmall)
                      Expanded(
                        child: BaseBody(
                          scrollController: ScrollController(),
                          children: [
                            const CampaignImg(),
                            const SizedBox(height: 20),
                            TextBox(
                              onChanged: (value) => ref
                                  .read(campaignTitleProvider.notifier)
                                  .state = value,
                              header: 'Campaign Title',
                              decoration: boxDecoration,
                            ),
                            const SizedBox(height: 20),
                            const SelectedCampaignItems(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResult extends StatefulWidget {
  const SearchResult({
    required this.products,
    Key? key,
  }) : super(key: key);
  final ProductModel products;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();

  @override
  void dispose() {
    priceCtrl.dispose();
    discountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedNotifier =
            ref.read(selectedProductsNotifierProvider.notifier);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile.selectable(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            selected: selectedNotifier.doseContains(widget.products.id),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(FluentIcons.edit),
                  style: outlineButtonsStyle(radius: 5),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ContentDialog(
                        title: const Text('Change Price'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextBox(
                              controller: discountCtrl = TextEditingController(
                                  text:
                                      widget.products.discountPrice.toString()),
                              header: 'Discount',
                            ),
                            const SizedBox(height: 10),
                            TextBox(
                              controller: priceCtrl = TextEditingController(
                                  text: widget.products.price.toString()),
                              header: 'Price',
                            ),
                          ],
                        ),
                        actions: [
                          Button(
                            child: const Text('Cancel'),
                            onPressed: () {
                              priceCtrl.clear();
                              discountCtrl.clear();
                              Navigator.pop(context);
                            },
                          ),
                          Button(
                            onPressed: () {
                              ProductServices.updatePrice(
                                  product: widget.products.copyWith(
                                price: priceCtrl.text.asInt,
                                discountPrice: discountCtrl.text.asInt,
                                haveDiscount: true,
                              ));
                            },
                            style: hoveringButtonsStyle(
                              Colors.blue,
                            ),
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  style: outlineButtonsStyle(radius: 5),
                  icon: const Icon(FluentIcons.chevron_right),
                  onPressed: () {
                    selectedNotifier.add(
                      CampaignItemModel(
                        img: widget.products.imgUrls[0],
                        name: widget.products.name,
                        price: widget.products.price,
                        id: widget.products.id,
                        discount: widget.products.discountPrice,
                        haveDiscount: true,
                      ),
                    );
                  },
                ),
              ],
            ),
            leading: CachedNetImg(
              url: widget.products.imgUrls[0],
              fit: BoxFit.contain,
              width: 60,
              height: 60,
            ),
            title: Text(
              widget.products.name.showUntil(20),
            ),
            subtitle: Row(
              children: [
                Text(
                  widget.products.price.toCurrency(),
                  style: TextStyle(
                    decoration: widget.products.haveDiscount
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                if (widget.products.haveDiscount)
                  Text(widget.products.discountPrice.toCurrency()),
              ],
            ),
          ),
        );
      },
    );
  }
}

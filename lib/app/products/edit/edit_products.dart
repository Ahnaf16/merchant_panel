// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/edit/editing_providers.dart';
import 'package:merchant_panel/app/products/edit/preview.dart';
import 'package:merchant_panel/app/products/product_model.dart';
import 'package:merchant_panel/theme/theme.dart';

import '../../../services/global_provider.dart';
import '../../../theme/layout_manager.dart';

class EditProduct extends ConsumerWidget {
  const EditProduct(this.product, {Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = ref.watch(categoryListProvider);
    final category = ref.watch(categoryCtrlE);
    final showDiscount = ref.watch(discountSwitchProviderE);
    final inStock = ref.watch(inStockProviderE);
    final name = ref.watch(nameCtrlE);
    final brand = ref.watch(brandCtrlE);
    final des = ref.watch(desCtrlE);
    final price = ref.watch(priceCtrlE);
    final discount = ref.watch(discountCtrlE);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;

    return SafeArea(
      child: ScaffoldPage(
        header: PageHeader(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: const Icon(
                FluentIcons.back,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: const Text('Edit Product'),
          commandBar: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: FilledButton(
              child: const Text('Update Product'),
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => ContentDialog(
                    constraints: BoxConstraints(
                      maxWidth: isSmall
                          ? double.infinity
                          : MediaQuery.of(context).size.width / 1.3,
                    ),
                    content: AfterEditPreview(
                      brand: brand,
                      name: name,
                      des: des,
                      price: price,
                      discount: discount,
                      inStock: inStock,
                      showDiscount: showDiscount,
                      category: category,
                      product: product,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 0 : 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: isSmall
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 1.8,
                  //-------------left side
                  child: Padding(
                    padding: isSmall
                        ? const EdgeInsets.symmetric(horizontal: 10)
                        : EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //------------- name and brand
                        Card(
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              editBox(
                                ref: ref,
                                header: 'Name',
                                provider: nameCtrlE,
                                placeholder: product.name,
                              ),
                              const SizedBox(height: 20),
                              editBox(
                                ref: ref,
                                header: 'Brand',
                                provider: brandCtrlE,
                                placeholder: product.brand,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        priceCard(ref, showDiscount, inStock),
                        //-------------Description
                        const SizedBox(height: 10),
                        MouseRegion(
                          cursor: SystemMouseCursors.text,
                          child: Card(
                            borderRadius: BorderRadius.circular(10),
                            child: editBox(
                              ref: ref,
                              header: 'Description',
                              provider: desCtrlE,
                              placeholder: product.description,
                              isExpanded: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        categoryCard(
                          context,
                          isSmall,
                          categoryList,
                          category,
                          ref,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                //--------------------------right side
                if (!isSmall) const SizedBox(width: 10),
                if (!isSmall)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        priceCard(ref, showDiscount, inStock),
                        const SizedBox(height: 20),
                        categoryCard(
                            context, isSmall, categoryList, category, ref),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card categoryCard(BuildContext context, bool isSmall,
      List<String> categoryList, String? category, WidgetRef ref) {
    return Card(
      child: InfoLabel(
        label: 'Category',
        labelStyle: FluentTheme.of(context).typography.bodyLarge,
        child: isSmall
            ? Wrap(
                children: List.generate(
                  categoryList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: RadioButton(
                          checked: category == null
                              ? product.category == categoryList[index]
                              : category == categoryList[index],
                          onChanged: (value) => ref
                              .read(categoryCtrlE.notifier)
                              .state = categoryList[index],
                          content: Text(
                            categoryList[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  categoryList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: RadioButton(
                          checked: category == null
                              ? product.category == categoryList[index]
                              : category == categoryList[index],
                          onChanged: (value) => ref
                              .read(categoryCtrlE.notifier)
                              .state = categoryList[index],
                          content: Text(
                            categoryList[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Card priceCard(WidgetRef ref, bool? showDiscount, bool? inStock) {
    return Card(
      child: Column(
        children: [
          editBox(
            ref: ref,
            header: 'Price',
            provider: priceCtrlE,
            placeholder: product.price.toString(),
            isExpanded: false,
            numberOnly: true,
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Default Discount?'),
              //----------------------discount switch
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ToggleSwitch(
                  focusNode: FocusNode(
                    skipTraversal: true,
                  ),
                  checked: showDiscount ?? product.haveDiscount,
                  onChanged: (value) {
                    ref.read(discountSwitchProviderE.notifier).state = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          //-----------------discount box
          showDiscount ?? product.haveDiscount
              ? editBox(
                  ref: ref,
                  header: 'Discount',
                  provider: discountCtrlE,
                  placeholder: product.discountPrice.toString(),
                  isExpanded: false,
                  numberOnly: true,
                )
              : const SizedBox(),
          const SizedBox(height: 20),
          //-----------------in stock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('In Stock?'),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ToggleSwitch(
                  focusNode: FocusNode(
                    skipTraversal: true,
                  ),
                  checked: inStock ?? product.inStock,
                  onChanged: (value) {
                    ref.read(inStockProviderE.notifier).state = value;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextBox editBox({
    required WidgetRef ref,
    required String header,
    required AutoDisposeStateProvider provider,
    required String placeholder,
    bool isExpanded = false,
    bool numberOnly = false,
  }) {
    return TextBox(
      header: header,
      onChanged: (v) {
        numberOnly
            ? ref.read(provider.notifier).state = int.parse(v)
            : ref.read(provider.notifier).state = v;
      },
      inputFormatters:
          numberOnly ? [FilteringTextInputFormatter.digitsOnly] : [],
      placeholder: placeholder,
      expands: isExpanded,
      maxLines: isExpanded ? null : 1,
      minHeight: isExpanded ? 150 : null,
      suffix: IconButton(
          icon: const Icon(FluentIcons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: placeholder));
          }),
      decoration: boxDecoration,
    );
  }
}

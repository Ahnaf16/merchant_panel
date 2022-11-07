import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/product_model.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/services/image_services.dart';
import 'package:merchant_panel/services/global_provider.dart';
import 'package:merchant_panel/widgets/text_icon.dart';

import '../../../theme/layout_manager.dart';
import '../../../theme/theme.dart';
import '../../../widgets/header.dart';
import '../local/name_brand.dart';
import '../local/selected_img.dart';
import '../local/specification_widget.dart';
import '../product_preview.dart';
import 'adding_provider.dart';

class AddProducts extends ConsumerWidget {
  const AddProducts({Key? key}) : super(key: key);
  static const routeName = '/add_products';
  publishPreview(context, model, bool isSmall) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => ContentDialog(
        constraints: BoxConstraints(
          maxWidth: isSmall
              ? double.infinity
              : MediaQuery.of(context).size.width / 1.3,
        ),
        content: ProductPreview(model: model),
      ),
    );
  }

  easyToast(conditionOn) {
    return EasyLoading.showToast(
      '$conditionOn can\'t be empty',
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = ref.watch(categoryListProvider);
    final brandList = ref.watch(brandListProvider);
    final showDiscount = ref.watch(discountSwitchProvider);
    final inStock = ref.watch(inStockProvider);
    final category = ref.watch(categoryCtrl);
    final image = ref.watch(imgSelectionProvider);
    final specificationList = ref.watch(specificationProvider);
    final ctrls = ref.read(fieldCtrlProvider.notifier);
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    publishCondition() {
      if (ctrls.nameC.text.isEmpty) {
        easyToast('name');
      } else if (ctrls.brandC.text.isEmpty) {
        easyToast('brand');
      } else if (ctrls.desC.text.isEmpty) {
        easyToast('description');
      } else if (ctrls.priceC.text.isEmpty) {
        easyToast('price');
      } else if (showDiscount && ctrls.discountC.text.isEmpty) {
        easyToast('discount');
      } else if (category == null) {
        easyToast('category');
      } else if (image.isEmpty) {
        easyToast('image');
      } else {
        EasyLoading.show();
        publishPreview(
          context,
          ProductModel(
            name: ctrls.nameC.text,
            brand: ctrls.brandC.text,
            price: ctrls.priceC.text.asInt,
            discountPrice: ctrls.discountC.text.asInt,
            haveDiscount: showDiscount,
            imgUrls: image,
            description: ctrls.desC.text,
            category: category,
            inStock: inStock,
            id: '',
            date: Timestamp.now(),
            employeeName: '',
            priority: 1,
            specifications: specificationList,
          ),
          isSmall,
        );
        EasyLoading.dismiss();
      }
    }

    return ScaffoldPage(
      header: isSmall
          ? null
          : Header(
              title: 'Add Product ',
              showLeading: false,
              commandBar: Row(
                children: [
                  FilledButton(
                    onPressed: () {
                      ctrls.clear();
                      ref.read(categoryCtrl.notifier).state = null;
                      ref.read(discountSwitchProvider.notifier).state = false;
                      ref.read(inStockProvider.notifier).state = true;
                    },
                    child: const Text('Clear'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    child: const Text('Preview Product'),
                    onPressed: () {
                      publishCondition();
                    },
                  )
                ],
              ),
            ),
      padding: const EdgeInsets.all(10),
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
                      //-------------img selection
                      Row(
                        children: [
                          TextIcon(
                            text: 'Select Image',
                            icon: FluentIcons.file_image,
                            onPressed: () => ref
                                .read(imgSelectionProvider.notifier)
                                .selectImgs(),
                            showBorder: true,
                          ),
                          if (image.isNotEmpty)
                            Button(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(FluentIcons.reset),
                                  SizedBox(width: 10),
                                  Text('Clear Image'),
                                ],
                              ),
                              onPressed: () async {
                                ref
                                    .read(imgSelectionProvider.notifier)
                                    .clearImagePath();
                              },
                            ),
                          if (isSmall) const Spacer(),
                          if (isSmall)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(8),
                                  border: Border.all(),
                                ),
                                child: IconButton(
                                  icon: const Icon(FluentIcons.clear),
                                  onPressed: () {
                                    ctrls.clear();
                                    ref.read(categoryCtrl.notifier).state =
                                        null;
                                    ref
                                        .read(discountSwitchProvider.notifier)
                                        .state = false;
                                    ref.read(inStockProvider.notifier).state =
                                        true;
                                  },
                                ),
                              ),
                            ),
                          if (isSmall)
                            FilledButton(
                              child: const Text('Preview'),
                              onPressed: () {
                                publishCondition();
                              },
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      SelectedImageList(image: image),

                      const SizedBox(height: 10),
                      NameAndBrand(ctrls: ctrls, brandList: brandList),
                      const SizedBox(height: 10),

                      if (isSmall)
                        rightWidgets(
                          ctrls,
                          showDiscount,
                          ref,
                          inStock,
                          context,
                          category,
                          categoryList,
                          isSmall,
                        ),
                      MouseRegion(
                        cursor: SystemMouseCursors.text,
                        child: Card(
                          borderRadius: BorderRadius.circular(10),
                          child: kTextBox(
                            textInputAction: TextInputAction.newline,
                            header: 'Description',
                            controller: ctrls.desC,
                            isExpanded: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isSmall)
                        categoryWidget(
                            context, category, ref, isSmall, categoryList),
                      const SizedBox(height: 20),

                      SpecificationWidget(
                        ctrls: ctrls,
                        specificationList: specificationList,
                      ),
                    ],
                  ),
                ),
              ),
              //--------------------------right side
              if (!isSmall) const SizedBox(width: 20),
              if (!isSmall)
                Expanded(
                  child: rightWidgets(
                    ctrls,
                    showDiscount,
                    ref,
                    inStock,
                    context,
                    category,
                    categoryList,
                    isSmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Column rightWidgets(
    AddProductsNotifier ctrls,
    bool showDiscount,
    WidgetRef ref,
    bool inStock,
    BuildContext context,
    String? category,
    List<String> categoryList,
    bool isSmall,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //-------------price and stock
        Card(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              kTextBox(
                header: 'Price',
                numberOnly: true,
                controller: ctrls.priceC,
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
                      checked: showDiscount,
                      onChanged: (value) {
                        ref.read(discountSwitchProvider.notifier).state = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //-----------------discount box
              if (showDiscount)
                kTextBox(
                  header: 'Discount',
                  numberOnly: true,
                  controller: ctrls.discountC,
                ),
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
                      checked: inStock,
                      onChanged: (value) {
                        ref.read(inStockProvider.notifier).state = value;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (!isSmall)
          categoryWidget(
            context,
            category,
            ref,
            isSmall,
            categoryList,
          ),
      ],
    );
  }

  Card categoryWidget(BuildContext context, String? category, WidgetRef ref,
      bool isSmall, List<String> categoryList) {
    return Card(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: FluentTheme.of(context).typography.bodyLarge,
              ),
              category != null
                  ? IconButton(
                      icon: const Icon(FluentIcons.reset),
                      onPressed: () {
                        ref.read(categoryCtrl.notifier).state = null;
                      },
                    )
                  : const SizedBox(),
            ],
          ),
          if (isSmall)
            Wrap(
              children: List.generate(
                categoryList.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: RadioButton(
                        checked: category == categoryList[index],
                        onChanged: (value) => ref
                            .read(categoryCtrl.notifier)
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
          if (!isSmall)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                categoryList.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: RadioButton(
                        checked: category == categoryList[index],
                        onChanged: (value) => ref
                            .read(categoryCtrl.notifier)
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
        ],
      ),
    );
  }

  Column leftWidgets(
    WidgetRef ref,
    List<String> image,
    AddProductsNotifier ctrls,
    List<dynamic> brandList,
    Map<String, String> specificationList,
    bool isSmall,
    bool showDiscount,
    bool inStock,
    List<String> categoryList,
    String? category,
    BuildContext context,
    Function publishCondition,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        //-------------img selection
        Row(
          children: [
            TextIcon(
              text: 'Select Image',
              icon: FluentIcons.file_image,
              onPressed: () =>
                  ref.read(imgSelectionProvider.notifier).selectImgs(),
              showBorder: true,
            ),
            if (image.isNotEmpty)
              Button(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(FluentIcons.reset),
                    SizedBox(width: 10),
                    Text('Clear Image'),
                  ],
                ),
                onPressed: () async {
                  ref.read(imgSelectionProvider.notifier).clearImagePath();
                },
              ),
            if (isSmall) const Spacer(),
            if (isSmall)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(8),
                    border: Border.all(),
                  ),
                  child: IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: () {
                      ctrls.clear();
                      ref.read(categoryCtrl.notifier).state = null;
                      ref.read(discountSwitchProvider.notifier).state = false;
                      ref.read(inStockProvider.notifier).state = true;
                    },
                  ),
                ),
              ),
            if (isSmall)
              FilledButton(
                child: const Text('Preview'),
                onPressed: () {
                  publishCondition();
                },
              ),
          ],
        ),

        const SizedBox(height: 10),

        SelectedImageList(image: image),

        const SizedBox(height: 10),
        NameAndBrand(ctrls: ctrls, brandList: brandList),
        const SizedBox(height: 10),

        if (isSmall)
          rightWidgets(
            ctrls,
            showDiscount,
            ref,
            inStock,
            context,
            category,
            categoryList,
            isSmall,
          ),
        MouseRegion(
          cursor: SystemMouseCursors.text,
          child: Card(
            borderRadius: BorderRadius.circular(10),
            child: kTextBox(
              textInputAction: TextInputAction.newline,
              header: 'Description',
              controller: ctrls.desC,
              isExpanded: true,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (isSmall)
          categoryWidget(context, category, ref, isSmall, categoryList),
        const SizedBox(height: 20),

        SpecificationWidget(
          ctrls: ctrls,
          specificationList: specificationList,
        ),
      ],
    );
  }
}

TextBox kTextBox({
  required String header,
  required TextEditingController controller,
  bool numberOnly = false,
  bool isExpanded = false,
  double maxHeight = 150,
  bool readOnly = false,
  bool skipTraversal = false,
  TextInputAction? textInputAction,
}) {
  return TextBox(
    controller: controller,
    textInputAction: textInputAction,
    header: header,
    readOnly: readOnly,
    inputFormatters:
        numberOnly == true ? [FilteringTextInputFormatter.digitsOnly] : [],
    maxLines: isExpanded ? null : 1,
    minHeight: isExpanded ? maxHeight : null,
    expands: isExpanded,
    suffixMode: OverlayVisibilityMode.editing,
    suffix: IconButton(
      icon: const Icon(FluentIcons.clear),
      onPressed: () {
        controller.clear();
      },
    ),
    decoration: boxDecoration,
  );
}

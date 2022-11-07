// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show SelectionArea;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/services/image_services.dart';
import 'package:merchant_panel/services/product/product_services.dart';
import '../../widgets/widget_export.dart';
import 'product_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProductPreview extends ConsumerWidget {
  const ProductPreview({
    Key? key,
    required this.model,
    this.showPublishButton = true,
  }) : super(key: key);

  final bool showPublishButton;

  final ProductModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeTheme = FluentTheme.of(context).typography;
    return SelectionArea(
      child:
          //  ScaffoldPage(
          // header: PageHeader(
          //   leading: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child: IconButton(
          //       icon: const Icon(FluentIcons.back, size: 20),
          //       onPressed: () => Navigator.pop(context),
          //     ),
          //   ),
          // commandBar: showPublishButton
          //     ? FilledButton(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: const [
          //             Icon(FluentIcons.upload),
          //             Text('Publish'),
          //           ],
          //         ),
          //         onPressed: () async {
          //           final urls = await UploadImage.uploadMultiImage(
          //             fileName: model.name,
          //             imgPaths: model.imgUrls,
          //             price: model.price,
          //           );
          //           await ProductServices.addProducts(
          //             product: model.copyWith(
          //               imgUrls: urls,
          //             ),
          //           );
          //           Navigator.pop(context);
          //         },
          //       )
          //     : const SizedBox(),
          // ),
          // content:
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FluentIcons.back, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (showPublishButton) const Spacer(),
                  if (showPublishButton)
                    FilledButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(FluentIcons.upload),
                          Text('Publish'),
                        ],
                      ),
                      onPressed: () async {
                        final urls = await UploadImage.uploadMultiImage(
                          fileName: model.name,
                          imgPaths: model.imgUrls,
                          price: model.price,
                        );
                        await ProductServices.addProducts(
                          product: model.copyWith(
                            imgUrls: urls,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              Wrap(
                children: List.generate(
                  model.imgUrls.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: '$index',
                          child: kIsWeb || !showPublishButton
                              ? CachedNetImg(
                                  url: model.imgUrls[index],
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(model.imgUrls[index]),
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(),
              ),
              //------------------name
              Text(
                model.name,
                style: typeTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              //------------------price
              Text(
                'Price: ${model.price.toCurrency()}',
                style: typeTheme.bodyLarge,
              ),
              //------------------Discount
              Text(
                'Discount: ${model.discountPrice.toCurrency()}',
                style: typeTheme.bodyLarge,
              ),
              //------------------brand
              Text(
                'Brand: ${model.brand}',
                style: typeTheme.bodyLarge,
              ),
              //------------------category
              Text(
                'Brand: ${model.category}',
                style: typeTheme.bodyLarge,
              ),
              //------------------variant
              Text(
                'Variant :',
                style: typeTheme.bodyLarge,
              ),
              Text(
                model.specifications.isEmpty
                    ? 'Variant : N/A'
                    : model.specifications['RAM'] == null ||
                            model.specifications['RAM'] == null
                        ? 'Variant : N/A'
                        : 'Variant : ${model.specifications['RAM']}, ${model.specifications['Storage']}',
                style: typeTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              //------------------description
              Text(
                'Description :',
                style: typeTheme.bodyLarge,
              ),

              Text(model.description.trim()),
              const SizedBox(height: 10),
              Text(
                'Specifications :',
                style: typeTheme.bodyLarge,
              ),
              ListView.builder(
                itemCount: model.specifications.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    '${model.specifications.keys.elementAt(index)}: ${model.specifications.values.elementAt(index)}',
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}

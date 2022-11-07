// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/product_model.dart';
import 'package:merchant_panel/extension/extensions.dart';

import '../../../services/product/product_services.dart';
import '../../../widgets/cached_net_img.dart';

class AfterEditPreview extends ConsumerWidget {
  const AfterEditPreview({
    required this.product,
    required this.category,
    required this.showDiscount,
    required this.inStock,
    required this.name,
    required this.brand,
    required this.des,
    required this.price,
    required this.discount,
    super.key,
  });

  final String? category;
  final bool? showDiscount;
  final bool? inStock;
  final String? name;
  final String? brand;
  final String? des;
  final int? price;
  final int? discount;

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            leading: IconButton(
              icon: const Icon(FluentIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
            commandBar: FilledButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(FluentIcons.upload),
                  Text('Update'),
                ],
              ),
              onPressed: () async {
                await ProductServices.updateProducts(
                    product: product.copyWith(
                  name: name,
                  brand: brand,
                  description: des,
                  price: price,
                  discountPrice: discount,
                  category: category,
                  inStock: inStock,
                  haveDiscount: showDiscount,
                ));
                Navigator.pop(context);
              },
            ),
          ),
          Wrap(
            children: List.generate(
              product.imgUrls.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: '$index',
                    child: CachedNetImg(
                      url: product.imgUrls[index],
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
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
          Text(
            'Name: ${name == null ? product.name : '${product.name} ------> ${name!}'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'Brand: ${brand == null ? product.brand : '${product.brand}------> ${brand!}'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'Description: ${des == null ? product.description : '${product.description}------> ${des!}'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'Price: ${price == null ? product.price.toCurrency() : '${product.price.toCurrency()}------> ${price!.toCurrency()}'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'Discount: ${discount == null ? product.discountPrice.toCurrency() : '${product.discountPrice.toCurrency()}------> ${discount!.toCurrency()}'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'Have Discount: ${showDiscount == null ? product.haveDiscount : '${product.haveDiscount}------> $showDiscount'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'Category: ${category == null ? product.category : '${product.category}------> ${category!}'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'In Stock: ${inStock == null ? product.inStock.toString() : '${product.inStock}------> $inStock'}',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          Text(
            'Specifications :',
            style: FluentTheme.of(context)
                .typography
                .bodyLarge!
                .copyWith(color: name == null ? null : Colors.green),
          ),
          ListView.builder(
            itemCount: product.specifications.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                '${product.specifications.keys.elementAt(index)}: ${product.specifications.values.elementAt(index)}',
                style: FluentTheme.of(context)
                    .typography
                    .bodyLarge!
                    .copyWith(color: name == null ? null : Colors.green),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

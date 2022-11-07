import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/product_model.dart';
import 'package:merchant_panel/app/products/product_preview.dart';
import 'package:merchant_panel/auth/employee/employee_provider.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/services/image_services.dart';
import 'package:merchant_panel/services/product/product_services.dart';
import 'package:merchant_panel/theme/layout_manager.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/theme/theme_manager.dart';
import '../../widgets/cached_net_img.dart';
import '../../widgets/custom_clips.dart';
import '../../widgets/delete_button.dart';
import 'edit/edit_products.dart';

class ProductsTile extends ConsumerWidget {
  ProductsTile({
    Key? key,
    required this.items,
  }) : super(key: key);

  final ProductModel items;
  final FlyoutController flyCtrl = FlyoutController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final roles = ref.watch(roleProvider(uid));
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return Stack(
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Hero(
                  tag: items.id,
                  child: CachedNetImg(
                    url: items.imgUrls[0],
                    fit: BoxFit.contain,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                items.name.showUntil(40),
              ),
              const SizedBox(height: 5),
              if (items.specifications.isNotEmpty)
                Text(
                  items.specifications['RAM'] == null ||
                          items.specifications['Storage'] == null
                      ? 'Variant : N/A'
                      : '(${items.specifications['RAM']}, ${items.specifications['Storage']})',
                ),
              const SizedBox(height: 5),
              Text(
                items.price.toCurrency(),
                style: TextStyle(
                  fontSize: items.haveDiscount ? 15 : 18,
                  fontWeight: items.haveDiscount ? null : FontWeight.bold,
                  decoration:
                      items.haveDiscount ? TextDecoration.lineThrough : null,
                ),
              ),
              if (items.haveDiscount) const SizedBox(height: 10),
              if (items.haveDiscount)
                Text(
                  items.discountPrice.toCurrency(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                items.inStock ? 'In Stock' : 'Out of Stock',
                style: textTheme(context).body!.copyWith(
                      color: items.inStock
                          ? Colors.black
                          : Colors.warningPrimaryColor,
                    ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Flyout(
                  openMode: FlyoutOpenMode.press,
                  content: (context) => MenuFlyout(
                    items: [
                      MenuFlyoutItem(
                        text: const Text('View'),
                        leading: const Icon(FluentIcons.view),
                        onPressed: () {
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (_) => ContentDialog(
                              constraints: BoxConstraints(
                                maxWidth: isSmall
                                    ? double.infinity
                                    : MediaQuery.of(context).size.width / 1.3,
                              ),
                              content: ProductPreview(
                                model: items,
                                showPublishButton: false,
                              ),
                            ),
                          );
                        },
                      ),
                      MenuFlyoutItem(
                        text: const Text('Edit'),
                        leading: const Icon(FluentIcons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, EditProduct.routeName,
                              arguments: items);
                        },
                      ),
                      if (roles.canDeleteItem())
                        MenuFlyoutItem(
                          text: const Text(
                            'Remove',
                            style: TextStyle(
                              color: Colors.warningPrimaryColor,
                            ),
                          ),
                          leading: const Icon(
                            FluentIcons.delete,
                            color: Colors.warningPrimaryColor,
                          ),
                          onPressed: () async {
                            await deleteButtonDialog(
                              context: context,
                              onDelete: () {
                                ProductServices.deleteProducts(
                                  product: items,
                                );
                                UploadImage.deleteImage(
                                    fileName: items.name,
                                    path: 'products_image');

                                EasyLoading.showToast(
                                  'Product Deleted',
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom,
                                );

                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      MenuFlyoutItem(
                        text: const Text('In stock'),
                        leading: const Icon(FluentIcons.packages),
                        trailing: Checkbox(
                          checked: items.inStock,
                          onChanged: (v) {
                            ProductServices.stockChange(product: items);
                          },
                        ),
                        onPressed: () {},
                      ),
                      MenuFlyoutItem(
                        text: Text('Preority > ${items.priority}'),
                        leading: const Icon(FluentIcons.chevron_unfold10),
                        trailing: Row(
                          children: [
                            IconButton(
                              icon: const Icon(FluentIcons.add),
                              onPressed: () {
                                ProductServices.changePriority(
                                  product: items,
                                  isIncrement: true,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(FluentIcons.remove),
                              onPressed: () {
                                ProductServices.changePriority(
                                  product: items,
                                  isIncrement: false,
                                );
                              },
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: boxDecoration,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(FluentIcons.more),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (items.haveDiscount)
          Positioned(
            right: 0,
            child: ClipPath(
              clipper: DiscountClipper(),
              child: Container(
                color: Colors.blue,
                height: 30,
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight + const Alignment(-0.3, 0),
                  child: Text(
                    items.price.discountPercent(items.discountPrice),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

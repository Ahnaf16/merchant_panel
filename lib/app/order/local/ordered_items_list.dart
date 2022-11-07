import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/products/product_preview.dart';
import 'package:merchant_panel/extension/extensions.dart';

import '../../../services/product/product_services.dart';
import '../../../theme/theme_manager.dart';
import '../../../widgets/cached_net_img.dart';
import '../../../widgets/error_widget.dart';
import '../order_model.dart';

class OrderedItemList extends ConsumerWidget {
  const OrderedItemList({
    required this.order,
    Key? key,
  }) : super(key: key);
  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: order.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = order.items[index];
          final product = ref.watch(singleItemProvider(item.id));
          return product.when(
            data: (product) => Card(
              child: ListTile(
                title: Text.rich(
                  TextSpan(
                    text: item.name.showUntil(20),
                    children: [
                      const TextSpan(text: '\n'),
                      TextSpan(
                        style: textTheme(context).body,
                        text: product.specifications.isEmpty
                            ? 'Variant : N/A'
                            : product.specifications['RAM'] == null ||
                                    product.specifications['RAM'] == null
                                ? 'Variant : N/A'
                                : 'Variant : ${product.specifications['RAM']}, ${product.specifications['Storage']}',
                      ),
                    ],
                  ),
                  style: textTheme(context).bodyLarge,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetImg(
                    url: item.img,
                    fit: BoxFit.contain,
                    height: 60,
                    width: 60,
                  ),
                ),
                trailing: Text.rich(
                  TextSpan(
                    text: item.price.toCurrency(),
                    children: [
                      TextSpan(
                        text: '  x  ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      TextSpan(
                        text: '\nTotal : ${item.total.toCurrency()}',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.end,
                ),
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (context) => ProductPreview(
                      model: product,
                      showPublishButton: false,
                    ),
                  );
                },
              ),
            ),
            error: (error, st) => KErrorWidget(error: error, st: st),
            loading: () => const LoadingWidget(),
          );
        },
      ),
    );
  }
}

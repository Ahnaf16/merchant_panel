import 'package:fluent_ui/fluent_ui.dart' show ContentDialog;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/auth/customer%20models/cart_model.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/theme/theme_manager.dart';

import '../../../services/product/product_services.dart';
import '../../../widgets/cached_net_img.dart';
import '../../../widgets/error_widget.dart';
import '../../products/product_preview.dart';

class OrderItemsTable extends ConsumerWidget {
  const OrderItemsTable({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final List<CartModel> cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DataTable(
        showBottomBorder: true,
        dividerThickness: 2,
        dataRowHeight: 70,
        columns: const [
          DataColumn(
            label: Text('Product'),
          ),
          DataColumn(
            numeric: true,
            label: Text('Quantity'),
          ),
          DataColumn(
            numeric: true,
            label: Text('Price'),
          ),
          DataColumn(
            numeric: true,
            label: Text('Total'),
          ),
        ],
        rows: List.generate(
          cart.length,
          (inx) {
            final item = ref.watch(singleItemProvider(cart[inx].id));
            return DataRow(
              cells: [
                item.when(
                  data: (data) => DataCell(
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetImg(
                            url: cart[inx].img,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text.rich(
                          TextSpan(
                            text: cart[inx].name.showUntil(50),
                            children: [
                              const TextSpan(text: '\n'),
                              TextSpan(
                                style: textTheme(context).body,
                                text: data.specifications.isEmpty
                                    ? 'Variant : N/A'
                                    : data.specifications['RAM'] == null ||
                                            data.specifications['RAM'] == null
                                        ? 'Variant : N/A'
                                        : 'Variant : ${data.specifications['RAM']}, ${data.specifications['Storage']}',
                              ),
                              const TextSpan(text: '\n'),
                              WidgetSpan(
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ContentDialog(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5),
                                        title: const Text('Product Details'),
                                        content: ProductPreview(
                                            model: data,
                                            showPublishButton: false),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.orange.shade900),
                                  child: const Text('show details'),
                                ),
                              ),
                            ],
                          ),
                          style: textTheme(context).bodyLarge,
                        ),
                      ],
                    ),
                    // onTap: () {
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) => AlertDialog(
                    //       title: const Text('Product Details'),
                    //       content: ProductPreview(
                    //           model: data, showPublishButton: false),
                    //     ),
                    //   );
                    // },
                  ),
                  loading: () => const DataCell(
                    CircularProgressIndicator(),
                  ),
                  error: (error, st) => DataCell(
                    KErrorWidget(error: error, st: st),
                  ),
                ),
                DataCell(
                  Text(cart[inx].quantity.toString()),
                ),
                DataCell(
                  Text(cart[inx].price.toCurrency()),
                ),
                DataCell(
                  Text(cart[inx].total.toCurrency()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

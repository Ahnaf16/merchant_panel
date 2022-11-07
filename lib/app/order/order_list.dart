import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:merchant_panel/app/order/order_providers.dart';
import 'package:merchant_panel/widgets/body_base.dart';

import '../../services/order/pagination_order_list.dart';
import '../../theme/layout_manager.dart';
import '../../theme/theme.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/header.dart';
import 'local/export_order.dart';
import 'local/order_count.dart';
import 'local/order_list_tile.dart';
import 'local/search_and_status.dart';
import 'local/sf_data_table.dart';

class OrderList extends ConsumerWidget {
  const OrderList({Key? key}) : super(key: key);
  static const routeName = '/order_list';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(paymentMethodList);
    final selectedPayment = ref.watch(selectedPaymentMathod);
    final orderList = ref.watch(ordersPaginationProvider);
    final ordersFnc = ref.read(ordersPaginationProvider.notifier);
    final status = ref.watch(selectedOrderStatus);
    final layout = ref.read(layoutProvider(context));
    final from = ref.watch(selectedFromDate);
    final to = ref.watch(selectedToDate);
    final now = DateTime.now();
    final current = DateTime(now.year, now.month, now.day);
    return ScaffoldPage(
      padding: layout.isSmallScreen ? EdgeInsets.zero : null,
      header: layout.isSmallScreen
          ? null
          : Header(
              title: 'Orders',
              showLeading: false,
              commandBar: FilledButton(
                child: const Text('Export'),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => const ExportDialog(),
                  );
                },
              ),
            ),
      content: Stack(
        children: [
          Padding(
            padding: layout.isSmallScreen
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 10),
            child: BaseBody(
              widthFactor: layout.isSmallScreen ? 1 : 1.2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SearchAndStatus(),
                Wrap(
                  children: [
                    PillButtonBar(
                      selected: selectedPayment,
                      onChanged: (value) {
                        ref.read(selectedPaymentMathod.notifier).state = value;
                        if (value == 0) {
                          ordersFnc.firstFetch();
                        } else {
                          ordersFnc.filter(
                            paySys: paymentMethod[value],
                            status: status,
                            from: from,
                            to: to,
                          );
                        }
                      },
                      items: paymentMethod
                          .map(
                            (text) => PillButtonBarItem(
                              text: Text(text),
                            ),
                          )
                          .toList(),
                    ),
                    if (ordersFnc.searchCtrl.text.isNotEmpty ||
                        status != null ||
                        selectedPayment != 0 ||
                        from != null ||
                        to != current)
                      TextButton(
                        child: const Text('Clear Filter'),
                        onPressed: () {
                          ordersFnc.searchCtrl.clear();
                          ref.read(selectedOrderStatus.notifier).state = null;
                          ref.read(selectedPaymentMathod.notifier).state = 0;
                          ordersFnc.firstFetch();
                          ref.read(selectedFromDate.notifier).state = null;
                          ref.read(selectedToDate.notifier).state = current;
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                const OrdersCount(),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                orderList.when(
                  data: (orders) => orders.isEmpty
                      ? Container(
                          height: 80,
                          decoration:
                              boxDecoration.copyWith(color: Colors.grey[30]),
                          child: const Center(
                            child: Text('E M P T Y'),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!layout.isSmallScreen)
                              SFDataGrid(orders: orders),
                            if (layout.isSmallScreen)
                              ...orders
                                  .map((order) => OrderListTile(order: order))
                                  .toList(),
                            const SizedBox(height: 20),
                            OutlinedButton(
                              child: const Text('show more'),
                              onPressed: () {
                                ordersFnc.loadMore(
                                  orders.last,
                                  status: status,
                                  paySys: paymentMethod[selectedPayment],
                                  from: from,
                                  to: to,
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                  error: (error, st) => KErrorWidget(error: error, st: st),
                  loading: () => const LoadingWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

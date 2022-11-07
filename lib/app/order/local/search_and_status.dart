import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_providers.dart';

import '../../../services/order/pagination_order_list.dart';
import '../../../theme/layout_manager.dart';
import '../../../theme/theme.dart';
import '../order_enums.dart';

class SearchAndStatus extends ConsumerWidget {
  const SearchAndStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(selectedOrderStatus);
    // final allStatus = getOrderStatusList;
    final ordersFnc = ref.read(ordersPaginationProvider.notifier);
    final paymentMethod = ref.watch(paymentMethodList);
    final selectedPayment = ref.watch(selectedPaymentMathod);
    final from = ref.watch(selectedFromDate);
    final to = ref.watch(selectedToDate);
    final layout = ref.read(layoutProvider(context));

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.start,
        children: [
          InfoLabel(
            label: 'Search',
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 150,
                maxWidth: layout.isSmallScreen
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width * .3,
              ),
              child: TextBox(
                controller: ordersFnc.searchCtrl,
                onSubmitted: (text) {
                  ordersFnc.focus.requestFocus();
                  if (text.isNotEmpty) {
                    ordersFnc.search();
                  } else {
                    ordersFnc.firstFetch();
                  }
                },
                focusNode: ordersFnc.focus,
                padding: const EdgeInsets.all(8),
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(FluentIcons.search),
                    onPressed: () {
                      if (ordersFnc.searchCtrl.text.isNotEmpty) {
                        ordersFnc.search();
                      } else {
                        ordersFnc.firstFetch();
                      }
                    },
                  ),
                ),
                suffix: IconButton(
                  icon: const Icon(FluentIcons.clear),
                  onPressed: () {
                    ordersFnc.searchCtrl.clear();
                    ordersFnc.firstFetch();
                  },
                ),
                suffixMode: OverlayVisibilityMode.editing,
                decoration: boxDecoration,
              ),
            ),
          ),

          InfoLabel(
            label: 'From',
            child: Container(
              decoration: boxDecoration,
              child: DatePicker(
                selected: from,
                onChanged: (date) {
                  final current = DateTime(date.year, date.month, date.day);

                  ordersFnc.filter(
                    status: selectedStatus,
                    paySys: paymentMethod[selectedPayment],
                    to: to,
                    from: current,
                  );
                  ref.read(selectedFromDate.notifier).state = current;
                },
              ),
            ),
          ),

          InfoLabel(
            label: 'To',
            child: Container(
              decoration: boxDecoration,
              child: DatePicker(
                selected: to,
                onChanged: (date) {
                  ordersFnc.filter(
                      status: selectedStatus,
                      paySys: paymentMethod[selectedPayment],
                      to: date,
                      from: from);
                  ref.read(selectedToDate.notifier).state = date;
                },
              ),
            ),
          ),

          //-----------------status
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 150,
              maxWidth: 300,
            ),
            child: InfoLabel(
              label: 'Status',
              child: Container(
                decoration: boxDecoration,
                child: ComboBox<OrderStatus>(
                  isExpanded: true,
                  placeholder: const Text('All'),
                  items: OrderStatus.values
                      .map(
                        (status) => ComboBoxItem(
                          value: status,
                          child: Row(
                            children: [
                              Icon(status.icon),
                              const SizedBox(width: 10),
                              Text(status.toString()),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  value: selectedStatus,
                  onChanged: (value) {
                    ordersFnc.filter(
                      from: from,
                      to: to,
                      status: value,
                      paySys: paymentMethod[selectedPayment],
                    );
                    ref.read(selectedOrderStatus.notifier).state = value;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (selectedStatus != null)
            IconButton(
              icon: const Icon(FluentIcons.reset),
              onPressed: () {
                ordersFnc.firstFetch();
                ref.read(selectedOrderStatus.notifier).state = null;
              },
            ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_enums.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/services/export%20api/export_services.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/text_icon.dart';

import '../../../services/export api/export_providers.dart';
import '../../../theme/layout_manager.dart';

class ExportDialog extends ConsumerWidget {
  const ExportDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.read(layoutProvider(context));
    final from = ref.watch(fromDate);
    final to = ref.watch(toDate);
    final status = ref.watch(selectedStatus);
    final now = DateTime.now();
    final current = DateTime(now.year, now.month, now.day);

    return ContentDialog(
      constraints: BoxConstraints(
          maxWidth: layout.isSmallScreen
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: 10,
            children: [
              InfoLabel(
                label: 'From',
                child: Container(
                  decoration: boxDecoration,
                  child: DatePicker(
                    selected: from,
                    onChanged: (date) {
                      ref.read(fromDate.notifier).state = date;
                      log(date.toFormatDate('hh:mm a, dd-MMM-yyyy'));
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
                      ref.read(toDate.notifier).state = date;
                      log(date.toFormatDate('hh:mm a, dd-MMM-yyyy'));
                    },
                  ),
                ),
              ),
              TextIcon(
                text: '${to.difference(from).inDays + 1}',
                showBorder: true,
                icon: FluentIcons.clock,
                verticalMargin: 7,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                decoration: boxDecoration,
                child: ComboBox<OrderStatus>(
                  isExpanded: true,
                  placeholder: const Text('status'),
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
                  value: status,
                  onChanged: (value) {
                    ref.read(selectedStatus.notifier).state = value;
                  },
                ),
              ),
              if (status != null || from != current || to != current)
                TextButton(
                  child: const Text('Clear all'),
                  onPressed: () {
                    ref.read(selectedStatus.notifier).state = null;
                    ref.read(fromDate.notifier).state = current;
                    ref.read(toDate.notifier).state = current;
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Chip(
                text: const Text('7 Days'),
                onPressed: () {
                  final now = DateTime.now();
                  ref.read(fromDate.notifier).state = now.subtract(
                    const Duration(days: 7),
                  );
                },
              ),
              const SizedBox(width: 5),
              Chip(
                text: const Text('15 Days'),
                onPressed: () {
                  final now = DateTime.now();
                  ref.read(fromDate.notifier).state = now.subtract(
                    const Duration(days: 15),
                  );
                },
              ),
              const SizedBox(width: 5),
              Chip(
                text: const Text('This Month'),
                onPressed: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month);

                  ref.read(fromDate.notifier).state = start;
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          style: hoveringButtonsStyle(Colors.warningPrimaryColor),
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        OrderListBySelectedDate(
          fileName: 'orders_${from.toFormatDate()}_to_${to.toFormatDate()}',
        ),
      ],
    );
  }
}

class OrderListBySelectedDate extends ConsumerWidget {
  const OrderListBySelectedDate({Key? key, required this.fileName})
      : super(key: key);

  final String fileName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderList = ref.watch(exportOrderList);
    return orderList.when(
      data: (orders) => TextButton(
        style: hoveringButtonsStyle(Colors.successPrimaryColor),
        child: Text('Export total ${orders.length} orders'),
        onPressed: () {
          ExportApi.createExcel(
            orderList: orders,
            fileName: fileName,
          );
        },
      ),
      error: (error, st) => KErrorWidget(error: error, st: st),
      loading: () => const LoadingWidget(),
    );
  }
}

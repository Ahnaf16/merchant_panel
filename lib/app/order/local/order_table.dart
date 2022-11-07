import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show SelectionArea;
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/services/order/orders_services.dart';

import '../../../theme/theme.dart';
import '../order_details.dart';
import '../order_providers.dart';
import 'change_status.dart';

class OrderListTable extends ConsumerWidget {
  const OrderListTable({
    Key? key,
    required this.orders,
    this.notEditable = false,
  }) : super(key: key);
  final List<OrderModel> orders;
  final bool notEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnTitle = ref.watch(columnTitlesProvider);
    return SelectionArea(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
          6: FixedColumnWidth(70),
          7: FlexColumnWidth(1),
          8: FlexColumnWidth(1),
        },
        border: TableBorder.symmetric(
          inside: BorderSide(
            color: Colors.grey.withOpacity(.1),
            width: 1,
          ),
        ),
        children: [
          TableRow(
            children: [
              ...columnTitle.map(
                (title) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                ),
              ),
            ],
          ),
          ...List.generate(
            orders.length,
            (indexO) => TableRow(
              children: [
                ...List.generate(
                  columnTitle.length - 3,
                  (index) {
                    final List<String?> dataList = [
                      '${indexO + 1}',
                      orders[indexO].invoice,
                      orders[indexO].address.name,
                      orders[indexO].address.billingNumber,
                      orders[indexO].total.toCurrency(),
                      orders[indexO].timeLine.last.comment.showUntil(20),
                    ];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tooltip(
                        message: notEditable
                            ? ''
                            : (index == 1 || index == 2 || index == 3
                                ? 'Click to copy'
                                : ''),
                        child: Text.rich(
                          TextSpan(
                            text: '${dataList[index]}  ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = notEditable
                                  ? null
                                  : () {
                                      if (index == 1 ||
                                          index == 2 ||
                                          index == 3) {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: dataList[index].toString(),
                                          ),
                                        );
                                        EasyLoading.showToast(
                                          'copied to clipboard',
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom,
                                        );
                                      }
                                    },
                            children: [
                              if (index == 4)
                                if (orders[indexO].voucher != 0)
                                  const WidgetSpan(
                                    child: Icon(FluentIcons.ticket),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: orders[indexO].paymentMethod.toIcon(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: ExtLogic.colorLog(orders[indexO].status)
                            .withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text(orders[indexO].status)),
                    ),
                    if (!notEditable)
                      IconButton(
                          onPressed: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) =>
                                  ChangeStatusWidget(orders[indexO]),
                            );
                          },
                          icon: const Icon(FluentIcons.edit))
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (!notEditable) {
                      Navigator.pushNamed(
                        context,
                        OrderDetails.routeName,
                        arguments: orders[indexO].docID,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          orders[indexO]
                              .orderDate
                              .toFormatDate('hh:MM a\ndd-MM-yyyy'),
                        ),
                      ),
                      const Spacer(),
                      if (!notEditable)
                        Container(
                          decoration: boxDecoration,
                          child: IconButton(
                            style: ButtonStyle(
                              padding: ButtonState.all(
                                const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                              ),
                            ),
                            icon: const Icon(FluentIcons.more),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetails.routeName,
                                arguments: orders[indexO].docID,
                              );
                            },
                          ),
                        ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

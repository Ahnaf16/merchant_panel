import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart' show SelectionArea;

import '../../../services/order/orders_services.dart';
import '../../../theme/theme.dart';
import '../order_details.dart';
import '../order_model.dart';
import '../order_providers.dart';
import 'change_status.dart';

class SFDataGrid extends ConsumerWidget {
  const SFDataGrid({
    super.key,
    required this.orders,
  });

  final List<OrderModel> orders;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columnTitle = ref.watch(columnTitlesProvider);

    return SelectionArea(
      child: Container(
        decoration: boxDecoration,
        child: SfDataGrid(
          shrinkWrapRows: true,
          source: SFdataSource(orders, columnTitle, context),
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          headerRowHeight: 35,
          columns: [
            ...List.generate(
              columnTitle.length,
              (index) {
                final title = columnTitle[index];
                return GridColumn(
                  columnWidthMode: index == 0
                      ? ColumnWidthMode.fitByCellValue
                      : ColumnWidthMode.fill,
                  columnName: title,
                  label: Center(
                    child: Text(title),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class SFdataSource extends DataGridSource {
  final BuildContext context;
  SFdataSource(
    List<OrderModel> orders,
    this.columnTitle,
    this.context,
  ) {
    dataRows = List.generate(orders.length, (index) {
      final order = orders[index];
      Widget textWidget(String text, [bool canCopy = true]) {
        return Center(
          child: Text.rich(
            TextSpan(
              text: text,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (canCopy) {
                    Clipboard.setData(
                      ClipboardData(
                        text: text,
                      ),
                    );
                    EasyLoading.showToast(
                      'copied to clipboard',
                      toastPosition: EasyLoadingToastPosition.bottom,
                    );
                  }
                },
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      final List<Widget> dataList = [
        SizedBox(
          width: 50,
          child: Center(
            child: Text('${index + 1}'),
          ),
        ),
        textWidget(order.invoice),
        textWidget(order.address.name),
        textWidget(order.address.billingNumber),
        textWidget(order.total.toCurrency(), false),
        textWidget(order.timeLine.last.comment.showUntil(20), false),
        Center(
          child: order.paymentMethod.toIcon(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                color: ExtLogic.colorLog(order.status).withOpacity(.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(order.status),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => ChangeStatusWidget(order),
                );
              },
              icon: const Icon(FluentIcons.edit),
            ),
          ],
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                OrderDetails.routeName,
                arguments: order.docID,
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    order.orderDate.toFormatDate('hh:MM a\ndd-MM-yyyy'),
                  ),
                ),
                const Spacer(),
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
                        arguments: order.docID,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ];

      return DataGridRow(
        cells: [
          ...List.generate(
            columnTitle.length,
            (columnIndex) {
              return DataGridCell(
                columnName: columnIndex.toString(),
                value: dataList[columnIndex],
              );
            },
          ),
        ],
      );
    });
  }
  List<String> columnTitle;
  late List<DataGridRow> dataRows;
  @override
  List<DataGridRow> get rows => dataRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>(
            (cell) => cell.value,
          )
          .toList(),
    );
  }
}

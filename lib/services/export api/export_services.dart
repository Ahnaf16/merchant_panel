import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../app/order/order_model.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:merchant_panel/extension/extensions.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' as html;

class ExportApi {
  static Future<void> createExcel(
      {required List<OrderModel> orderList,
      String fileName = 'ordersOutput'}) async {
    EasyLoading.show();
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    List<ExcelDataRow> buildReportDataRows() {
      List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

      excelDataRows = orderList.map<ExcelDataRow>((OrderModel order) {
        return ExcelDataRow(
          cells: [
            ExcelDataCell(columnHeader: 'INVOICE', value: order.invoice),
            ExcelDataCell(columnHeader: 'Name', value: order.address.name),
            ExcelDataCell(
                columnHeader: 'Address',
                value:
                    '${order.address.division},${order.address.district},${order.address.address}'),
            ExcelDataCell(
                columnHeader: 'Contact', value: order.address.billingNumber),
            ExcelDataCell(
                columnHeader: 'Products',
                value: order.items.map((item) => item.name).join(',')),
            ExcelDataCell(
                columnHeader: 'Quantity',
                value: order.items.map((item) => item.quantity).join(',')),
            ExcelDataCell(columnHeader: 'Total', value: order.total),
            ExcelDataCell(columnHeader: 'Status', value: order.status),
            ExcelDataCell(
                columnHeader: 'Date',
                value: order.orderDate.toDate().toFormatDate()),
          ],
        );
      }).toList();

      return excelDataRows;
    }

    final List<ExcelDataRow> dataRows = buildReportDataRows();

    sheet.importData(dataRows, 1, 1);

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      html.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
        ..setAttribute("download", "$fileName.xlsx")
        ..click();
      EasyLoading.showSuccess('Downloaded');
    } else {
      EasyLoading.showError('Platform not implemented');
    }
  }
}

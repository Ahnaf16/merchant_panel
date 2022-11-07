// import 'package:pdf/widgets.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
// import 'package:universal_html/html.dart' as html;

class PDFServ {
  static Future<pw.MemoryImage> loadMemoryImg(String path) async {
    ///
    final imgByteData = await rootBundle.load(path);

    final imgByte = imgByteData.buffer.asUint8List(
      imgByteData.offsetInBytes,
      imgByteData.lengthInBytes,
    );
    final img = pw.MemoryImage(imgByte);

    return img;
  }

  static Future<String> generatePDF({required OrderModel order}) async {
    final img = await loadMemoryImg('assets/logo/expanded_logo_crop.png');
    final stamp = await loadMemoryImg('assets/misc/stamp_tiny.png');
    final font = await rootBundle.load("fonts/PotroSans/PotroSansR.ttf");
    final ttf = pw.Font.ttf(font);
    final pdf = pw.Document(
      author: 'GNG',
      title: 'Invoice',
      theme: pw.ThemeData(
        defaultTextStyle: pw.TextStyle(
          fontSize: 10,
          font: ttf,
          renderingMode: PdfTextRenderingMode.fill,
        ),
      ),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 50,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              // pw.Image(textImg, height: 100, width: 100),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(
                    img,
                    height: 70,
                    width: 150,
                    fit: pw.BoxFit.contain,
                  ),
                  pw.RichText(
                    textAlign: pw.TextAlign.right,
                    text: pw.TextSpan(
                      text: 'GNG INVOICE',
                      style: context.pdfTheme.header2,
                      children: [
                        pw.TextSpan(
                          text: '\n${order.invoice}',
                          style: context.pdfTheme.defaultTextStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 15),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              width: 100,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    'Name & Contact:',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Text(order.address.name),
                                  pw.SizedBox(height: 5),
                                  pw.Text(order.address.billingNumber),
                                ],
                              ),
                            ),
                            pw.SizedBox(
                              width: 80,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Address:',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                    '${order.address.district},',
                                  ),
                                  pw.Text(order.address.address),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 40),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Date:', textAlign: pw.TextAlign.right),
                            pw.Text(
                                order.orderDate.toFormatDate('MMM dd,yyyy')),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Payment Terms:'),
                            pw.Text(
                              order.total == order.paidAmount
                                  ? 'Full Paid'
                                  : 'DUE',
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('PO Number:'),
                            pw.Text(' '),
                            pw.SizedBox(width: 5),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Payment Due:',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                (order.total - order.paidAmount)
                                    .toCurrency(useName: true),
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                },
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: pw.Text('Item'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Center(
                          child: pw.Text('Quantity'),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Center(
                          child: pw.Text('Rate'),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Center(
                          child: pw.Text('Amount'),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    order.items.length,
                    (index) {
                      final item = order.items[index];
                      return pw.TableRow(
                        verticalAlignment: pw.TableCellVerticalAlignment.middle,
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            child: pw.Text(item.name),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              item.quantity.toString(),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                              child: pw.Text(
                                item.price.toCurrency(useName: true),
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Center(
                              child: pw.Text(
                                item.total.toCurrency(useName: true),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.SizedBox(
                width: 200,
                child: pw.Table(
                  columnWidths: const {
                    0: pw.FlexColumnWidth(2.0),
                    1: pw.FlexColumnWidth(1.0)
                  },
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text('Subtotal:'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(
                            order.items
                                .fold<int>(0, (a, b) => a + b.total)
                                .toCurrency(useName: true),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text('Delivery charge:'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(
                              order.deliveryCharge.toCurrency(useName: true),
                              textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                    if (order.voucher != 0)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text('Voucher:'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(
                                order.voucher.toCurrency(useName: true),
                                textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text('Total:'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(order.total.toCurrency(useName: true),
                              textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text('Advance:'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(
                              order.paidAmount.toCurrency(useName: true),
                              textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text('Due:'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(3),
                          child: pw.Text(
                              (order.total - order.paidAmount)
                                  .toCurrency(useName: true),
                              textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (order.total == order.paidAmount)
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  child: pw.Container(
                    margin: const pw.EdgeInsets.all(10),
                    child: pw.Image(
                      stamp,
                      height: 100,
                      width: 100,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
    if (kIsWeb) {
      Uint8List bytes = await pdf.save();

      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      return url;
    } else {
      EasyLoading.showError('Unsupported platform');
      return 'platform error';
    }
  }

  static openPdf({required OrderModel order}) async {
    if (kIsWeb) {
      final url = await generatePDF(order: order);
      html.window.open(url, "_blank");
      html.Url.revokeObjectUrl(url);
    } else {
      EasyLoading.showError('Unsupported platform');
    }
  }

  static savePdf({required OrderModel order}) async {
    if (kIsWeb) {
      final url = await generatePDF(order: order);
      final anchor = html.AnchorElement()
        ..href = url
        ..style.display = 'none'
        ..download = 'invoice${order.invoice}.pdf';
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      EasyLoading.showError('Unsupported platform');
    }
  }
}

extension PDFEx on pw.Context {
  pw.ThemeData get pdfTheme => pw.Theme.of(this);
}

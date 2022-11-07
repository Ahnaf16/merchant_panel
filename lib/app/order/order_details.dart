// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/app/order/order_providers.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/extension/widget_extensions.dart';
import 'package:merchant_panel/services/export%20api/pdf_services.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/theme/theme_manager.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../auth/employee/employee_provider.dart';
import '../../services/order/orders_services.dart';
import '../../theme/layout_manager.dart';
import '../../widgets/delete_button.dart';
import '../../widgets/header.dart';
import '../../widgets/widget_export.dart';
import 'local/change_status.dart';
import 'local/customer_info.dart';
import 'local/ordered_items_list.dart';
import 'sheets/sheets_model.dart';

class OrderDetails extends ConsumerWidget {
  const OrderDetails({required this.orderId, Key? key}) : super(key: key);
  final String orderId;
  static const routeName = '/order_details';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Typography typeTheme = textTheme(context);

    final orderDialist = ref.watch(orderDetailsProvider(orderId));
    final paidCtrl = ref.watch(paidAmountCtrl);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final sheets = ref.read(sheetNProvider.notifier);
    final roles = ref.watch(roleProvider(uid));
    final layout = ref.read(layoutProvider(context));
    final openPdf = ref.watch(openPdfProvider);

    return SafeArea(
      child: ScaffoldPage(
        header: const Header(
          title: 'Order Details',
        ),
        content: orderDialist.when(
          data: (order) => BaseBody(
            widthFactor: layout.isSmallScreen ? 1 : 0.5,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(FluentIcons.calendar),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('EEE, LLL d. y, h:mm a')
                        .format(order.orderDate.toDate()),
                    style: typeTheme.bodyStrong!.merge(typeTheme.bodyLarge),
                  ),
                  const Spacer(),
                  if (layout.isSmallScreen)
                    Flyout(
                      openMode: FlyoutOpenMode.press,
                      content: (context) => MenuFlyout(
                        items: [
                          MenuFlyoutItem(
                            text: const Text('Google Sheet'),
                            onPressed: () {
                              gSheetButtonPress(context, sheets, order);
                            },
                            leading: const Icon(MdiIcons.googleSpreadsheet),
                          ),
                          MenuFlyoutItem(
                            text: const Text('Change Payment Status'),
                            onPressed: () {
                              statusChangePress(context, order);
                            },
                            leading: const Icon(MdiIcons.pacMan),
                          ),
                          if (roles.canDeleteOrder())
                            MenuFlyoutItem(
                              text: const Text('Delete Order'),
                              onPressed: () {
                                deleteButtonPress(context);
                              },
                              leading: const Icon(MdiIcons.googleSpreadsheet),
                            ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: const Icon(FluentIcons.more_vertical),
                      ),
                    ),

                  // ----------------------------status
                  if (!layout.isSmallScreen)
                    gSheetButton(context, sheets, order),
                  // GoogleSheetButton(sheets: sheets, order: order),
                  if (!layout.isSmallScreen) 10.wSpace,
                  if (!layout.isSmallScreen) changeStatusButton(order, context),
                  if (!layout.isSmallScreen) 10.wSpace,

                  if (!layout.isSmallScreen)
                    SplitButtonBar(
                      buttons: [
                        Button(
                          child: Text(
                              openPdf ? 'Open Invoice' : 'Download Invoice'),
                          onPressed: () {
                            if (openPdf) {
                              PDFServ.openPdf(order: order);
                            } else {
                              PDFServ.savePdf(order: order);
                            }
                          },
                        ),
                        DropDownButton(
                          items: [
                            MenuFlyoutItem(
                              text: const Text('Open'),
                              leading: const Icon(FluentIcons.open_file),
                              onPressed: () {
                                ref.read(openPdfProvider.notifier).state = true;
                              },
                            ),
                            MenuFlyoutItem(
                              text: const Text('Download'),
                              leading:
                                  const Icon(FluentIcons.download_document),
                              onPressed: () {
                                ref.read(openPdfProvider.notifier).state =
                                    false;
                              },
                            ),
                            if (order.user.email.isEmail)
                              MenuFlyoutItem(
                                text: const Text('Send Mail'),
                                leading: const Icon(FluentIcons.mail),
                                onPressed: null,
                              ),
                          ],
                        )
                      ],
                    ),

                  if (!layout.isSmallScreen) const SizedBox(width: 10),
                  if (!layout.isSmallScreen)
                    if (roles.canDeleteOrder()) deleteButton(context),
                ],
              ),
              //-------------------------invoice number
              TextIcon(
                mainAxisSize: MainAxisSize.max,
                text: 'Invoice: ${order.invoice}',
                textStyle: typeTheme.bodyStrong!.merge(typeTheme.bodyLarge),
                action: [
                  IconButton(
                    icon: const Icon(FluentIcons.copy),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: order.invoice,
                        ),
                      );
                      EasyLoading.showToast(
                        'Copied to Clipboard',
                        toastPosition: EasyLoadingToastPosition.bottom,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 15),
              //-------------------------customer info
              CustomerInfo(
                order: order,
                isPhone: layout.isSmallScreen,
              ),

              const SizedBox(height: 20),

              Container(
                decoration: boxDecoration,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //-------------------------Data table
                      layout.isSmallScreen
                          ? OrderedItemList(order: order)
                          : OrderItemsTable(cart: order.items),

                      OrderPaymentInfo(
                        order: order,
                        paidCtrl: paidCtrl,
                        isPhone: layout.isSmallScreen,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: boxDecoration,
                child: Expander(
                  leading: const Icon(FluentIcons.clock),
                  header: const Text('Order Timeline'),
                  content: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...List.generate(
                        order.timeLine.length,
                        (index) {
                          final timeline = order.timeLine[index];
                          return SizedBox(
                            width: 300,
                            child: Card(
                              backgroundColor:
                                  ExtLogic.colorLog(timeline.status)
                                      .withOpacity(.1),
                              child: Column(
                                children: [
                                  Card(
                                    backgroundColor:
                                        ExtLogic.colorLog(timeline.status)
                                            .withOpacity(.2),
                                    child: Text(timeline.status),
                                  ),
                                  _space,
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    alignment: WrapAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: [
                                      TextIcon(
                                        text: timeline.userName ?? 'User',
                                        icon: FluentIcons.employee_self_service,
                                      ),
                                      TextIcon(
                                        text: timeline.date.toFormatDate(
                                            'hh:mm a,\ndd MMM, yyyy'),
                                        icon: FluentIcons.clock,
                                      ),
                                    ],
                                  ),
                                  _space,
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      timeline.comment,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          error: (error, st) => KErrorWidget(error: error, st: st),
          loading: () => const LoadingWidget(),
        ),
      ),
    );
  }

  OutlinedButton deleteButton(BuildContext context) {
    return OutlinedButton(
      style: hoveringButtonsStyle(Colors.warningPrimaryColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Delete Order'),
          SizedBox(width: 10),
          Icon(FluentIcons.delete),
        ],
      ),
      onPressed: () {
        deleteButtonPress(context);
      },
    );
  }

  Future<Object?> deleteButtonPress(BuildContext context) {
    return deleteButtonDialog(
      context: context,
      onDelete: () {
        OrderServices.deleteOrder(orderId);
      },
    );
  }

  OutlinedButton gSheetButton(
      BuildContext context, SheetNotifier sheets, OrderModel order) {
    return OutlinedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(' Google Sheet'),
          SizedBox(width: 10),
          Icon(
            MdiIcons.googleSpreadsheet,
          ),
        ],
      ),
      onPressed: () => gSheetButtonPress(context, sheets, order),
    );
  }

  gSheetButtonPress(
    BuildContext context,
    SheetNotifier sheets,
    OrderModel order,
  ) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Upload to Google Sheet'),
        content: const Text(
            'Make sure you are uploading the right order to the Sheet.'),
        actions: [
          TextButton(
            onPressed: () async {
              final creds = await sheets.getSheetCred();
              await sheets.uploadToSheet(creds, order);
              Navigator.pop(context);
            },
            style: hoveringButtonsStyle(Colors.green),
            child: const Text('Upload'),
          ),
          TextButton(
            style: hoveringButtonsStyle(Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  SizedBox get _space => const SizedBox(height: 10);

  OutlinedButton changeStatusButton(OrderModel order, BuildContext context) {
    return OutlinedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(order.status),
          const SizedBox(width: 10),
          const Icon(FluentIcons.edit),
        ],
      ),
      onPressed: () => statusChangePress(context, order),
    );
  }

  Future<Object?> statusChangePress(BuildContext context, OrderModel order) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ChangeStatusWidget(order),
    );
  }
}

class OrderPaymentInfo extends StatelessWidget {
  const OrderPaymentInfo({
    Key? key,
    required this.order,
    required this.paidCtrl,
    required this.isPhone,
  }) : super(key: key);

  final OrderModel order;
  final TextEditingController paidCtrl;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    Typography typeTheme = textTheme(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: isPhone
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 3,
        decoration: boxDecoration,
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(
              color: Colors.grey.withOpacity(.2),
              width: 1,
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(3.0),
            1: FlexColumnWidth(1.0)
          },
          children: [
            tableRow(
              typeTheme: typeTheme,
              title: 'SubTotal',
              childText:
                  order.items.fold<int>(0, (a, b) => a + b.total).toCurrency(),
            ),
            if (order.voucher != 0)
              tableRow(
                typeTheme: typeTheme,
                title: 'Voucher',
                childText: order.voucher.toCurrency(),
              ),
            tableRow(
              typeTheme: typeTheme,
              title: 'Delivery charge',
              childText: order.deliveryCharge.toCurrency(),
            ),
            tableRow(
              typeTheme: typeTheme,
              title: 'Total',
              childText: order.total.toCurrency(),
            ),
            tableRow(
              typeTheme: typeTheme,
              title: 'Paid Amount',
              childText: order.paidAmount.toCurrency(),
              isTextBox: true,
              paidCtrl: paidCtrl,
            ),
            tableRow(
              typeTheme: typeTheme,
              title: 'Due',
              childText: (order.total - order.paidAmount).toCurrency(),
            ),
          ],
        ),
      ),
    );
  }

  TableRow tableRow({
    required Typography typeTheme,
    required String title,
    String childText = '',
    bool isTextBox = false,
    TextEditingController? paidCtrl,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$title:',
            style: typeTheme.bodyStrong!.merge(
              typeTheme.bodyLarge,
            ),
          ),
        ),
        !isTextBox
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  childText,
                  textAlign: TextAlign.end,
                  style: typeTheme.bodyStrong!.merge(
                    typeTheme.bodyLarge,
                  ),
                ),
              )
            : TextBox(
                controller: paidCtrl = TextEditingController(text: childText),
                placeholder: childText,
                style: typeTheme.bodyLarge,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixMode: OverlayVisibilityMode.editing,
                suffix: IconButton(
                  icon: const Icon(FluentIcons.accept),
                  onPressed: () {
                    OrderServices.updatePaidAmount(
                      order.docID!,
                      int.parse(paidCtrl!.text),
                    );
                    paidCtrl.clear();
                  },
                ),
                onSubmitted: (value) {
                  OrderServices.updatePaidAmount(
                    order.docID!,
                    int.parse(value),
                  );
                  paidCtrl!.clear();
                },
              ),
      ],
    );
  }
}

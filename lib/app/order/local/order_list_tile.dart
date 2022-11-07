import 'package:custom_clippers/custom_clippers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:merchant_panel/app/order/order_providers.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/order/orders_services.dart';
import '../../../theme/theme_manager.dart';

import '../../../widgets/text_icon.dart';
import '../order_details.dart';
import '../order_model.dart';

class OrderListTile extends StatelessWidget {
  OrderListTile({super.key, required this.order});

  final OrderModel order;
  final FlyoutController flCtrl = FlyoutController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: Flyout(
        controller: flCtrl,
        openMode: FlyoutOpenMode.longPress,
        position: FlyoutPosition.above,
        placement: FlyoutPlacement.end,
        content: (context) => flyoutItems(),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              OrderDetails.routeName,
              arguments: order.docID,
            );
          },
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextIcon(
                      icon: FluentIcons.people,
                      text: order.address.name,
                    ),
                    TextIcon(
                      icon: FluentIcons.phone,
                      text: order.address.billingNumber,
                    ),
                    TextIcon(
                      icon: FluentIcons.invoice,
                      text: order.invoice,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipPath(
                      clipper: order.voucher == 0
                          ? null
                          : TicketPassClipper(holeRadius: 10),
                      child: Container(
                        padding: order.voucher == 0
                            ? null
                            : const EdgeInsets.symmetric(
                                horizontal: 3,
                                vertical: 5,
                              ),
                        decoration: order.voucher == 0
                            ? null
                            : BoxDecoration(
                                color: Colors.orange.lightest.withOpacity(.5),
                                borderRadius: BorderRadius.circular(3),
                              ),
                        child: Text(
                          order.total.toCurrency(),
                          style: textTheme(context).bodyLarge,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: ExtLogic.colorLog(order.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(order.status),
                        ),
                        order.paymentMethod.toIcon(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('hh:MM a, dd MMM, yyyy').format(
                        order.orderDate.toDate(),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MenuFlyout flyoutItems() {
    return MenuFlyout(
      items: [
        MenuFlyoutItem(
          text: const Text('Copy Invoice'),
          leading: const Icon(FluentIcons.copy),
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: order.invoice),
            );
            flCtrl.close();
            EasyLoading.showToast('Invoice copied');
          },
        ),
        MenuFlyoutItem(
          text: const Text('Copy Phone Number'),
          leading: const Icon(FluentIcons.copy),
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: order.address.billingNumber),
            );
            flCtrl.close();
            EasyLoading.showToast('Phone Number copied');
          },
        ),
        MenuFlyoutItem(
          text: const Text('Make a call'),
          leading: const Icon(FluentIcons.phone),
          onPressed: () async {
            if (order.address.billingNumber.startsWith('01') &&
                order.address.billingNumber.length == 11) {
              await launchUrl(
                Uri(
                  scheme: "tel",
                  path: "+88${order.address.billingNumber}",
                ),
              );
              flCtrl.close();
            } else {
              flCtrl.close();
              EasyLoading.showToast('Phone number is not valid');
            }
          },
        ),
      ],
    );
  }
}

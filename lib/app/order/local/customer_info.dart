import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show SelectionArea;
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../order_model.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({
    required this.order,
    required this.isPhone,
    Key? key,
  }) : super(key: key);
  final OrderModel order;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      IconTextVertical(
        icon: FluentIcons.contact,
        title: 'Customer Info',
        isPhone: isPhone,
        children: [
          Text(order.address.name),
          const SizedBox(height: 5),
          Text(order.user.email),
          const SizedBox(height: 5),
          TextIcon(
            text: order.address.billingNumber,
            action: [
              if (order.address.billingNumber.isPhnNum)
                IconButton(
                  icon: const Icon(FluentIcons.phone),
                  onPressed: () async {
                    await launchUrl(
                      Uri(
                        scheme: "tel",
                        path: "+88${order.address.billingNumber}",
                      ),
                    );
                  },
                ),
              const SizedBox(width: 5),
              if (order.address.billingNumber.isPhnNum)
                IconButton(
                  icon: const Icon(FluentIcons.message),
                  onPressed: () async {
                    await launchUrl(
                      Uri(
                        scheme: "sms",
                        path: "+88${order.address.billingNumber}",
                        queryParameters: <String, String>{
                          'body': Uri.encodeComponent(
                            'Example Subject & Symbols are allowed!',
                          ),
                        },
                      ),
                    );
                  },
                ),
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(FluentIcons.copy),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: order.address.billingNumber,
                    ),
                  );
                  EasyLoading.showToast('Copied to Clipboard',
                      toastPosition: EasyLoadingToastPosition.bottom);
                },
              ),
            ],
          )
        ],
      ),
      const SizedBox(height: 10),
      IconTextVertical(
        icon: FluentIcons.delivery_truck,
        title: 'Order Info',
        isPhone: isPhone,
        children: [
          Text('Payment Method: ${order.paymentMethod}'),
          const SizedBox(height: 5),
          Text('Status: ${order.status}'),
        ],
      ),
      const SizedBox(height: 10),
      IconTextVertical(
        icon: FluentIcons.p_b_i_anomalies_marker,
        title: 'Deliver To',
        isPhone: isPhone,
        children: [
          Text('Division: ${order.address.division}'),
          const SizedBox(height: 5),
          Text('District: ${order.address.district}'),
          const SizedBox(height: 5),
          const Text('Address: '),
          Flyout(
            openMode: FlyoutOpenMode.press,
            content: (context) => SizedBox(
              width: 250,
              child: Container(
                decoration: boxDecoration,
                child: Text(order.address.address),
              ),
            ),
            child: Text(
              order.address.address.length >= 50
                  ? '${order.address.address.substring(0, 50)}...'
                  : order.address.address,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ];

    return isPhone
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          );
  }
}

class IconTextVertical extends StatelessWidget {
  const IconTextVertical({
    Key? key,
    required this.icon,
    required this.title,
    required this.children,
    this.isPhone = false,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final bool isPhone;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.grey[50],
            child: Icon(icon),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FluentTheme.of(context).typography.bodyLarge,
              ),
              const SizedBox(height: 5),
              ...List.generate(
                children.length,
                (index) => SizedBox(
                  width: 250,
                  child: children[index],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_enums.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/auth/auth_provider.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../services/order/orders_services.dart';
import '../../../theme/layout_manager.dart';
import '../../../widgets/text_icon.dart';
import '../order_providers.dart';

class ChangeStatusWidget extends ConsumerWidget {
  const ChangeStatusWidget(
    this.order, {
    Key? key,
  }) : super(key: key);
  final OrderModel order;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(selectedOrderStatsUpdate);
    final comment = ref.watch(orderStatusComment);
    final layout = ref.read(layoutProvider(context));
    final isPhone = layout.isSmallScreen;

    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: isPhone
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 2,
      ),
      title: const Header(
        title: 'Change Status',
        showLeading: false,
      ),
      actions: [
        Button(
          style: hoveringButtonsStyle(Colors.warningPrimaryColor),
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        Button(
          style: hoveringButtonsStyle(Colors.successPrimaryColor),
          child: const Text('Update'),
          onPressed: () {
            OrderServices.updateOrderStatus(
              order.docID!,
              status == null ? order.status : status.toString(),
              comment,
            );
            Navigator.pop(context);
          },
        ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(order.address.name),
          Container(
            decoration: boxDecoration,
            child: ComboBox<OrderStatus>(
              placeholder: const Text('Status'),
              isExpanded: true,
              items: OrderStatus.values
                  .map((text) => ComboBoxItem<OrderStatus>(
                        value: text,
                        child: Text(text.toString()),
                      ))
                  .toList(),
              value: status ?? order.status.toStatus(),
              onChanged: (value) {
                ref.read(selectedOrderStatsUpdate.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 10),
          TextIcon(
            text: 'Mark As Duplicate',
            icon: MdiIcons.contentDuplicate,
            horizontalMargin: 0,
            onPressed: () {
              if (status == OrderStatus.duplicate) {
                ref.read(selectedOrderStatsUpdate.notifier).state =
                    order.status.toStatus();
              } else {
                ref.read(selectedOrderStatsUpdate.notifier).state =
                    OrderStatus.duplicate;
              }
            },
            action: [
              Checkbox(
                checked: status == OrderStatus.duplicate ||
                    order.status.toStatus() == OrderStatus.duplicate,
                onChanged: (v) {
                  if (status == OrderStatus.duplicate) {
                    ref.read(selectedOrderStatsUpdate.notifier).state =
                        order.status.toStatus();
                  } else {
                    ref.read(selectedOrderStatsUpdate.notifier).state =
                        OrderStatus.duplicate;
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextBox(
            decoration: boxDecoration,
            maxLines: null,
            minHeight: 120,
            header: 'Comment   (as ${getUser!.displayName})',
            onChanged: (value) {
              ref.read(orderStatusComment.notifier).state =
                  '$value\n${getUser!.displayName}';
            },
          ),
        ],
      ),
    );
  }
}

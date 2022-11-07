import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/order/pagination_order_list.dart';
import '../../../theme/layout_manager.dart';
import '../../../widgets/color_coded_card.dart';
import '../order_providers.dart';

class OrdersCount extends ConsumerWidget {
  const OrdersCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderCountAll = ref.watch(orderStatusProvider(null));
    final layout = ref.read(layoutProvider(context));

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        orderCountAll.maybeWhen(
          data: (count) => ColoredCardButton(
            shrieked: layout.isSmallScreen,
            title: 'Total',
            text: count.toString(),
            lineColor: Colors.blue,
            color: Colors.blue.withOpacity(0.1),
          ),
          orElse: () => const Text(''),
        ),
        ...List.generate(
          getOrderStatusList.length,
          (index) {
            final orderCount =
                ref.watch(orderStatusProvider(getOrderStatusList[index]));

            return orderCount.maybeWhen(
              data: (count) {
                if (getOrderStatusList[index] == 'Cancelled') {
                  return Flyout(
                    openMode: FlyoutOpenMode.press,
                    placement: FlyoutPlacement.end,
                    position: FlyoutPosition.side,
                    content: (context) => ColoredCardButton(
                      shrieked: layout.isSmallScreen,
                      title: getOrderStatusList[index],
                      text: count.toString(),
                      lineColor: getStatusCOlor[index],
                      color: getStatusCOlor[index].withOpacity(0.1),
                    ),
                    child: const Icon(FluentIcons.more_vertical),
                  );
                } else {
                  return ColoredCardButton(
                    shrieked: layout.isSmallScreen,
                    title: getOrderStatusList[index],
                    text: count.toString(),
                    lineColor: getStatusCOlor[index],
                    color: getStatusCOlor[index].withOpacity(0.1),
                  );
                }
              },
              orElse: () => const Text(''),
            );
          },
        ),
      ],
    );
  }
}

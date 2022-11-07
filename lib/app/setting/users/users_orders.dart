import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/theme/layout_manager.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import '../../../services/order/orders_services.dart';
import 'user_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/cached_net_img.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/header.dart';
import '../../order/order_details.dart';

class UserSpecificOrderList extends ConsumerWidget {
  const UserSpecificOrderList({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userOrders = ref.watch(ordersByUser(user.uid));
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return ContentDialog(
      constraints: BoxConstraints(
          maxWidth: isSmall ? double.infinity : context.width / 2),
      title: Header(title: user.displayName),
      content: userOrders.when(
        data: (orders) {
          orders.sort((a, b) => ExtLogic.sortLogic(a.status)
              .compareTo(ExtLogic.sortLogic(b.status)));

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  decoration: boxDecoration,
                  child: Expander(
                    header: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('${index + 1}: '),
                        Text(order.invoice),
                        TextIcon(
                          text:
                              '${order.total.toCurrency(useName: true)} tk worth',
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                ExtLogic.colorLog(order.status).withOpacity(.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(order.status),
                        ),
                        const SizedBox(width: 5),
                        TextIcon(
                          text: 'Details',
                          showBorder: true,
                          onPressed: () => context.pushName(
                            OrderDetails.routeName,
                            order.docID,
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: order.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = order.items[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                leading: CachedNetImg(
                                  url: item.img,
                                  height: 60,
                                  width: 60,
                                ),
                                title: Text(
                                  item.name.showUntil(30),
                                ),
                                subtitle: Text(item.price.toCurrency()),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, st) => KErrorWidget(error: error, st: st),
        loading: () => const Card(
          child: LoadingWidget(),
        ),
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merchant_panel/app/voucher/voucher_model.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../services/offers/voucher_services.dart';
import '../../../theme/theme.dart';
import '../../../widgets/delete_button.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/text_icon.dart';
import '../../setting/users/user_provider.dart';

class VGrids extends StatelessWidget {
  const VGrids({
    super.key,
    required this.onPressed,
    required this.vouchers,
    required this.isSmall,
  });

  final Function() onPressed;
  final List<VoucherModel> vouchers;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MasonryGridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: vouchers.length,
          padding: const EdgeInsets.all(0),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isSmall ? 2 : 4,
          ),
          itemBuilder: (BuildContext context, int index) {
            final voucher = vouchers[index];
            return Stack(
              children: [
                VoucherGridCard(voucher: voucher),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${index + 1}'),
                )
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onPressed,
          child: const Text('more'),
        ),
      ],
    );
  }
}

class VoucherGridCard extends ConsumerWidget {
  const VoucherGridCard({
    super.key,
    required this.voucher,
  });

  final VoucherModel voucher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voucherServices = ref.read(voucherProvider.notifier);
    final theUser = voucher.type == VoucherType.individual
        ? ref.watch(userByUid(voucher.customerId))
        : const AsyncValue.data(null);
    return theUser.when(
        error: (error, st) => KErrorWidget(error: error, st: st),
        loading: () => const LoadingWidget(),
        data: (user) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: TextIcon(
                    text: voucher.title,
                    icon: FluentIcons.gift_card,
                  ),
                ),
                TextIcon(
                  text:
                      '${voucher.amount} Tk (Min. ${voucher.minimumSpend} Tk)',
                  icon: MdiIcons.currencyBdt,
                ),
                if (user != null)
                  TextIcon(
                    text: user.displayName,
                    icon: MdiIcons.accountCircle,
                  ),
                TextIcon(
                  text: '${voucher.createDate.toFormatDate('MMM dd,yyyy')}  to',
                  icon: MdiIcons.timerSand,
                ),
                TextIcon(
                  text: voucher.expireDate.toFormatDate('MMM dd,yyyy'),
                  icon: MdiIcons.timerSandComplete,
                ),
                TextIcon(
                  text:
                      'Days left : ${voucher.expireDate.difference(DateTime.now()).inDays}',
                  icon: FluentIcons.timer,
                ),
                TextIcon.selectable(
                  text: voucher.code,
                  icon: FluentIcons.ticket,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (voucher.type == VoucherType.global)
                      TextIcon(
                        text: voucher.usedBy.toString(),
                        icon: MdiIcons.account,
                        color: Colors.successPrimaryColor,
                        textStyle: context.textType.body!
                            .copyWith(color: Colors.successSecondaryColor),
                        margin: const EdgeInsets.only(right: 8),
                      ),
                    if (voucher.type == VoucherType.singleUse &&
                        !voucher.isUsed)
                      TextIcon(
                        icon: MdiIcons.timerSandEmpty,
                        color:
                            voucher.isUsed ? Colors.green : Colors.orange.light,
                        textStyle: context.textType.body!
                            .copyWith(color: Colors.white),
                        margin: const EdgeInsets.only(right: 8),
                      ),
                    if (voucher.isExpired)
                      TextIcon(
                        icon: MdiIcons.calendarCheck,
                        color: Colors.successPrimaryColor,
                        textStyle: context.textType.body!.copyWith(
                          color: Colors.successSecondaryColor,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                      ),
                    if (!voucher.isExpired &&
                        voucher.expireDate.isBefore(DateTime.now()))
                      TextIcon(
                        icon: MdiIcons.calendarAlert,
                        onPressed: () {
                          expiredDialog(context, voucherServices);
                        },
                        color: Colors.warningPrimaryColor,
                        hoverColor: Colors.warningPrimaryColor.withOpacity(.8),
                        textStyle: context.textType.body!.copyWith(
                          color: Colors.warningSecondaryColor,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                      ),
                    if (voucher.isUsed)
                      TextIcon(
                        icon: MdiIcons.accountCheckOutline,
                        color: Colors.successPrimaryColor,
                        textStyle: context.textType.body!.copyWith(
                          color: Colors.successSecondaryColor,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                      ),
                    const Spacer(),
                    VoucherContextMenu(
                      voucher: voucher,
                      voucherServices: voucherServices,
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  expiredDialog(
    BuildContext context,
    VoucherNotifier voucherServices,
  ) {
    return showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Mark as Expired'),
        actions: [
          TextButton(
            style: hoveringButtonsStyle(Colors.warningPrimaryColor),
            onPressed: () {
              voucherServices.markAsExpired(voucher);
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: hoveringButtonsStyle(Colors.blue),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class VoucherContextMenu extends StatelessWidget {
  VoucherContextMenu({
    Key? key,
    required this.voucher,
    required this.voucherServices,
  }) : super(key: key);

  final flyCtrl = FlyoutController();
  final VoucherModel voucher;
  final VoucherNotifier voucherServices;

  @override
  Widget build(BuildContext context) {
    return Flyout(
      controller: flyCtrl,
      openMode: FlyoutOpenMode.press,
      position: FlyoutPosition.side,
      placement: FlyoutPlacement.end,
      content: (context) => MenuFlyout(
        items: [
          MenuFlyoutItem(
            text: const Text('Mark as Expired'),
            leading: const Icon(FluentIcons.date_time),
            trailing: Checkbox(
              checked: voucher.isExpired,
              onChanged: (v) {
                voucherServices.markAsExpired(voucher);
                flyCtrl.close();
              },
            ),
            onPressed: () {
              voucherServices.markAsExpired(voucher);
              Navigator.pop(context);
            },
          ),
          MenuFlyoutItem(
            text: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.warningPrimaryColor,
              ),
            ),
            leading: const Icon(
              FluentIcons.delete,
              color: Colors.warningPrimaryColor,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await deleteButtonDialog(
                context: context,
                object: 'Voucher',
                onDelete: () {
                  voucherServices.deleteVoucher(voucher);
                  // Navigator.pop(context);
                },
              );
            },
          )
        ],
      ),
      child: TextIcon(
        icon: FluentIcons.more,
        color: Colors.grey[50],
      ),
    );
  }
}

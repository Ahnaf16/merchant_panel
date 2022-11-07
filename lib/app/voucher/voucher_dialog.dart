import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/voucher/voucher_model.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../setting/users/user_model.dart';
import '../../services/offers/voucher_services.dart';
import '../../theme/layout_manager.dart';
import '../../theme/theme.dart';
import '../../widgets/body_base.dart';
import '../../widgets/header.dart';
import '../../widgets/text_icon.dart';

class VoucherDialog extends ConsumerWidget {
  const VoucherDialog({
    this.user,
    this.isGlobal = false,
    super.key,
  });

  final UserModel? user;
  final bool isGlobal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voucher = ref.watch(voucherProvider);
    final voucherFunc = ref.read(voucherProvider.notifier);
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: isSmall ? context.width : context.width / 1.5,
      ),
      title: const Header(
        title: 'Voucher',
        showLeading: true,
      ),
      actions: [
        IconButton(
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(FluentIcons.reset),
              SizedBox(width: 10),
              Text('Reset'),
            ],
          ),
          onPressed: () {
            voucherFunc.reset();
          },
        ),
        FilledButton(
          child: const Text('Add Voucher'),
          onPressed: () {
            if (user == null) {
              voucherFunc.uploadGlobalVoucher();
            } else {
              voucherFunc.individualVoucherList(user!);
            }
          },
        ),
      ],
      content: BaseBody(
        crossAxisAlignment: CrossAxisAlignment.start,
        widthFactor: 1,
        children: [
          Wrap(
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 10,
            runSpacing: 10,
            children: [
              InfoLabel(
                label: 'Created at',
                child: Container(
                  decoration: boxDecoration,
                  child: DatePicker(
                    selected: voucher.createDate,
                    onChanged: (value) {
                      voucherFunc.setCreateDate(value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InfoLabel(
                label: 'Expire Date',
                child: Container(
                  decoration: boxDecoration,
                  child: DatePicker(
                    selected: voucher.expireDate,
                    onChanged: (value) {
                      voucherFunc.setExpireDate(value);
                    },
                  ),
                ),
              ),
              TextIcon(
                showBorder: true,
                text:
                    '${voucher.expireDate.difference(voucher.createDate).inDays} Days',
                icon: FluentIcons.clock,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...VoucherType.values
                  .map(
                    (type) => Checkbox(
                      content: Text(type.name),
                      checked: voucher.type == type,
                      onChanged: (v) {
                        voucherFunc.setVoucherType(type);
                      },
                    ),
                  )
                  .toList(),
            ],
          ),
          const SizedBox(height: 10),
          if (user != null)
            TextIcon(
              showBorder: true,
              iconSize: 16,
              text: 'name : ${user!.displayName}',
              icon: MdiIcons.accountCircleOutline,
              actionDirection: isSmall ? Axis.vertical : Axis.horizontal,
              action: [
                SelectableText('uid : ${user!.uid}'),
              ],
            ),
          const SizedBox(height: 10),
          Center(
            child: Wrap(
              runAlignment: WrapAlignment.start,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: isSmall ? context.width : context.width / 3.5,
                  child: TextBox(
                    header: 'Title',
                    controller: voucherFunc.titleCtrl,
                    decoration: boxDecoration,
                  ),
                ),
                SizedBox(
                  width: isSmall ? context.width : context.width / 3.5,
                  child: TextBox(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    header: 'Amount',
                    controller: voucherFunc.amountCtrl,
                    decoration: boxDecoration,
                    prefix: const Icon(MdiIcons.currencyBdt),
                    suffix: DropDownButton(
                      items: voucherFunc.amountDropDown
                          .map(
                            (amount) => MenuFlyoutItem(
                              leading: const Icon(MdiIcons.currencyBdt),
                              text: Text(amount),
                              onPressed: () {
                                voucherFunc.amountCtrl.text = amount.toString();
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(
                  width: isSmall ? context.width : context.width / 3.5,
                  child: TextBox(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    header: 'Minimum Money Spend',
                    controller: voucherFunc.minimumSpend,
                    decoration: boxDecoration,
                    prefix: const Icon(MdiIcons.currencyBdt),
                    suffix: DropDownButton(
                      items: voucherFunc.amountDropDown
                          .map(
                            (amount) => MenuFlyoutItem(
                              leading: const Icon(MdiIcons.currencyBdt),
                              text: Text(amount),
                              onPressed: () {
                                voucherFunc.minimumSpend.text = amount;
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(
                  width: isSmall ? context.width : context.width / 3.5,
                  child: TextBox(
                    header: 'Voucher',
                    controller: voucherFunc.codeCtrl,
                    decoration: boxDecoration,
                    suffix: TextIcon(
                      icon: FluentIcons.reset,
                      onPressed: () {
                        voucherFunc.generateCode();
                      },
                    ),
                    outsideSuffix: Row(
                      children: [
                        ...CouponType.values.map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5),
                            child: ToggleButton(
                              checked: e == voucher.couponType,
                              onChanged: (v) {
                                voucherFunc.changeCouponType(e);
                              },
                              child: Text(
                                e.text,
                                style: GoogleFonts.kanit(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

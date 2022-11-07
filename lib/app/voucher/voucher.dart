import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/setting/users/users.dart';
import 'package:merchant_panel/app/voucher/voucher_dialog.dart';
import 'package:merchant_panel/app/voucher/voucher_model.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/extension/widget_extensions.dart';
import 'package:merchant_panel/theme/layout_manager.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/header.dart';

import '../../services/offers/voucher_pagination.dart';
import '../../widgets/body_base.dart';
import '../../widgets/text_icon.dart';
import 'local/voucher_card_g.dart';

class Voucher extends ConsumerWidget {
  const Voucher({Key? key}) : super(key: key);

  static const String routeName = '/voucher';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;

    final voucherProvider =
        ref.watch(voucherPaginationProvider(VoucherType.individual));
    final voucherFunc =
        ref.read(voucherPaginationProvider(VoucherType.individual).notifier);

    final voucherProviderSingle =
        ref.watch(voucherPaginationProvider(VoucherType.singleUse));
    final voucherFuncSingle =
        ref.read(voucherPaginationProvider(VoucherType.singleUse).notifier);

    final voucherProviderGlobal =
        ref.watch(voucherPaginationProvider(VoucherType.global));
    final voucherFuncGlobal =
        ref.read(voucherPaginationProvider(VoucherType.global).notifier);

    return ScaffoldPage(
      padding: isSmall ? EdgeInsets.zero : null,
      header: header(context, isSmall),
      content: SingleChildScrollView(
        child: BaseBody(
          crossAxisAlignment: CrossAxisAlignment.end,
          widthFactor: isSmall ? 1 : 1.2,
          children: [
            voucherProviderSingle.when(
              data: (global) => global.isEmpty
                  ? const EmptyCard()
                  : Expander(
                      header: const Text('GLOBAL SINGLE USE VOUCHERS'),
                      content: VGrids(
                        vouchers: global,
                        isSmall: isSmall,
                        onPressed: () {
                          voucherFuncSingle.nextPage(global.last);
                        },
                      ),
                    ),
              error: (error, st) => KErrorWidget(error: error, st: st),
              loading: () => const LoadingWidget(),
            ),
            const SizedBox(height: 10),
            voucherProviderGlobal.when(
              data: (global) => global.isEmpty
                  ? const EmptyCard()
                  : Expander(
                      header: const Text('GLOBAL VOUCHERS'),
                      content: VGrids(
                        vouchers: global,
                        isSmall: isSmall,
                        onPressed: () {
                          voucherFuncGlobal.nextPage(global.last);
                        },
                      ),
                    ),
              error: (error, st) => KErrorWidget(error: error, st: st),
              loading: () => const LoadingWidget(),
            ),
            const SizedBox(height: 10),
            voucherProvider.when(
              data: (individual) => individual.isEmpty
                  ? const EmptyCard()
                  : Expander(
                      header: const Text('INDIVIDUAL VOUCHERS'),
                      content: VGrids(
                        vouchers: individual,
                        isSmall: isSmall,
                        onPressed: () {
                          voucherFunc.nextPage(individual.last);
                        },
                      ),
                    ),
              error: (error, st) => KErrorWidget(error: error, st: st),
              loading: () => const LoadingWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context, bool isSmall) {
    return isSmall
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                TextIcon(
                  text: 'Gift Voucher',
                  icon: FluentIcons.giftbox,
                  showBorder: true,
                  onPressed: () {
                    context.pushName(UsersList.routeName);
                  },
                ),
                10.wSpace,
                TextIcon(
                  text: 'Add Global Voucher',
                  icon: FluentIcons.gift_card,
                  showBorder: true,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => const VoucherDialog(
                        isGlobal: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : Header(
            title: 'Voucher',
            showLeading: false,
            commandBar: Row(
              children: [
                FilledButton(
                  child: const Text('GIft Voucher'),
                  onPressed: () {
                    context.pushName(UsersList.routeName);
                  },
                ),
                10.wSpace,
                FilledButton(
                  child: const Text('Add Global Voucher'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => const VoucherDialog(
                        isGlobal: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Center(
          child: Text('E M P T Y'),
        ),
      ),
    );
  }
}

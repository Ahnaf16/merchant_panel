// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/extension/extensions.dart';

import 'package:merchant_panel/extension/widget_extensions.dart';
import 'package:merchant_panel/theme/theme.dart';

import '../../theme/layout_manager.dart';
import '../../widgets/body_base.dart';
import '../../widgets/colored_chip.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/header.dart';
import 'chart_data.dart';
import 'dash_providers.dart';
import 'local/order_count_chart.dart';
import 'local/payment_pie_chart.dart';

class Dash extends ConsumerWidget {
  const Dash({Key? key}) : super(key: key);
  static const String routeName = '/dash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.read(layoutProvider(context));
    // final chartData = ref.watch(cartDataProvider);
    final chartRange = ref.watch(orderChartDateRangeProvider);
    final orderList = ref.watch(allOrderForChartProvider);
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: layout.isSmallScreen
          ? null
          : const Header(
              title: 'DASHBOARD',
              showLeading: false,
            ),
      content: orderList.when(
        data: (data) {
          final chartData = ref.watch(cartDataProvider(data));
          return BaseBody(
            widthFactor: layout.isSmallScreen ? 1 : 1.4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.isEmpty)
                Container(
                  height: 80,
                  decoration: boxDecoration.copyWith(color: Colors.grey[30]),
                  child: const Center(
                    child: Text('E M P T Y'),
                  ),
                ),
              if (data.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ColoredChip(
                      selectedColor: Colors.orange.lightest,
                      text: const Text('7 Days'),
                      selected: chartRange == 7,
                      onTap: () {
                        ref.read(orderChartDateRangeProvider.notifier).state =
                            7;
                      },
                    ),
                    ColoredChip(
                      selectedColor: Colors.orange.lightest,
                      text: const Text('30 Days'),
                      selected: chartRange == 30,
                      onTap: () {
                        ref.read(orderChartDateRangeProvider.notifier).state =
                            30;
                      },
                    ),
                    ColoredChip(
                      selectedColor: Colors.orange.lightest,
                      text: const Text('1 Year'),
                      selected: chartRange == 365,
                      onTap: () {
                        ref.read(orderChartDateRangeProvider.notifier).state =
                            365;
                      },
                    ),
                    ColoredChip(
                      selectedColor: Colors.orange.lightest,
                      text: const Text('All Time'),
                      selected: chartRange == 0,
                      onTap: () {
                        ref.read(orderChartDateRangeProvider.notifier).state =
                            0;
                      },
                    ),
                  ],
                ),
              10.hSpace,
              if (data.isNotEmpty) SaleCountChart(chartData: chartData),
              10.hSpace,
              if (data.isNotEmpty)
                Container(
                  height: 400,
                  width:
                      layout.isSmallScreen ? context.width : context.width / 3,
                  decoration: boxDecoration,
                  child: PieChart(
                    chartData: chartData.getChartData.last,
                    title: 'Todays sale\n'
                        '${chartData.getChartData.last.totalCashAmount.toCurrency(useName: true)} tk'
                        '\n${chartData.getChartData.last.productSold} Orders',
                  ),
                ),
            ],
          );
        },
        error: (error, st) => KErrorWidget(error: error, st: st),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/extension/extensions.dart';

import '../model.dart';

class PaymentPieChart extends StatelessWidget {
  const PaymentPieChart({
    super.key,
    required this.chartData,
    required this.isSmall,
  });
  final ChartModel chartData;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: isSmall ? context.width : context.width / 2,
        maxHeight: 500,
      ),
      content: PieChart(
        chartData: chartData,
        title: '${chartData.date.toFormatDate('dd MMM, yyyy')}'
            '\nRevenue ${chartData.totalCashAmount.toCurrency(useName: true)} tk'
            '\n${chartData.productSold} Orders',
      ),
    );
  }
}

class PieChart extends StatelessWidget {
  const PieChart({
    super.key,
    this.isStandAlone = false,
    required this.chartData,
    this.title = '',
  });
  final String title;
  final ChartModel chartData;
  final bool isStandAlone;
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: title),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        title: LegendTitle(text: 'Payment Methods'),
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: [
        PieSeries<PieChartModel, String>(
          dataSource: chartData.toPieData,
          xValueMapper: (datum, index) => datum.paymentMethod,
          yValueMapper: (datum, index) => datum.count,
          pointColorMapper: (datum, index) => datum.color,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (datum, index) =>
              '${datum.cashAmount.toCurrency(useName: true)}\n${datum.count} orders',
          sortingOrder: SortingOrder.ascending,
          sortFieldValueMapper: (datum, index) => datum.paymentMethod,
        ),
      ],
    );
  }
}

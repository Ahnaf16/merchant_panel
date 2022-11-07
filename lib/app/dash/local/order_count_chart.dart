import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/layout_manager.dart';
import '../../../theme/theme.dart';
import '../chart_data.dart';
import '../model.dart';
import 'payment_pie_chart.dart';

class SaleCountChart extends ConsumerStatefulWidget {
  const SaleCountChart({
    required this.chartData,
    Key? key,
  }) : super(key: key);
  final ChartData chartData;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SaleCountChartState();
}

class _SaleCountChartState extends ConsumerState<SaleCountChart> {
  @override
  Widget build(BuildContext context) {
    final layout = ref.read(layoutProvider(context));
    return Container(
      height: 500,
      decoration: boxDecoration,
      child: SfCartesianChart(
        title: ChartTitle(
          text:
              'Last ${widget.chartData.getDataLength} days sale\n ${widget.chartData.firstDate}  to  ${widget.chartData.lastDate}',
          textStyle: context.textType.body,
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
        ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.currency(
            locale: 'en-bd',
            name: '',
            decimalDigits: 0,
            customPattern: '##,##,##,###',
          ),
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipAlignment: ChartAlignment.near,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: true,
          lineDashArray: const [4, 4],
          markerSettings: const TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.visible,
          ),
          builder: (context, track) {
            final int point = track.groupingModeInfo!.currentPointIndices.first;
            var chartData = widget.chartData.getChartData[point];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text.rich(
                TextSpan(
                  text: chartData.totalCashAmount.toCurrency(useName: true),
                  children: [
                    TextSpan(
                      text:
                          ' tk \non ${chartData.date.toFormatDate('dd MMM, yyyy')}',
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
                style: TextStyle(color: Colors.orange.lightest, height: 1.5),
              ),
            );
          },
        ),
        series: [
          getSeries(context: context, isSmall: layout.isSmallScreen),
          getSeries(
            context: context,
            isSmall: layout.isSmallScreen,
            showCount: false,
          ),
        ],
      ),
    );
  }

  AreaSeries<ChartModel, DateTime> getSeries({
    required BuildContext context,
    bool showCount = true,
    required bool isSmall,
  }) {
    final AccentColor color = showCount ? Colors.green : Colors.orange;
    return AreaSeries<ChartModel, DateTime>(
      isVisible: showCount,
      isVisibleInLegend: !showCount,
      name: showCount ? 'Confirmed Order Count' : ' Revenue',
      dataSource: widget.chartData.getChartData,
      xValueMapper: (order, value) => order.date,
      yValueMapper: (order, value) =>
          showCount ? order.productSold : order.totalCashAmount,
      dataLabelMapper: (datum, index) {
        return datum.totalCashAmount.toCurrency(useName: true);
      },
      borderColor: color.lightest,
      borderWidth: 2,
      gradient: LinearGradient(
        colors: [
          color.lighter.withOpacity(.3),
          color.lighter.withOpacity(.2),
          color.lighter.withOpacity(0),
        ],
        stops: const [
          0.0,
          0.6,
          1.0,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      onPointTap: (ChartPointDetails pointInfo) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => PaymentPieChart(
            chartData: widget.chartData.getChartData[pointInfo.pointIndex!],
            isSmall: isSmall,
          ),
        );
      },
    );
  }

  StackedColumnSeries<ChartModel, String> stackedColumn({
    required ChartData chartData,
    required num? Function(ChartModel, int) yValueMapper,
    required String name,
    required Color color,
  }) {
    return StackedColumnSeries<ChartModel, String>(
      groupName: 'a',
      dataSource: chartData.getChartData,
      xValueMapper: (order, value) => order.date.toFormatDate('dd MMM, yyyy'),
      yValueMapper: yValueMapper,
      color: color,
      name: name,
      enableTooltip: false,
      width: .3,
      isVisible: true,
      markerSettings: const MarkerSettings(isVisible: false),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/dash/model.dart';
import 'package:merchant_panel/extension/extensions.dart';

final cartDataProvider =
    Provider.family<ChartData, List<ChartModel>>((ref, chartModelList) {
  return ChartData(chartModelList);
});

class ChartData {
  ChartData(this.chartModels);

  final List<ChartModel> chartModels;

  List<ChartModel> get getChartData => chartModels;

  int get getDataLength => getChartData.length;

  String get lastDate => chartModels.last.date.toFormatDate('dd MMM, yyyy');
  String get firstDate => chartModels.first.date.toFormatDate('dd MMM, yyyy');
}

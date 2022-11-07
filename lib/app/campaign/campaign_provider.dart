import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/campaign/campaign_model.dart';

final campaignTitleProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

class SelectedCampaignItem extends StateNotifier<List<CampaignItemModel>> {
  SelectedCampaignItem() : super([]);

  void add(CampaignItemModel item) {
    if (state.any((element) => element.id == item.id)) {
      return;
    }
    state = [...state, item];
  }

  void remove(int index) {
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void clear() {
    state = [];
  }

  bool doseContains(String id) {
    return state.any((item) => item.id == id);
  }
}

final selectedProductsNotifierProvider = StateNotifierProvider.autoDispose<
    SelectedCampaignItem, List<CampaignItemModel>>((ref) {
  return SelectedCampaignItem();
});

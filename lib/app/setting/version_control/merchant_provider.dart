import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/system/system_services.dart';

final merchantVersionProvider =
    StateNotifierProvider.autoDispose<MerchantVersionControl, VersionInfo>(
        (ref) {
  final vInfo = ref.watch(canUpdateProvider);
  return MerchantVersionControl(vInfo)..init;
});

class MerchantVersionControl extends StateNotifier<VersionInfo> {
  MerchantVersionControl(this.info) : super(info);

  final versionCtrlWeb = TextEditingController();
  final versionCtrlAndro = TextEditingController();
  final appLinkCtrl = TextEditingController();
  final VersionInfo info;
  final fire = FirebaseFirestore.instance;

  get init {
    versionCtrlWeb.text = toVersion(state.cloudWeb);
    versionCtrlAndro.text = toVersion(state.cloudAndro);
    appLinkCtrl.text = state.link;
  }

  incrementVersion({bool isWeb = false}) {
    if (isWeb) {
      final int newLocal = state.cloudWeb + 1;
      state = state.copyWith(cloudWeb: newLocal);
      versionCtrlWeb.text = toVersion(state.cloudWeb);
    } else {
      final int newAndroLocal = state.cloudAndro + 1;
      state = state.copyWith(cloudAndro: newAndroLocal);
      versionCtrlAndro.text = toVersion(state.cloudAndro);
    }
  }

  decrementVersion({bool isWeb = false}) {
    if (isWeb) {
      final int newLocal = state.cloudWeb - 1;
      state = state.copyWith(cloudWeb: newLocal);
      versionCtrlWeb.text = toVersion(state.cloudWeb);
    } else {
      final int newAndroLocal = state.cloudAndro - 1;
      state = state.copyWith(cloudAndro: newAndroLocal);
      versionCtrlAndro.text = toVersion(state.cloudAndro);
    }
  }

  get reset {
    state = info;
    init;
  }

  void updateVersion() async {
    if (info == state) {
      EasyLoading.showToast('Did Not Change Anything');
    } else {
      EasyLoading.show(status: 'Updating...');
      final ref = fire.collection('inApp').doc('appUpdate');
      await ref.update(state.toMap());
      EasyLoading.showSuccess('Updated');
    }
  }

  String toVersion(int version) {
    return version
        .toString()
        .replaceAll('', '.')
        .substring(0, 6)
        .replaceFirst('.', 'v');
  }

  @override
  void dispose() {
    versionCtrlWeb.dispose();
    versionCtrlAndro.dispose();
    super.dispose();
  }
}

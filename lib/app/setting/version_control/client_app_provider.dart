import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/extensions.dart';

final appVersionProvider = StreamProvider<double>((ref) {
  final fire = FirebaseFirestore.instance;
  final ref = fire.collection('inApp').doc('appUpdate').snapshots();
  final Stream<double> version = ref.map((doc) => doc.data()!['addedVersion']);
  return version;
});

final cloudVersionProvider = Provider<double>((ref) {
  final version = ref.watch(appVersionProvider);
  final getVer = version.maybeWhen(orElse: () => 0.0, data: (data) => data);

  return getVer;
});
final versionProvider =
    StateNotifierProvider<AddedVersionNotifier, double>((ref) {
  final version = ref.watch(cloudVersionProvider);

  return AddedVersionNotifier()..getVersion(version);
});

class AddedVersionNotifier extends StateNotifier<double> {
  AddedVersionNotifier() : super(0.0);

  final versionCtrl = TextEditingController();

  final fire = FirebaseFirestore.instance;

  void getVersion(double version) async {
    versionCtrl.text = version.toString();
    state = version;
  }

  incrementVersion() {
    List splitVersion = [];

    final realVersion = versionCtrl.text.split('.');

    for (String element in realVersion) {
      final value = element.asInt + 1;

      splitVersion.add(value);
    }

    final newVersion = splitVersion.join('.');

    versionCtrl.text = newVersion.toString();
    state = newVersion.asDouble;
  }

  decrementVersion() {
    List splitVersion = [];

    final realVersion = versionCtrl.text.split('.');

    if (!realVersion.contains('1')) {
      for (String element in realVersion) {
        final value = element.asInt - 1;

        splitVersion.add(value);
      }

      final newVersion = splitVersion.join('.');

      versionCtrl.text = newVersion.toString();
      state = newVersion.asDouble;
    } else {
      EasyLoading.showToast('This is lowest version !!');
    }
  }

  reset(double version) {
    state = version;
    versionCtrl.text = version.toStringAsFixed(2);
  }

  void updateVersion(double current) async {
    final double newVersion = double.parse(versionCtrl.text);
    if (current == newVersion) {
      EasyLoading.showToast('Did You Even Change Anything ??');
    } else {
      EasyLoading.show(status: 'Updating...');
      final double version = double.parse(versionCtrl.text);

      await fire.collection('inApp').doc('appUpdate').update({
        'addedVersion': version,
      });
      EasyLoading.showSuccess('Updated');
    }
  }

  @override
  void dispose() {
    versionCtrl.dispose();
    super.dispose();
  }
}

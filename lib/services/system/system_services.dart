// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/nav_pane.dart';

final siteVersionStreamProvider =
    StreamProvider.autoDispose<VersionInfo>((ref) async* {
  final PackageInfo packInfo = await PackageInfo.fromPlatform();

  final fire = FirebaseFirestore.instance;

  final snap = fire.collection('inApp').doc('appUpdate').snapshots();

  final int realLocal = int.parse(packInfo.version.replaceAll('.', ''));

  yield* snap
      .map((doc) => VersionInfo.fromDoc(doc).copyWith(androLocal: realLocal));
});

final canUpdateProvider = Provider.autoDispose<VersionInfo>((ref) {
  final stream = ref.watch(siteVersionStreamProvider);
  final local = ref.watch(localVersionProvider);

  final VersionInfo vInfo = stream.maybeWhen(
    orElse: () => VersionInfo(
      link: '',
      cloudAndro: 0,
      cloudWeb: 0,
    ),
    data: (data) => data.copyWith(local: local),
  );

  return vInfo;
});

class VersionInfo {
  VersionInfo({
    required this.link,
    required this.cloudAndro,
    required this.cloudWeb,
    this.androLocal = 0,
    this.local = 0,
  })  : canUpdateWeb = cloudWeb > local,
        canUpdateAndro = cloudAndro > androLocal;

  factory VersionInfo.fromDoc(DocumentSnapshot doc) {
    return VersionInfo(
      link: doc['link'] as String,
      cloudAndro: doc['mAndroVersion'] as int,
      cloudWeb: doc['mWebVersion'] as int,
    );
  }

  final int androLocal;
  final bool canUpdateAndro;
  final bool canUpdateWeb;
  final int cloudAndro;
  final int cloudWeb;
  final String link;
  final int local;

  @override
  String toString() {
    return 'androLocal: $androLocal, cloudAndro: $cloudAndro, cloudWeb: $cloudWeb, local: $local';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'link': link,
      'mAndroVersion': cloudAndro,
      'mWebVersion': cloudWeb,
    };
  }

  VersionInfo copyWith({
    String? link,
    int? cloudAndro,
    int? cloudWeb,
    bool? canUpdateAndro,
    bool? canUpdateWeb,
    int? local,
    int? androLocal,
  }) {
    return VersionInfo(
      link: link ?? this.link,
      cloudAndro: cloudAndro ?? this.cloudAndro,
      cloudWeb: cloudWeb ?? this.cloudWeb,
      local: local ?? this.local,
      androLocal: androLocal ?? this.androLocal,
    );
  }
}

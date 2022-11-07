import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'link_model.dart';

final getLiveVideos = StreamProvider.autoDispose<List<LiveLinkModel>>((ref) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final snap = firestore
      .collection('inApp')
      .doc('streaming')
      .collection('links')
      .orderBy('type')
      .snapshots();

  return snap.map(
    (snapshot) =>
        snapshot.docs.map((doc) => LiveLinkModel.fromDoc(doc)).toList(),
  );
});

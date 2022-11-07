import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'news_model.dart';

final dailyNewsProvider =
    StreamProvider.autoDispose<List<DailyNewsModel>>((ref) {
  final firestore = FirebaseFirestore.instance;

  final snapShot =
      firestore.collection('news').doc('daily').collection('news').snapshots();

  return snapShot.map(
    (snap) => snap.docs.map((doc) => DailyNewsModel.fromDoc(doc)).toList(),
  );
});

final shoutOutProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  final firestore = FirebaseFirestore.instance;

  final shoutOutRef = firestore.collection('news').doc('shoutOuts').snapshots();

  return shoutOutRef.map(
    (snap) => snap.data() == null ? [] : snap.data()!['news'],
  );
});

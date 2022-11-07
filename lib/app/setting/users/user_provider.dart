import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/setting/users/user_model.dart';

final userListProvider = StateNotifierProvider.autoDispose<UsersListNotifier,
    AsyncValue<List<UserModel>>>(
  (ref) {
    final searchWith = ref.watch(searchBy);

    return UsersListNotifier(searchWith)..firstFetch();
  },
);

class UsersListNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  UsersListNotifier(this.searchWith) : super(const AsyncValue.loading());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final int limit = 20;
  final searchCtrl = TextEditingController();
  final String searchWith;

  void firstFetch() async {
    try {
      final snap = firestore
          .collection('users')
          .orderBy('totalOrders', descending: true)
          .limit(limit)
          .snapshots();

      final users = snap.map((snapshot) =>
          snapshot.docs.map((docs) => UserModel.fromDocument(docs)).toList());
      putData(users);
    } on FirebaseException catch (error, st) {
      state = AsyncValue.error(error, st);
    }
  }

  void loadMore(UserModel last) async {
    final ref = firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .startAfter([last.createdAt]).limit(limit);

    final snap = ref.snapshots();

    final orders = snap.map((snapshot) =>
        snapshot.docs.map((docs) => UserModel.fromDocument(docs)).toList());

    final List<UserModel> stateItem = state.maybeWhen(
      data: (data) => data,
      orElse: () => List.empty(),
    );
    await for (final user in orders) {
      state = AsyncValue.data(stateItem + user);
    }
  }

  String get searchIn {
    final phone = RegExp(r'^[0-9+]{11,14}$');

    final email = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');

    if (phone.hasMatch(searchCtrl.text)) {
      return 'phone';
    } else if (email.hasMatch(searchCtrl.text)) {
      return 'email';
    } else {
      return 'displayName';
    }
  }

  void search() async {
    final searchRef = firestore.collection('users');

    final searchSnap = searchIn != 'displayName'
        ? searchRef.where(searchIn, isEqualTo: searchCtrl.text).snapshots()
        : searchRef.snapshots();

    final users = searchSnap.map((snapshot) {
      if (searchIn != 'displayName') {
        log(searchIn);

        return snapshot.docs.map((doc) {
          return UserModel.fromDocument(doc);
        }).toList();
      } else {
        log(searchIn);

        return snapshot.docs
            .where((doc) => doc['displayName']
                .toString()
                .toLowerCase()
                .contains(searchCtrl.text))
            .map((e) => UserModel.fromDocument(e))
            .toList();
      }
    });

    await putData(users);
  }

  putData(Stream<List<UserModel>> userStream) async {
    await for (final user in userStream) {
      state = AsyncValue.data(user);
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}

final totalUserProvider = StreamProvider.autoDispose<String>((ref) async* {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final snap = await firestore.collection('users').get();

  yield snap.size.toString();
});

final searchBy = StateProvider<String>((ref) {
  return 'Name';
});

final userByUid =
    StreamProvider.autoDispose.family<UserModel?, String?>((ref, uid) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  if (uid != null) {
    final snap = firestore.collection('users').doc(uid).snapshots();

    final stream = snap.map((snapshot) => UserModel.fromDocument(snapshot));

    return stream;
  } else {
    return Stream.value(null);
  }
});

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/newsfeed/news_model.dart';

import 'image_services.dart';

final newsApiProvider =
    StateNotifierProvider<NewsApiNotifier, DailyNewsModel>((ref) {
  return NewsApiNotifier();
});

class NewsApiNotifier extends StateNotifier<DailyNewsModel> {
  NewsApiNotifier() : super(DailyNewsModel(img: '', news: '', title: ''));

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController newsCtrl = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  setImg(String img) {
    state = state.copyWith(img: img);
    log('img set');
  }

  resetImg() {
    state = state.copyWith(img: '');
    log('img set');
  }

  addDailyNews() async {
    if (state.img.isEmpty) {
      EasyLoading.showError('Select an Image');
    } else if (titleCtrl.text.isEmpty) {
      EasyLoading.showError('Title is empty');
    } else if (newsCtrl.text.isEmpty) {
      EasyLoading.showError('News is empty');
    } else {
      EasyLoading.show(status: 'Loading...');

      final ref = firestore.collection('news').doc('daily').collection('news');

      final imgUrl = await UploadImage.uploadSingleImg(
        path: 'news/daily',
        imagePath: state.img,
        fileName: titleCtrl.text,
      );

      if (imgUrl != 'err') {
        await setImg(imgUrl);

        await ref.add(
          DailyNewsModel(
            title: titleCtrl.text,
            img: imgUrl,
            news: newsCtrl.text,
          ).toMap(),
        );
        EasyLoading.showSuccess('News Published');
        clear();
      } else {
        EasyLoading.showError('err');
      }
    }
  }

  addShoutOut() async {
    if (titleCtrl.text.isEmpty) {
      EasyLoading.showError('Title is empty');
    } else {
      EasyLoading.show(status: 'Loading...');
      log(titleCtrl.text.toString());
      final ref = firestore.collection('news').doc('shoutOuts');

      await ref.update({
        'news': FieldValue.arrayUnion([titleCtrl.text]),
      });
      EasyLoading.showSuccess('Shout-outs Published');
      titleCtrl.clear();
    }
  }

  deleteShoutOut(String shout) async {
    EasyLoading.show(status: 'Loading...');

    final ref = firestore.collection('news').doc('shoutOuts');

    await ref.update({
      'news': FieldValue.arrayRemove([shout]),
    });

    EasyLoading.showSuccess('Shout-outs Deleted');
    titleCtrl.clear();
  }

  deleteDailyNews(DailyNewsModel news) async {
    EasyLoading.show(status: 'Loading...');

    final ref = firestore
        .collection('news')
        .doc('daily')
        .collection('news')
        .doc(news.id);

    await ref.delete();

    await UploadImage.deleteImage(path: 'news/daily', fileName: news.title);

    EasyLoading.showSuccess('Daily News Deleted');
    titleCtrl.clear();
  }

  clear() {
    titleCtrl.clear();
    newsCtrl.clear();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    newsCtrl.dispose();
    super.dispose();
  }
}

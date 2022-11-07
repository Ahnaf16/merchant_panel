// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class DailyNewsModel {
  final String title;
  final String img;
  final String news;
  final String id;

  DailyNewsModel({
    required this.title,
    required this.img,
    required this.news,
    this.id = '',
  });

  factory DailyNewsModel.fromDoc(DocumentSnapshot doc) {
    return DailyNewsModel(
      title: doc['title'] as String,
      img: doc['img'] as String,
      news: doc['news'] as String,
      id: doc.id,
    );
  }

  DailyNewsModel copyWith({
    String? title,
    String? img,
    String? news,
  }) {
    return DailyNewsModel(
      title: title ?? this.title,
      img: img ?? this.img,
      news: news ?? this.news,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'img': img,
      'news': news,
    };
  }

  @override
  String toString() => 'DailyNewsModel(title: $title, img: $img, news: $news)';
}

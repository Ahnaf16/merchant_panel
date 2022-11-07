// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class LiveLinkModel {
  final String url;
  final String img;
  final LinkType type;
  final bool isLive;
  final String? docId;

  const LiveLinkModel({
    required this.url,
    required this.img,
    required this.type,
    required this.isLive,
    this.docId,
  });

  factory LiveLinkModel.fromDoc(DocumentSnapshot doc) {
    return LiveLinkModel(
      url: doc['url'] as String,
      img: doc['img'] as String,
      type: LinkType.fromString(doc['type']),
      isLive: doc['isLive'] as bool,
      docId: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'img': img,
      'type': type.name,
      'isLive': isLive,
    };
  }

  LiveLinkModel copyWith({
    String? url,
    String? img,
    LinkType? type,
    bool? isLive,
  }) {
    return LiveLinkModel(
      url: url ?? this.url,
      img: img ?? this.img,
      type: type ?? this.type,
      isLive: isLive ?? this.isLive,
    );
  }
}

enum LinkType {
  youtube,
  webView,
  m3u8;

  factory LinkType.fromString(String type) {
    switch (type) {
      case 'youtube':
        return LinkType.youtube;

      case 'webview':
        return LinkType.webView;

      case 'm3u8':
        return LinkType.m3u8;

      default:
        return LinkType.webView;
    }
  }
}

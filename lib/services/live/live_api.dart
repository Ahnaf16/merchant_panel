import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../app/setting/live_stream/link_model.dart';
import '../image_services.dart';

final addLinkProvider =
    StateNotifierProvider.autoDispose<LiveLinkNotifier, LiveLinkModel>((ref) {
  return LiveLinkNotifier();
});

class LiveLinkNotifier extends StateNotifier<LiveLinkModel> {
  LiveLinkNotifier()
      : super(
          const LiveLinkModel(
            url: '',
            img: '',
            type: LinkType.youtube,
            isLive: false,
          ),
        );

  final urlCtrl = TextEditingController();
  YoutubePlayerController ytCtrl = YoutubePlayerController();

  checkLink() {
    if (state.type == LinkType.youtube) {
      final cleanedId = cleanId(urlCtrl.text);

      state = state.copyWith(url: cleanedId);

      ytCtrl.onInit = () {
        ytCtrl.cueVideoById(videoId: state.url);
      };
    } else {
      state = state.copyWith(url: urlCtrl.text);
    }
  }

  String? cleanId(String source) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return YoutubePlayerController.convertUrlToId(source);
    } else if (state.type == LinkType.youtube && source.length != 11) {
      EasyLoading.showError('Invalid Source');
    }
    return source;
  }

  isLiveToggle(bool value) {
    if (state.type == LinkType.youtube) {
      state = state.copyWith(isLive: value);
    }
    if (state.type == LinkType.webView && !state.isLive) {
      state = state.copyWith(isLive: true);
    }
  }

  setUrlType(LinkType type) {
    state = state.copyWith(type: type);
    if (type == LinkType.webView) {
      isLiveToggle(true);
    }
    if (type == LinkType.youtube) {
      isLiveToggle(false);
    }
  }

  setImgUrl(String imgUrl) async {
    state = state.copyWith(img: imgUrl);
  }

  Future<String> uploadImg() async {
    return await UploadImage.uploadSingleImg(
      path: 'streaming',
      imagePath: state.img,
      fileName:
          '${state.type.name}_${state.isLive}_${state.url.split('/').last}',
    );
  }

  uploadToServer(String imgUrl) async {
    EasyLoading.show();

    await setImgUrl(imgUrl);
    if (state.img.isEmpty) {
      EasyLoading.showError('No Image Selected');
    } else if (state.url.isEmpty) {
      EasyLoading.showError('No URL was given');
    } else if (state.type == LinkType.webView && !state.isLive) {
      EasyLoading.showError('Stream Link must be Live');
    } else {
      final imgDownloadUrl = await uploadImg();

      await setImgUrl(imgDownloadUrl);

      final fire = FirebaseFirestore.instance;

      final ref = fire.collection('inApp').doc('streaming').collection('links');

      await ref.add(state.toMap());

      EasyLoading.showSuccess('done');
    }
  }

  deleteVideoLink(LiveLinkModel videoModel) async {
    final fire = FirebaseFirestore.instance;

    final ref = fire
        .collection('inApp')
        .doc('streaming')
        .collection('links')
        .doc(videoModel.docId);

    await ref.delete();
    await UploadImage.deleteImage(
      fileName:
          '${videoModel.type.name}_${videoModel.isLive}_${videoModel.url.split('/').last}',
      path: 'streaming',
    );
  }

  clear() {
    state = const LiveLinkModel(
      url: '',
      img: '',
      type: LinkType.youtube,
      isLive: false,
    );
    urlCtrl.clear();
  }

  @override
  void dispose() {
    ytCtrl.close();
    urlCtrl.dispose();
    super.dispose();
  }
}

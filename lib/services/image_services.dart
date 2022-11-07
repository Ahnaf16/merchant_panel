import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage {
  static Future<String> uploadSingleImg({
    /// Path where the image will be saved in storage.
    required String path,

    ///Image File path
    required String imagePath,

    ///image name
    required String fileName,
  }) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    await EasyLoading.show(status: 'Uploading image');

    final reference = storage.ref().child('$path/$fileName').child(fileName);

    try {
      final upTask = reference.putData(
        await XFile(imagePath).readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final url = await upTask.then(
        (snap) => snap.ref.getDownloadURL(),
      );
      EasyLoading.showSuccess('Image Uploaded');
      return url;
    } on Exception catch (e) {
      log(e.toString());
      return 'err';
    }
  }

  static Future<List<String>> uploadMultiImage({
    required String fileName,
    required List imgPaths,
    required int price,
  }) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    List<String> urls = [];
    for (final path in imgPaths) {
      EasyLoading.show(
          status:
              'Uploading ${imgPaths.indexOf(path)} out of ${imgPaths.length} images');

      Reference reference = storage
          .ref()
          .child('products_image/${fileName}_$price')
          .child('${fileName}_${imgPaths.indexOf(path)}');

      final upTask = await reference.putData(
        await XFile(path).readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final url = await upTask.ref.getDownloadURL();

      urls.add(url);
      EasyLoading.showSuccess('Image Uploaded');
    }
    return urls;
  }

  static deleteImage({
    required String path,
    required String fileName,
  }) async {
    EasyLoading.show();
    final FirebaseStorage storage = FirebaseStorage.instance;
    final reference = storage.ref().child('$path/$fileName');

    final itemList = await reference.list();
    for (final item in itemList.items) {
      await item.delete();
    }
    EasyLoading.showSuccess('Image Deleted');
  }
}

class SelectImage extends StateNotifier<List<String>> {
  SelectImage() : super([]);

  selectImgs() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickMultiImage();
    for (final xfile in pickedFile) {
      final path = File(xfile.path).path;
      state = [...state, path];
    }
  }

  Future<List<String>> selectSingleImage() async {
    state = [];
    final ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      XFile selectedImg = pickedFile;

      final path = File(selectedImg.path).path;
      state = [...state, path];
      return state;
    } else {
      return [];
    }
  }

  void addImagePath(List<String> path) {
    state = [...state, ...path];
  }

  void removeImagePath(int index) {
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void clearImagePath() {
    state = [];
  }
}

final imgSelectionProvider =
    StateNotifierProvider.autoDispose<SelectImage, List<String>>((ref) {
  return SelectImage();
});

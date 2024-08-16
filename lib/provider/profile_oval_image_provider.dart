import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// TODO: 보여주는건 Image, 업로드는 File
class ProfileOvalImageProvider with ChangeNotifier {
  File? _imageFile;

  File? get imageFile => _imageFile;

  set imageFile(File? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }

  // TODO: 이미지 픽해서 올리고, get으로 이미지 변환
  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}

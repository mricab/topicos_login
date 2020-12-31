import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Photo {
  final _imgPicker = ImagePicker();
  File img;

  Future getImage() async {
    final pickedImg = await _imgPicker.getImage(source: ImageSource.gallery);
    if (pickedImg != null) {
      img = File(pickedImg.path);
    } else {
      print('No image selected.');
    }
    // setState(() {
    //   if (pickedImg != null) {
    //     _img = File(pickedImg.path);
    //   } else {
    //     print('No image selected.');
    //   }
    // });
  }

  Future getImageFromGallery() async {
    final pickedImg = await _imgPicker.getImage(source: ImageSource.gallery);
    if (pickedImg != null) {
      img = File(pickedImg.path);
    } else {
      print('No image selected from gallery.');
    }
  }

  Future getImageFromCamera() async {
    final pickedImg = await _imgPicker.getImage(source: ImageSource.camera);
    if (pickedImg != null) {
      img = File(pickedImg.path);
    } else {
      print('No image selected from camera.');
    }
  }
}

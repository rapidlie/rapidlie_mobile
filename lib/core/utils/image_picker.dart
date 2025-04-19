import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  //static Future<File?> pickImageFromGallery(File? imageFile) async {
  static Future<File?> pickImageFromGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: Get.width,
      );
      if (pickedFile != null) {
        final File convertedImagefile = File(pickedFile.path);
        //imageFile = convertedImagefile;
        return convertedImagefile;
      }
      return null;
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }
}

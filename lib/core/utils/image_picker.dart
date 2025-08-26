import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  //static Future<File?> pickImageFromGallery(File? imageFile) async {
  static Future<File?> pickImageFromGallery({double? maxWidth}) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
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

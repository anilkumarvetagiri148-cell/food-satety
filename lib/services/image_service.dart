import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImageFromGallery() async {
    try {
      return await _picker.pickImage(source: ImageSource.gallery);
    } catch (_) {
      return null;
    }
  }

  static Future<XFile?> pickImageFromCamera() async {
    try {
      return await _picker.pickImage(source: ImageSource.camera);
    } catch (_) {
      return null;
    }
  }
}

import 'package:image_picker/image_picker.dart';

class srvFiles {
  static Future<String?> getImage({bool blnCamera = false}) async {
    var image = await ImagePicker.platform.pickImage(
        source: blnCamera ? ImageSource.camera : ImageSource.gallery);
    return image?.path;
  }
}

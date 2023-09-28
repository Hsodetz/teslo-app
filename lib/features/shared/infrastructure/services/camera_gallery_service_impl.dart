import 'package:image_picker/image_picker.dart';

import 'camera_gallery_service.dart';

class CameraGalleryServiceImpl implements CameraGalleryService {

  final ImagePicker picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async{
    
     // Pick an image.
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (photo == null) return null;

    //print(photo.path);

    return photo.path;

  }

  @override
  Future<String?> takePhoto() async{
   
    // Capture a photo.
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    //print(photo.path);

    return photo.path;

  }
  
}
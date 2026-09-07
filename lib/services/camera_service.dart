import 'package:camera/camera.dart';

class CameraService {
  static List<CameraDescription> _cameras = [];
  static CameraController? controller;

  static Future<bool> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return false;
      controller = CameraController(
        _cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller?.initialize();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<XFile?> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return null;
    try {
      return await controller!.takePicture();
    } catch (_) {
      return null;
    }
  }

  static void dispose() {
    controller?.dispose();
    controller = null;
  }
}

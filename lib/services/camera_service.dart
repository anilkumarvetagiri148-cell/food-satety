import 'package:camera/camera.dart';

class CameraService {
  static List<CameraDescription> _cameras = [];
  static CameraController? controller;
  static int _selectedCameraIndex = 0;

  static Future<bool> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return false;
      _selectedCameraIndex = 0;
      return await _initController(_cameras[_selectedCameraIndex]);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _initController(CameraDescription camera) async {
    try {
      await controller?.dispose();
      controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller?.initialize();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> switchCamera() async {
    if (_cameras.length < 2) return false;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    return await _initController(_cameras[_selectedCameraIndex]);
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

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/scan_provider.dart';
import '../services/camera_service.dart';
import '../services/image_service.dart';
import '../utils/app_colors.dart';
import '../utils/helpers.dart';
import '../widgets/loading_widget.dart';

class ScanFoodScreen extends StatefulWidget {
  const ScanFoodScreen({super.key});

  @override
  State<ScanFoodScreen> createState() => _ScanFoodScreenState();
}

class _ScanFoodScreenState extends State<ScanFoodScreen> {
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final success = await CameraService.initialize();
    if (mounted) {
      setState(() => _isCameraInitialized = success);
    }
  }

  @override
  void dispose() {
    CameraService.dispose();
    super.dispose();
  }

  void _captureImage() async {
    final xFile = await CameraService.takePicture();
    if (!mounted) return;
    if (xFile != null) {
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      Navigator.pushNamed(context, AppRoutes.scanAnalysis);
      await scanProvider.analyzeFood(null, xFile.path);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.scanResult);
    } else {
      // Fallback mock capture if hardware camera not fully available on simulator
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      Navigator.pushNamed(context, AppRoutes.scanAnalysis);
      await scanProvider.analyzeFood('Fresh Organic Apple');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.scanResult);
    }
  }

  void _pickFromGallery() async {
    final xFile = await ImageService.pickImageFromGallery();
    if (!mounted) return;
    if (xFile != null) {
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      Navigator.pushNamed(context, AppRoutes.scanAnalysis);
      await scanProvider.analyzeFood(null, xFile.path);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.scanResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview or Fallback
          if (_isCameraInitialized && CameraService.controller != null)
            SizedBox.expand(child: CameraPreview(CameraService.controller!))
          else
            const LoadingWidget(message: 'Initializing camera...'),

          // Overlay / Scanning Frame
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Food Safety Scanner',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white, size: 24),
                        onPressed: () {
                          setState(() => _isFlashOn = !_isFlashOn);
                          CameraService.controller?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
                        },
                      ),
                    ],
                  ),
                ),

                // Center Guide Frame & Instruction
                Column(
                  children: [
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.secondaryGreen, width: 3),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated line simulation
                          Container(
                            height: 2,
                            width: 260,
                            color: AppColors.secondaryGreen,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Place the food/product inside the frame.',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                        onPressed: _pickFromGallery,
                      ),
                      GestureDetector(
                        onTap: _captureImage,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.white, size: 32),
                        onPressed: () {
                          Helpers.showSnackBar(context, 'Align food packaging or fruit clearly in center.');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../data/food_database.dart';
import '../models/food_model.dart';
import '../providers/scan_provider.dart';
import '../services/camera_service.dart';
import '../services/image_service.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_food_background.dart';
import '../widgets/food_card.dart';
import '../widgets/food_image_widget.dart';
import '../widgets/loading_widget.dart';

class ScanFoodScreen extends StatefulWidget {
  const ScanFoodScreen({super.key});

  @override
  State<ScanFoodScreen> createState() => _ScanFoodScreenState();
}

class _ScanFoodScreenState extends State<ScanFoodScreen> with SingleTickerProviderStateMixin {
  bool _isCameraInitialized = false;
  bool _isInitializing = true;
  bool _isFlashOn = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = const ['All', 'Vegetables', 'Fruits', 'Dry Fruits', 'High Protein'];

  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _initCamera();

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _scanAnimationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initCamera() async {
    final success = await CameraService.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = success;
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    CameraService.dispose();
    _scanAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _switchCamera() async {
    setState(() => _isInitializing = true);
    final success = await CameraService.switchCamera();
    if (mounted) {
      setState(() {
        _isCameraInitialized = success;
        _isInitializing = false;
      });
    }
  }

  Future<void> _triggerScanForFood(FoodModel food, [String? imagePath]) async {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    Navigator.pushNamed(context, AppRoutes.scanAnalysis);
    await scanProvider.analyzeFood(null, imagePath ?? food.image, food);
    await scanProvider.saveCurrentScan();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.scanResult);
  }

  void _captureImage() async {
    final xFile = await CameraService.takePicture();
    if (!mounted) return;
    // Pick a random item from the 40 food database on every capture
    final randomIndex = Random().nextInt(FoodDatabase.allFoods.length);
    final randomFood = FoodDatabase.allFoods[randomIndex];
    await _triggerScanForFood(randomFood, xFile?.path);
  }

  void _scanRandomFood() {
    final randomIndex = Random().nextInt(FoodDatabase.allFoods.length);
    final randomFood = FoodDatabase.allFoods[randomIndex];
    _triggerScanForFood(randomFood);
  }

  void _pickFromGallery() async {
    final xFile = await ImageService.pickImageFromGallery();
    if (!mounted) return;
    if (xFile != null) {
      _showGalleryDemoSheet(xFile.path);
    }
  }

  void _showGalleryDemoSheet(String imagePath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  FoodImageWidget(
                    imagePath: imagePath,
                    width: 60,
                    height: 60,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gallery Image Selected',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Image analysis is currently running in demo mode.',
                          style: TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Select the matching food item below to analyze:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: FoodDatabase.allFoods.length,
                  itemBuilder: (context, index) {
                    final food = FoodDatabase.allFoods[index];
                    return FoodCard(
                      food: food,
                      onTap: () {
                        Navigator.pop(ctx);
                        _triggerScanForFood(food, imagePath);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<FoodModel> get _filteredFoods {
    List<FoodModel> list = FoodDatabase.getByCategory(_selectedCategory);
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((f) => f.name.toLowerCase().contains(q) || f.category.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1911),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1911),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.center_focus_strong_rounded, color: AppColors.secondaryGreen, size: 22),
            SizedBox(width: 8),
            Text('Scan Food', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded, color: Colors.white),
            tooltip: 'Toggle Flash',
            onPressed: () {
              setState(() => _isFlashOn = !_isFlashOn);
              CameraService.controller?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded, color: Colors.white),
            tooltip: 'Switch Camera',
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CAMERA PREVIEW & SCANNING FRAME
            Container(
              height: 380,
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isCameraInitialized && CameraService.controller != null)
                    SizedBox.expand(child: CameraPreview(CameraService.controller!))
                  else if (_isInitializing)
                    const LoadingWidget(message: 'Initializing camera...')
                  else
                    AnimatedFoodBackground(
                      backgroundImage: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=1000&q=80',
                      imageOpacity: 0.35,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryGreen.withValues(alpha: 0.8),
                              Colors.black.withValues(alpha: 0.85),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondaryGreen, width: 3),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryGreen.withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            Positioned(
                              top: _scanAnimation.value * 230,
                              left: 10,
                              right: 10,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryGreen,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.secondaryGreen.withValues(alpha: 0.9),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco_rounded, color: AppColors.secondaryGreen, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Place the food inside the scanning frame',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CAMERA CONTROLS
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              color: const Color(0xFF14241B),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 28),
                    tooltip: 'Gallery Pick',
                    onPressed: _pickFromGallery,
                  ),

                  GestureDetector(
                    onTap: _captureImage,
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryGreen.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 26),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.shuffle_rounded, color: Colors.white, size: 28),
                    tooltip: 'Scan Random Food Item',
                    onPressed: _scanRandomFood,
                  ),
                ],
              ),
            ),

            // DEMO RECOGNITION & 40 FOOD DATABASE SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Row(
                          children: [
                            Icon(Icons.fastfood_rounded, color: AppColors.primaryGreen, size: 22),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Choose Food for Demo Scan',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 105,
                        height: 36,
                        child: ElevatedButton.icon(
                          onPressed: _scanRandomFood,
                          icon: const Icon(Icons.shuffle_rounded, size: 14),
                          label: const Text('Random', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGreen,
                            foregroundColor: AppColors.primaryGreen,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select any item or tap Random to scan different foods from our 40-food database.',
                    style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: const InputDecoration(
                        hintText: 'Search food...',
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.primaryGreen),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppColors.primaryGreen,
                            backgroundColor: AppColors.lightGreen,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_filteredFoods.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: const Text('No food items match your search query.'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = _filteredFoods[index];
                        return FoodCard(
                          food: food,
                          onTap: () => _triggerScanForFood(food),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

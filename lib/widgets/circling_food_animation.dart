import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HealthyFoodItem {
  final String emoji;
  final String name;
  final String category; // 'Vegetables', 'Fruits', 'Proteins', 'Grains'
  final Color color;

  const HealthyFoodItem({
    required this.emoji,
    required this.name,
    required this.category,
    required this.color,
  });
}

const List<HealthyFoodItem> kHealthyFoodItems = [
  HealthyFoodItem(emoji: '🥦', name: 'Broccoli', category: 'Vegetables', color: Colors.green),
  HealthyFoodItem(emoji: '🍎', name: 'Apple', category: 'Fruits', color: Colors.redAccent),
  HealthyFoodItem(emoji: '🥑', name: 'Avocado', category: 'Healthy Fats', color: Colors.lightGreen),
  HealthyFoodItem(emoji: '🥕', name: 'Carrot', category: 'Vegetables', color: Colors.orange),
  HealthyFoodItem(emoji: '🥩', name: 'Lean Meat', category: 'Proteins', color: Colors.deepOrange),
  HealthyFoodItem(emoji: '🥚', name: 'Eggs', category: 'Proteins', color: Colors.amber),
  HealthyFoodItem(emoji: '🍊', name: 'Orange', category: 'Fruits', color: Colors.orangeAccent),
  HealthyFoodItem(emoji: '🍗', name: 'Chicken', category: 'Proteins', color: Colors.brown),
  HealthyFoodItem(emoji: '🫐', name: 'Blueberry', category: 'Fruits', color: Colors.indigo),
  HealthyFoodItem(emoji: '🥬', name: 'Spinach', category: 'Vegetables', color: Colors.teal),
];

class CirclingFoodAnimation extends StatefulWidget {
  final double radius;
  final Widget? centerChild;
  final List<HealthyFoodItem> items;
  final bool reverseDirection;
  final Duration duration;

  const CirclingFoodAnimation({
    super.key,
    this.radius = 120,
    this.centerChild,
    this.items = kHealthyFoodItems,
    this.reverseDirection = false,
    this.duration = const Duration(seconds: 12),
  });

  @override
  State<CirclingFoodAnimation> createState() => _CirclingFoodAnimationState();
}

class _CirclingFoodAnimationState extends State<CirclingFoodAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2 + 70,
      height: widget.radius * 2 + 70,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angleOffset = _controller.value * 2 * math.pi * (widget.reverseDirection ? -1 : 1);
          final itemCount = widget.items.length;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glowing Ring Line
              Container(
                width: widget.radius * 2,
                height: widget.radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.25),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.08),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),

              // Center Child widget if any
              if (widget.centerChild != null) widget.centerChild!,

              // Circling Food Badges
              ...List.generate(itemCount, (index) {
                final angle = angleOffset + (index * 2 * math.pi / itemCount);
                final x = widget.radius * math.cos(angle);
                final y = widget.radius * math.sin(angle);
                final item = widget.items[index];

                return Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: item.color.withValues(alpha: 0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: item.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  // Map categories to appropriate icons
  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Pizza', 'icon': Icons.local_pizza_rounded},
    {'name': 'Burgers', 'icon': Icons.lunch_dining_rounded},
    {'name': 'Sushi', 'icon': Icons.rice_bowl_rounded},
    {'name': 'Desserts', 'icon': Icons.cake_rounded},
    {'name': 'Drinks', 'icon': Icons.local_drink_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final String name = category['name'];
          final IconData icon = category['icon'];
          final bool isSelected = name == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => onCategoryChanged(name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  color: isSelected
                      ? null
                      : (isDark ? AppTheme.darkCard : Colors.white),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  boxShadow: isSelected ? AppTheme.getShadow(context) : null,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
                          width: 1,
                        ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

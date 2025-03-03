import 'package:flutter/material.dart';
import 'package:bulletin_board/outer_layer/category_label.dart';

class CategoryDropdown extends StatelessWidget {
  final CategoryLabel? selectedCategory;
  final ValueChanged<CategoryLabel?> onChanged;

  const CategoryDropdown({required this.selectedCategory, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Категория товара"),
        DropdownButton<CategoryLabel>(
          value: selectedCategory,
          items: CategoryLabel.values.map((category) {
            return DropdownMenuItem<CategoryLabel>(
              value: category,
              child: Text(category.label),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

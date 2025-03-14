import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bulletin_board/advertisement_create/bloc/advertisement_create_bloc.dart';
import 'package:bulletin_board/advertisement_create/models/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel?> onChanged;

  const CategoryDropdown({super.key, required this.selectedCategory, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementCreateBloc, AdvertisementCreateState>(
      builder: (context, state) {
        if (state is AdvertisementCreateInitial) {
          return DropdownButton<CategoryModel>(
            value: selectedCategory,
            items: state.categories.map((category) {
              return DropdownMenuItem<CategoryModel>(
                value: category,
                child: Text(category.label),
              );
            }).toList(),
            onChanged: onChanged,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

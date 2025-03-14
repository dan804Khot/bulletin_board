import 'dart:io';
import 'category_model.dart';

class AdvertisementForm {
  final String title;
  final String description;
  final CategoryModel category;
  final String price;
  final String name;
  final String phone;
  final File? image;

  AdvertisementForm({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.name,
    required this.phone,
    this.image,
  });
}

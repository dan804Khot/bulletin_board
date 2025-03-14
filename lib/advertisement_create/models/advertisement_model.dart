import 'package:bulletin_board/advertisement_create/models/models.dart';

class AdvertisementModel {
  final String id;
  final String title;
  final String description;
  final CategoryModel category;
  final String price;
  final String name;
  final String phone;
  final String? imageUrl;
  final DateTime timestamp;

  AdvertisementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.name,
    required this.phone,
    this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.label,
      'price': price,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

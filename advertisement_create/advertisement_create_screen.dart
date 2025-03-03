import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bulletin_board/advertisement_create/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulletin_board/outer_layer/outer_layer.dart';
import 'package:bulletin_board/advertisement_list.dart';

class AdvertisementCreate extends StatefulWidget {
  const AdvertisementCreate({super.key});

  @override
  _AdvertisementCreate createState() => _AdvertisementCreate();
}

class _AdvertisementCreate extends State<AdvertisementCreate> {
  CategoryLabel? _selectedCategory;
  File? _selectedImage;
  bool _isFree = false;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final firebaseInit = FirebaseInitialization();

  // Метод сохранения объявления
  Future<void> _saveAd() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля!')),
      );
      return;
    }

    String adId = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> adData = {
      'ad_id': adId,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory!.label,
      'price': _isFree ? 'Бесплатно' : _priceController.text,
      'name': _nameController.text,
      'phone': _numberController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Сохранение данных в Firebase
    firebaseInit.createTable(adId, adData);

    // Сохранение изображения, если оно выбрано
    if (_selectedImage != null) {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String imageBase64 = base64Encode(imageBytes);
      await DatabaseHelper().saveImage(adId, imageBase64);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Объявление сохранено!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdvertisementList()),
    );
  }

  // Метод для выбора изображения
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abuto"),
        backgroundColor: Colors.green[300],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveAd, // Вызов метода сохранения объявления
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название объявления
            CustomTextField(controller: _titleController, label: "Название объявления"),
            const SizedBox(height: 16),

            // Стоимость
            CustomTextField(
              controller: _priceController,
              label: "Стоимость",
              enabled: !_isFree,
              keyboardType: TextInputType.number,
            ),
            FreeCheckbox(
              isFree: _isFree,
              onChanged: (bool? value) {
                setState(() {
                  _isFree = value ?? false;
                  if (_isFree) {
                    _priceController.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Кнопка для добавления изображения
            PickImageButton(onPressed: _pickImage),
            ImagePreview(selectedImage: _selectedImage),
            const SizedBox(height: 16),

            // Имя пользователя
            CustomTextField(controller: _nameController, label: "Ваше имя"),
            const SizedBox(height: 16),

            // Категория товара
            CategoryDropdown(
              selectedCategory: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Номер телефона
            CustomTextField(
              controller: _numberController,
              label: "Ваш номер телефона",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Описание объявления
            CustomTextField(controller: _descriptionController, label: "Описание объявления"),
          ],
        ),
      ),
    );
  }
}

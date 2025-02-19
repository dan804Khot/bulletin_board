import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'advertisementList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}
void main() {
  runApp(const MyApp());
  initFirebase();
}

enum CategoryLabel {
  Electric('Электроника'),
  Pets('Домашние животные'),
  Apart('Недвижимость'),
  furn('Мебель'),
  ClAndSh('Одежда и обувь');

  const CategoryLabel(this.label);
  final String label;
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abuto',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const FormScreen(),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
CategoryLabel? _selectedCategory;
  File? _selectedImage;
  bool _isFree = false;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

 Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
    print("Выбранный файл: ${pickedFile.path}"); 
  } else {
    print("Файл не был выбран!"); 
  }
}

  Future<String?> uploadImageToCloudinary(File imageFile) async {
  try {
    await dotenv.load();

    String cloudName = dotenv.env['dcrjsp6cn']!;
    
    String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['upload_preset'] = 'ml_default' 
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    if (response.statusCode == 200) {
      return jsonData["secure_url"]; 
    } else {
      print("Ошибка загрузки: ${jsonData['error']['message']}");
      return null;
    }
  } catch (e) {
    print("Ошибка при загрузке: $e");
    return null;
  }
}


  Future<void> addDataToFirestore(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('advertisements').add(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Объявление добавлено!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdvertisementList()),
      );
    } catch (e) {
      print("Ошибка при добавлении данных: $e");
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
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
              _descriptionController.text.isNotEmpty &&
              _nameController.text.isNotEmpty &&
              _numberController.text.isNotEmpty &&
              _selectedCategory != null) {
                String? imageUrl;
                if (_selectedImage != null) {
                  imageUrl = await uploadImageToCloudinary(_selectedImage!);
                  }
                  Map<String, dynamic> data = {
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'category': _selectedCategory!.label,
                    'price': _isFree ? 'Бесплатно' : _priceController.text,
                    'name': _nameController.text,
                    'phone': _numberController.text,
                    'image_url': imageUrl ?? '',
                    'timestamp': FieldValue.serverTimestamp(),
                    };
                    try {
                      await FirebaseFirestore.instance.collection('advertisements').add(data);
                      print('Объявление успешно добавлено!');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdvertisementList()),
                        );
                        } catch (e) {
                          print("Ошибка при добавлении объявления: $e");
                        }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Пожалуйста, заполните все поля!')),
                          );
                        }
                      },
                    icon: const Icon(Icons.check),
                  ),
                ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Название объявления"),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("Стоимость"),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              enabled: !_isFree,
            ),
            Row(
              children: [
                Checkbox(
                  value: _isFree,
                  onChanged: (bool? value) {
                    setState(() {
                      _isFree = value ?? false;
                      if (_isFree) {
                        _priceController.clear();
                      }
                    });
                  },
                ),
                const Text("Бесплатно"),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Выберите фото"),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Добавить фото"),
            ),
            if (_selectedImage != null) Image.file(_selectedImage!, height: 150),
            const SizedBox(height: 16),
            const Text("Ваше имя"),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("Категория товара"),
            DropdownButton<CategoryLabel>(
              value: _selectedCategory,
              items: CategoryLabel.values.map((category) {
                return DropdownMenuItem<CategoryLabel>(
                  value: category,
                  child: Text(category.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text("Ваш номер телефона"),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("Описание объявления"),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}

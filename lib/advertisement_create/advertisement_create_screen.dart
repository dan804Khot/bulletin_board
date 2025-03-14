import 'dart:io';
import 'package:bulletin_board/advertisement_create/bloc/advertisement_create_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/widgets.dart';

class AdvertisementCreateScreen extends StatefulWidget {
  const AdvertisementCreateScreen({super.key});

  @override
  AdvertisementCreateScreenState createState() => AdvertisementCreateScreenState();
}

class AdvertisementCreateScreenState extends State<AdvertisementCreateScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isFree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abuto"),
        backgroundColor: Colors.green[300],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AdvertisementCreateBloc>().add(AdvertisementCreateSubmit(
                title: _titleController.text,
                description: _descriptionController.text,
                name: _nameController.text,
                phone: _numberController.text,
                price: _isFree ? 'Бесплатно' : _priceController.text,
              ));
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocListener<AdvertisementCreateBloc, AdvertisementCreateState>(
        listener: (context, state) {
          if (state is AdvertisementCreateCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Объявление создано!')),
            );
            Navigator.pop(context);
          } else if (state is AdvertisementCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(controller: _titleController, label: "Название объявления"),
              const SizedBox(height: 16),
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
              PickImageButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    if (mounted) {
                      context.read<AdvertisementCreateBloc>().add(AdvertisementCreateUploadImage(File(pickedFile.path)));
                    }
                  }
                },
              ),
              BlocBuilder<AdvertisementCreateBloc, AdvertisementCreateState>(
                builder: (context, state) {
                  if (state is AdvertisementCreateImagePicked) {
                    return ImagePreview(selectedImage: state.image);
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(controller: _nameController, label: "Ваше имя"),
              const SizedBox(height: 16),
              BlocBuilder<AdvertisementCreateBloc, AdvertisementCreateState>(
                builder: (context, state) {
                  if (state is AdvertisementCreateInitial) {
                    return CategoryDropdown(
                      selectedCategory: state.selectedCategory,
                      onChanged: (category) {
                        if (category != null) {
                          context.read<AdvertisementCreateBloc>().add(AdvertisementCreateUpdateCategory(category));
                        }
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _numberController,
                label: "Ваш номер телефона",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(controller: _descriptionController, label: "Описание объявления"),
            ],
          ),
        ),
      ),
    );
  }
}
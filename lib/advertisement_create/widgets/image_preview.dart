import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final File? selectedImage;

  const ImagePreview({this.selectedImage, super.key});

  @override
  Widget build(BuildContext context) {
    if (selectedImage == null) {
      return const SizedBox.shrink();
    }
    return Image.file(selectedImage!, height: 150);
  }
}

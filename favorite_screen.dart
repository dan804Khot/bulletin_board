import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: Center(
        child: Text(
  'Здесь будут ваши избранные объявления.',
  style: TextStyle(
    fontSize: 20.0, // Размер шрифта, похожий на headline6
    color: Colors.black, // Цвет текста
    fontWeight: FontWeight.bold, // Жирность текста
  ),
),
      ),
    );
  }
}
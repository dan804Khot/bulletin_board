import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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
    fontSize: 20.0, 
    color: Colors.black, 
    fontWeight: FontWeight.bold, 
  ),
),
      ),
    );
  }
}
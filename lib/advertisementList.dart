import 'package:flutter/material.dart';

class AdvertisementList extends StatelessWidget {
  const AdvertisementList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Список объявлений")),
      body: Center(child: Text("Тут будет список")),
    );
  }
}
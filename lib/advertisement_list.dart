import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'advertisement_create.dart';


class AdvertisementList extends StatefulWidget {
  const AdvertisementList({super.key});

  @override
  _AdvertisementListState createState() => _AdvertisementListState();
}

class _AdvertisementListState extends State<AdvertisementList> {
  int _selectedIndex = 0; // Индекс текущего выбранного экрана

  // Список экранов для переключения
  static const List<Widget> _widgetOptions = <Widget>[
    AdvertisementListScreen(), // Главный экран с объявлениями
    FavoriteScreen(),          // Экран избранного
    AdvertisementCreate(),     // Экран для создания объявления
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), // Отображаем выбранный экран
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped, // Обработчик нажатия на элементы
      ),
    );
  }
}

// Экран с объявлениями (для отображения на главной странице)
class AdvertisementListScreen extends StatelessWidget {
  const AdvertisementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Тут будет список объявлений"));
  }
}

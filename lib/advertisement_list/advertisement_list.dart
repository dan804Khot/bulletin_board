import 'package:flutter/material.dart';
import '../favorite_screen/favorite_screen.dart';
import '../advertisement_create.dart';


class AdvertisementList extends StatefulWidget {
  const AdvertisementList({super.key});

  @override
  AdvertisementListState createState() => AdvertisementListState();
}

class AdvertisementListState extends State<AdvertisementList> {
  int _selectedIndex = 0; 

  static const List<Widget> _widgetOptions = <Widget>[
    AdvertisementListScreen(), 
    FavoriteScreen(),    
    AdvertisementCreateScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), 
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped, 
      ),
    );
  }
}

class AdvertisementListScreen extends StatelessWidget {
  const AdvertisementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Тут будет список объявлений"));
  }
}

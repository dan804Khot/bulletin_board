import 'package:flutter/material.dart';
import 'advertisement_create.dart';
import 'advertisement_list.dart';

Future<void> main() async {
  final firebaseInit = FirebaseInitialization();
  firebaseInit.initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abuto',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AdvertisementList(), // Устанавливаем основной экран с BottomNavigationBar
    );
  }
}


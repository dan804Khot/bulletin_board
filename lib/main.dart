import 'package:bulletin_board/advertisement_create/bloc/advertisement_create_bloc.dart';
import 'package:bulletin_board/advertisement_create/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'advertisement_create.dart';
import 'advertisement_list/advertisement_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitialization.initFirebase();
  final adCreator = AdCreatorImpl(); 
  final categoryService = CategoryService(); 

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdvertisementCreateBloc(
            adCreator: adCreator, 
            categoryService: categoryService, 
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abuto',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AdvertisementList(), 
    );
  }
}
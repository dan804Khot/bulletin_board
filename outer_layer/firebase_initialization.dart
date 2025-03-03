import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseInitialization {
  void initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

  void createTable(adId,adData) async{
    await FirebaseFirestore.instance.collection('advertisements').doc(adId).set(adData);
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseInitialization {
  static Future<void> initFirebase() async {  
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  Future<void> createTable(String adId, Map<String, dynamic> adData) async {
    await FirebaseFirestore.instance.collection('advertisements').doc(adId).set(adData);
  }
}
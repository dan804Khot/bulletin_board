import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('categories').get();
      
      return querySnapshot.docs.map((doc) {
        return CategoryModel(
          id: doc['id'],
          label: doc['label'],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

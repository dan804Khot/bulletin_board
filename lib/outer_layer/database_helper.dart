import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  Future<Database> _initDB() async{
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path,'images.db');

    return await openDatabase(path,
    version: 1,
    onCreate: (db,version) async{
      await db.execute(''' CREATE TABLE images 
      (id INTEGER PRIMARY KEY AUTOINCREMENT, 
      ad_id TEXT UNIQUE,
      image_base64 TEXT)''');
    },);
  }

  Future<void> saveImage(String adId,String imageBase64) async{
    final db = await database;
    await db.insert('images', {'ad_id':adId,'image_base64':imageBase64},
    conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<String?> getImage(String adId) async{
    final db = await database;
    final result = await db.query('images',
      where: 'ad_id = ?',
      whereArgs: [adId],);

    if (result.isEmpty){
      return result.first['image_base64'] as String;
    }
    return null;
  }
}
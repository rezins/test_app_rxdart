import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_app_rxdart/db/CategoryModel.dart';
import 'package:test_app_rxdart/db/TransactionModel.dart';

class DatabaseServices{
  DatabaseServices._();
  static final DatabaseServices db = DatabaseServices._();

  static Database _database;

  Future<Database> initDB() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/transaction.db';
    var db = openDatabase(path, version: 1, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "transcation" (
        id	INTEGER PRIMARY KEY AUTOINCREMENT,
        transcation_type TEXT,
        transcation_date TEXT,
        category	TEXT,
        ammount	NUMERIC ,
        description	TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE "category" (
        id	INTEGER PRIMARY KEY AUTOINCREMENT,
        category_name TEXT
      )
    ''');
  }

  Future<Database> get database async{
    if(_database != null){
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<List<TranscationModel>> getTrc() async{
    Database db = await this.database;
    List<TranscationModel> filteredTrc = [];
    Future<List<Map<String, dynamic>>> list = db.rawQuery("SELECT * FROM transcation order by id desc");
    var data = await list;

    if(data.length != 0){
      for (var item in data){
        filteredTrc.add(TranscationModel.fromMap(item));
      }
      return filteredTrc;
    }

    return null;
  }

  Future<int> insertTrc(TranscationModel object) async{
    Database db = await this.database;
    int count = await db.insert('transcation', object.toMap());

    return count;
  }

  Future<int> UpdateTrc(TranscationModel object, int id) async{
    Database db = await this.database;
    int _ammount = object.ammount;
    int count = await db.rawUpdate( "UPDATE transcation SET transcation_type = '"+ object.transcation_type +"' , "
        " transcation_date = '"+ object.transcation_date +"', category = '"+object.category+"', ammount = $_ammount, description = '"+object.description+"' WHERE id = $id");

    return count;
  }

  Future<int> deleteTrc(int id) async{
    Database db = await this.database;
    int count = await db.rawDelete( "DELETE from transcation WHERE id = $id");

    return count;
  }

  Future<List<CategoryModel>> getCat() async{
    Database db = await this.database;
    List<CategoryModel> filteredCat = [];
    Future<List<Map<String, dynamic>>> list = db.rawQuery("SELECT * FROM category order by id asc");
    var data = await list;

    if(data.length != 0){
      for (var item in data){
        filteredCat.add(CategoryModel.fromMap(item));
      }
      return filteredCat;
    }

    return null;
  }

  Future<int> insertCat(CategoryModel object) async{
    Database db = await this.database;
    int count = await db.insert('category', object.toMap());

    return count;
  }

  Future<int> deleteCat(int id) async{
    Database db = await this.database;
    int count = await db.rawDelete( "delete FROM category WHERE id = $id");

    return count;
  }

}
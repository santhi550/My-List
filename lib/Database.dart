import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import './Lists.dart';
import './Items.dart';
import 'ItemNames.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ListDatabase.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Lists ("
          "list_id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "list_name TEXT"
          ");");
      await db.execute("CREATE TABLE Items ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "list_id INTEGER,"
          "item_name TEXT,"
          "quantity INTEGER,"
          "units TEXT"
          ");");
      await db.execute(
          "INSERT INTO Items ('list_id','item_name','quantity','units') values(?,?,?,?)",
          [1, "Sugar", 2, "Kg"]);
      await db.execute("CREATE TABLE ItemNames("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "item_name TEXT"
          ");");
      await db
          .execute("INSERT INTO ItemNames ('item_name') values(?)", ["Sugar"]);
      await db.execute("INSERT INTO Lists ('list_name') values(?)", ["List 1"]);
    });
  }

  Future<List<Lists>> getAllLists() async {
    final db = await database;
    List<Map> results =
        await db.query("Lists", columns: Lists.columns, orderBy: "list_id ASC");
    List<Lists> lists = new List();
    results.forEach((result) {
      Lists list = Lists.fromMap(result);
      lists.add(list);
    });
    return lists;
  }

  insert(String name) async {
    final db = await database;
    var result =
        await db.rawInsert("INSERT INTO Lists ('list_name') values(?)", [name]);
    return result;
  }

  delete(int id) async {
    final db = await database;
    db.delete("Lists", where: "list_id = ?", whereArgs: [id]);
    deleteitemsbyid(id);
  }

  Future<List<Items>> getItemsById(int id) async {
    final db = await database;
    List<Map> results = await db.query("Items",
        columns: Items.columns, where: "list_id = ?", whereArgs: [id]);
    List<Items> items = new List();
    results.forEach((result) {
      Items item = Items.fromMap(result);
      items.add(item);
    });
    return items;
  }

  insertitem(int list_id, String item_name, int quantity, String units) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT INTO Items ('list_id','item_name','quantity','units') values(?,?,?,?)",
        [list_id, item_name, quantity, units]);
    return result;
  }

  deleteitemsbyid(int list_id) async {
    final db = await database;
    db.delete("Items", where: "list_id = ?", whereArgs: [list_id]);
  }

  Future<List<ItemNames>> getItemnames() async {
    final db = await database;
    List<Map> results = await db.query("ItemNames",
        columns: ItemNames.columns, orderBy: "id ASC");
    List<ItemNames> itemnames = new List();
    results.forEach((result) {
      ItemNames list = ItemNames.fromMap(result);
      itemnames.add(list);
    });
    return itemnames;
  }

  Future<List<String>> getNames() async {
    final db = await database;
    List<Map> results = await db.query("ItemNames",
        columns: ItemNames.columns, orderBy: "id ASC");
    List<ItemNames> itemnames = new List();
    results.forEach((result) {
      ItemNames list = ItemNames.fromMap(result);
      itemnames.add(list);
    });
    List<String> names = [];
    itemnames.forEach((element) {
      names.add(element.item_name);
    });
    return names;
  }

  insertitemname(String name) async {
    final db = await database;
    var result = await db
        .rawInsert("INSERT INTO ItemNames ('item_name') values(?)", [name]);
    return result;
  }

  deleteitemname(int id) async {
    final db = await database;
    db.delete("ItemNames", where: "id = ?", whereArgs: [id]);
  }

  deleteitemfromlistbyId(int id, int list_id) async {
    final db = await database;
    db.delete("Items",
        where: "id = ? and list_id = ? ", whereArgs: [id, list_id]);
  }
}

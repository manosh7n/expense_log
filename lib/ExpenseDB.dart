import 'dart:io';

import 'package:cost_control/Expensive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDB {
  ExpenseDB() {}
  Database _db;

  Future<Database> get database async {
    if (_db == null) {
      _db = await initialize();
    }
    return _db;
  }

  initialize() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    var path = join(documentDir.path, "db.db");
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT)");
      },
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    var query = await db.rawQuery("SELECT * FROM Expenses ORDER BY date DESC");
    List<Expense> result = List<Expense>();
    query.forEach((f) => result.add(
        Expense(f["id"], DateTime.parse(f["date"]), f["name"], f["price"])));
    return result;
  }

  Future<void> addExpense(String name, double price, DateTime dateTime) async {
    Database db = await database;
    var date = dateTime.toString();
    await db.rawInsert(
        "INSERT INTO Expenses (name, date, price) VALUES (\"$name\",\"$date\", $price)");
  }

  Future<void> delExpense(int index) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expenses WHERE id = $index");
  }
}

import 'package:cost_control/ExpenseDB.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expensive.dart';
import 'package:intl/intl.dart';

class ExpensesModel extends Model {
  List<Expense> _items = [];
  DateFormat dateFormat = DateFormat().add_yMMMMd().add_Hm();
  DateFormat dateFormatYear = DateFormat().add_y();
  DateFormat dateFormatMonth = DateFormat().add_yMMMM();
  ExpenseDB _database;
  String state = "All";
  bool isUpdated = false;

  int get recordCount => _items.length;

  ExpensesModel() {
    _database = ExpenseDB();
    load("All");
  }

  String getTotalExp() {
    double total = 0.0;
    for (int i = 0; i < _items.length; i++) {
      total += _items[i].price;
    }
    return total.toString();
  }

  void load(String date) {
    Future<List<Expense>> future = _database.getAllExpenses(date);
    future.then((list) {
      _items = list;
      notifyListeners();
    });
  }

  String getKey(int index) {
    return _items[index].id.toString();
  }

  String getName(int index) {
    if (state == "year") {
      return dateFormatYear.format(_items[index].date).toString();
    } else if (state == "month") {
      return dateFormatMonth.format(_items[index].date).toString();
    }
    return _items[index].name.toString();
  }

  String getPrice(int index) {
    return _items[index].price.toString();
  }

  String getDate(int index) {
    return _items[index].date.toString();
  }

  String getTextDate(int index) {
    return dateFormat.format(_items[index].date);
  }

  void AddExpense(String name, double price, DateTime date) {
    Future<void> future = _database.addExpense(name, price, date);
    future.then((_) {
      load("All");
    });
  }

  void DelExpense(int index) {
    Future<void> future = _database.delExpense(index);
    future.then((_) {
      load("All");
    });
  }

  void EditExpense(String name, double price, DateTime date, int index) {
    Future<void> future = _database.editExpense(name, price, date, index);
    future.then((_) {
      load("All");
    });
  }
}

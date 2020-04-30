import 'package:cost_control/ExpenseDB.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expensive.dart';
import 'package:intl/intl.dart';

class ExpensesModel extends Model {
  List<Expense> _items = [];
  DateFormat dateFormat = DateFormat().add_yMMMMd().add_Hm();
  ExpenseDB _database;

  int get recordCount => _items.length;

  ExpensesModel() {
    _database = ExpenseDB();
    load();
  }

  String getTotalExp() {
    double total = 0.0;
    for (int i = 0; i < _items.length; i++) {
      total += _items[i].price;
    }
    return total.toString();
  }

  void load() {
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list) {
      _items = list;
      notifyListeners();
    });
  }

  String getKey(int index) {
    return _items[index].id.toString();
  }

  String getText(int index) {
    var temp = _items[index];
    return temp.name +
        " for " +
        temp.price.toString() +
        "\$" +
        "\n" +
        dateFormat.format(temp.date);
  }

  void RemoveAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void AddExpense(String name, double price, DateTime date) {
    Future<void> future = _database.addExpense(name, price, date);
    future.then((_) {
      load();
    });
  }
}

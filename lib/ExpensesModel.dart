import 'package:scoped_model/scoped_model.dart';
import 'Expensive.dart';
import 'package:intl/intl.dart';

class ExpensesModel extends Model {
  final List<Expense> _items = [
    Expense(1, DateTime.now(), "Something", 10000),
    Expense(2, DateTime.now(), "Something2", 1000),
    Expense(3, DateTime.now(), "Something3", 100),
  ];

  int _idgenerator = 3;

  DateFormat dateFormat = DateFormat().add_yMMMMd().add_Hm();

  int get recordCount => _items.length;

  String getTotalExp() {
    double total = 0.0;
    for (int i = 0; i < _items.length; i++) {
      total += _items[i].price;
    }
    return total.toString();
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

  void AddExpense(String name, double price) {
    _idgenerator += 1;
    var c = Expense(_idgenerator, DateTime.now(), name, price);
    _items.add(c);
    notifyListeners();
  }
}

import 'package:cost_control/AddExpense.dart';
import 'package:cost_control/EditExpense.dart';
import 'package:cost_control/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Expenses log'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                      title: Text("Total expenses: " + model.getTotalExp()));
                } else {
                  index -= 1;
                  return Dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (DismissDirection direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return await _showConfirmationDialog(
                                context, 'delete') ==
                            true;
                      }
                      return true;
                    },
                    background: Container(
                      color: Colors.blue,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            Text(
                              " Edit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              " Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        model.DelExpense(int.parse(model.getKey(index)));
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          content: Text("Deleted successfully"),
                        ));
                      } else if (direction == DismissDirection.startToEnd) {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditExpense(
                              model, int.parse(model.getKey(index)), index);
                        }));
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.blue,
                          content: Text("Update successfully"),
                        ));
                      }
                    },
                    child: Container(
                      child: ListTile(
                        title: Text(model.getName(index)),
                        subtitle: Text("Cost: " +
                            model.getPrice(index) +
                            "\$" +
                            "\n" +
                            model.getTextDate(index)),
                        isThreeLine: true,
                        leading: Icon(Icons.monetization_on),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditExpense(
                                model, int.parse(model.getKey(index)), index);
                          }));
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.blue,
                            content: Text("Update successfully"),
                          ));
                        },
                      ),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.recordCount + 1),
        ),
        floatingActionButton: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddExpense(model);
              }));
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showConfirmationDialog(BuildContext context, String action) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to $action this record?'),
        actions: <Widget>[
          FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(10.0),
            splashColor: Colors.greenAccent,
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true); // showDialog() returns true
            },
          ),
          FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(10.0),
            splashColor: Colors.greenAccent,
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, false); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}

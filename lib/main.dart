import 'package:cost_control/AddExpense.dart';
import 'package:cost_control/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cost_control/Stat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses log',
      theme: ThemeData(
        primaryColor: Colors.grey[850],
        accentColor: Colors.green[700],
        brightness: Brightness.dark,
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
            title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/logo.png',
              fit: BoxFit.fill,
              width: 120,
              height: 130,
            ),
          ],
        )),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Show expenses by: ",
                          style: TextStyle(fontSize: 18),
                        ),
                        FlatButton(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(10.0),
                          splashColor: Colors.greenAccent,
                          child: const Text(
                            'Year',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              model.state = "year";
                              model.load(model.state);
                              return Stat(
                                title: "Expenses",
                                model: model,
                              );
                            }));
                            model.state = "All";
                            model.load(model.state);
                          },
                        ),
                        FlatButton(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(10.0),
                          splashColor: Colors.greenAccent,
                          child: const Text(
                            'Month',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              model.state = "month";
                              model.load(model.state);
                              return Stat(
                                title: "Expenses",
                                model: model,
                              );
                            }));
                            model.state = "All";
                            model.load(model.state);
                          },
                        ),
                      ],
                    ),
                  );
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
                      color: Colors.grey[700],
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
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          content: Text(
                            "Deleted successfully",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      } else if (direction == DismissDirection.startToEnd) {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddExpense(
                              model, int.parse(model.getKey(index)), index, true);
                        }));
                        if (model.isUpdated) {
                          model.isUpdated = false;
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.grey[300],
                            content: Text("Successfully updated"),
                          ));
                        }
                      }
                    },
                    child: Container(
                      child: ListTile(
                        title: Text(
                          model.getName(index),
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          "Cost: " +
                              model.getPrice(index) +
                              "\$" +
                              "\n" +
                              model.getTextDate(index),
                          style: TextStyle(fontSize: 15),
                        ),
                        isThreeLine: true,
                        leading:
                            Icon(Icons.monetization_on, color: Colors.grey),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AddExpense(
                                model, int.parse(model.getKey(index)), index, true);
                          }));
                          if (model.isUpdated) {
                            model.isUpdated = false;
                            Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.grey[300],
                              content: Text("Successfully updated"),
                            ));
                          }
                        },
                      ),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(
                    height: 5,
                  ),
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
        title: Text('Do you want to $action this record?',
            textAlign: TextAlign.center),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ButtonTheme(
              minWidth: 100,
              child: FlatButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                splashColor: Colors.greenAccent,
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, true); // showDialog() returns true
                },
              ),
            ),
            ButtonTheme(
              minWidth: 100,
              child: FlatButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                splashColor: Colors.greenAccent,
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, false); // showDialog() returns false
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

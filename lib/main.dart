import 'package:cost_control/AddExpense.dart';
import 'package:cost_control/ExpensesModel.dart';
import 'package:cost_control/Expensive.dart';
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
      home: MyHomePage(title: 'Flutter Home Page'),
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
                    key: Key(model.getKey(index)),
                    onDismissed: (direction) {
                      model.RemoveAt(index);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("deleted record $index"),
                      ));
                    },
                    child: ListTile(
                      title: Text(model.getText(index)),
                      leading: Icon(Icons.monetization_on),
                      trailing: Icon(Icons.delete),
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

import 'package:cost_control/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Stat extends StatelessWidget {
  Stat({Key key, this.title, this.model}) : super(key: key);

  final String title;
  final ExpensesModel model;
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title + " for each " + model.state, textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(

                          title: Text("Total expenses: " +
                              model.getTotalExp() +
                              " \$", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
                              );
                } else {
                  index -= 1;
                  return Container(
                    child: ListTile(
                      title: Text(model.getName(index), style: TextStyle(fontSize: 20),),
                      leading: Icon(Icons.attach_money,),
                      trailing: Text(model.getPrice(index) + "\$", style: TextStyle(fontSize: 18),),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.recordCount + 1),
        ),
      ),
    );
  }
}

import 'package:cost_control/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _AddExpenseState extends State<AddExpense> {
  double _price;
  String _name;
  ExpensesModel _model;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  _AddExpenseState(this._model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add expense"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  autovalidate: true,
                  initialValue: "0",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (double.tryParse(value) != null) {
                      return null;
                    } else {
                      return "Wrong value";
                    }
                  },
                  onSaved: (value) {
                    _price = double.parse(value);
                  },
                ),
                TextFormField(
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();
                      _model.AddExpense(_name, _price);

                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add"),
                )
              ],
            ),
          ),
        ));
  }
}

class AddExpense extends StatefulWidget {
  final ExpensesModel _model;
  AddExpense(this._model);
  @override
  State<StatefulWidget> createState() => _AddExpenseState(_model);
}

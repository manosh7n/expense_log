import 'package:cost_control/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class _AddExpenseState extends State<AddExpense> {
  double _price;
  String _name;
  DateTime _date;
  final format = DateFormat("yyyy-MM-dd HH:mm");
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
                  decoration: const InputDecoration(
                    hintText: 'Cost',
                  ),
                  
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
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                DateTimeField(
                  decoration: const InputDecoration(
                    hintText: 'Date',
                  ),
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  onSaved: (value) {
                    _date = DateTime.parse(value.toString());
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();
                      _model.AddExpense(_name, _price, _date);

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

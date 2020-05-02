import 'package:cost_control/ExpensesModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _EditExpanseState extends State<EditExpense> {
  ExpensesModel _model;
  int _index;
  int _indexInit;
  double _price;
  String _name;
  _EditExpanseState(this._model, this._index, this._indexInit);
  DateTime _date;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Edit expense"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  style: new TextStyle(fontSize: 20),
                  initialValue: _model.getPrice(_indexInit),
                  decoration: InputDecoration(labelText: "Cost"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (double.tryParse(value) != null && value.length < 12) {
                      return null;
                    } else {
                      return "Wrong value";
                    }
                  },
                  onSaved: (value) {
                    _price = double.parse(value);
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: new TextStyle(fontSize: 20),
                  initialValue: _model.getName(_indexInit),
                  decoration: InputDecoration(labelText: "Purchase"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Wrong value";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                SizedBox(height: 10),
                DateTimeField(
                  style: new TextStyle(fontSize: 20),
                  initialValue: DateTime.parse(_model.getDate(_indexInit)),
                  decoration: InputDecoration(labelText: "Date"),
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
                SizedBox(height: 20),
                ButtonTheme(
                  minWidth: 160,
                  height: 50,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    splashColor: Colors.greenAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        _formkey.currentState.save();
                        _model.EditExpense(_name, _price, _date, _index);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class EditExpense extends StatefulWidget {
  final ExpensesModel _model;
  final int _index;
  final int _indexInit;
  EditExpense(this._model, this._index, this._indexInit);
  @override
  State<StatefulWidget> createState() =>
      _EditExpanseState(_model, _index, _indexInit);
}

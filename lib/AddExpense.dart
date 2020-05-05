import 'package:cost_control/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class _AddExpenseState extends State<AddExpense> {
  ExpensesModel _model;
  double _price;
  String _name;
  DateTime _date;
  int _index, _indexInit;
  bool _editMode;

  final format = DateFormat("yyyy-MM-dd HH:mm");
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  _AddExpenseState(this._model, this._index, this._indexInit, this._editMode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Add expense"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  style: new TextStyle(fontSize: 20),
                  initialValue: _editMode ? _model.getPrice(_indexInit) : null,
                  decoration: InputDecoration(
                    labelText: 'Cost',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    int count = value.length - value.indexOf('.');

                    if (double.tryParse(value) != null &&
                        value.length < 12 &&
                        (count < 4 || value.indexOf('.') == -1)) {
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
                  initialValue: _editMode ? _model.getName(_indexInit) : null,
                  decoration: InputDecoration(
                    labelText: 'Purchase',
                  ),
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
                  initialValue: _editMode
                      ? DateTime.parse(_model.getDate(_indexInit))
                      : DateTime.now(),
                  decoration: InputDecoration(
                    labelText: 'Date',
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
                SizedBox(height: 20),
                ButtonTheme(
                  minWidth: 160,
                  height: 50,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    splashColor: Colors.greenAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        _formkey.currentState.save();
                        if (_editMode) {
                          _model.EditExpense(_name, _price, _date, _index);
                          _model.isUpdated = true;
                        } else {
                          _model.AddExpense(_name, _price, _date);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: _editMode ? Text("Save") : Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class AddExpense extends StatefulWidget {
  final ExpensesModel _model;
  int _index;
  int _indexInit;
  bool _editMode;

  AddExpense(this._model, [this._index = 0, this._indexInit = 0, this._editMode = false]);
  @override
  State<StatefulWidget> createState() =>
      _AddExpenseState(_model, _index, _indexInit, _editMode);
}

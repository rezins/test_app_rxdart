import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app_rxdart/db/TransactionModel.dart';
import 'package:test_app_rxdart/screen/Category/Widget/Category.dart';
import 'package:intl/intl.dart';
import 'package:test_app_rxdart/screen/Transcation/Controller/ControllerTransaction.dart';

// ignore: must_be_immutable
class Transaction extends StatelessWidget {

  Transaction(String name, TranscationModel trc){
    controllerTrc.initial(name, trc);
    _trc = trc;
    _trcType = name;
    if(_trc != null){
      _dateController.text = _trc.transcation_date;
      _categoryController.text = _trc.category;
      _ammountController.text =  _trc.ammount.toString();
      _desciprtionController.text = _trc.description;
    }
  }

  TranscationModel _trc;
  String _trcType;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _categoryController = new TextEditingController();
  TextEditingController _ammountController = new TextEditingController();
  TextEditingController _desciprtionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Transcation',
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: StreamBuilder<bool>(
                      stream: controllerTrc.expenseType,
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return GestureDetector(
                            onTap: () {
                              controllerTrc.changeToExpense();
                            },
                            child: Container(
                              color: snapshot.data ? Colors.blue : Colors.white,
                              child: Center(
                                child: Text('EXPENSE',
                                  style: TextStyle(
                                    color: snapshot.data ? Colors.white : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }else{
                          return Container(
                            child: Container(
                              color: Colors.blue,
                              child: Center(
                                child: Text('EXPENSE',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: StreamBuilder<bool>(
                      stream: controllerTrc.incomeType,
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return GestureDetector(
                            onTap: () {
                              controllerTrc.changeToIncome();
                            },
                            child: Container(
                              color: snapshot.data ? Colors.blue : Colors.white,
                              child: Center(
                                child: Text(
                                  'INCOME',
                                  style: TextStyle(
                                    color: snapshot.data ? Colors.white : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }else{
                          return Container(
                            child: Container(
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  'INCOME',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                      },
                    ),
                  )
                ],
              )
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DateTime date = DateTime(1900);
                        date = await showDatePicker(
                            context: context,
                            initialDate:DateTime.now(),
                            firstDate:DateTime(1900),
                            lastDate: DateTime(2100));
                        if(date!=null){
                          String _tmpDate = DateFormat('dd/MM/yyyy').format(date);
                          _dateController.text = _tmpDate;
                        }
                      },
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Transaction Date',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Transaction Date must filled';
                        }
                        return null;
                      },
                      onSaved: controllerTrc.trcDate,
                    ),
                    TextFormField(
                      onTap: ()async{
                        var categorySelected = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Category(),));
                        _categoryController.text = categorySelected;
                      },
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Select Category cannot be blank';
                        }
                        return null;
                      },
                      onSaved: controllerTrc.trcCat,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _ammountController,
                      decoration: InputDecoration(
                        labelText: 'Ammount',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Ammount cannot be blank';
                        }
                        return null;
                      },
                      onSaved: controllerTrc.trcAmmoun,
                    )
                    ,
                    TextFormField(
                      controller: _desciprtionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Description cannot be blank';
                        }
                        return null;
                      },
                      onSaved: controllerTrc.trcDesc,
                    ),
                    _trcType == 'Add' ? Container(
                      height: 75,
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        child: FlatButton(
                            onPressed: (){
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                controllerTrc.addTransaction(context);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                ),
                              ),
                            )
                        ),
                      ),
                    ) :
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 75,
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  child: FlatButton(
                                      onPressed: (){
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          controllerTrc.updateTransaction(context, _trc.id);
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      color: Colors.blue,
                                      child: Center(
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              )
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 75,
                              padding: EdgeInsets.only(top: 20),
                              child: Container(
                                child: FlatButton(
                                    onPressed: (){

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Warning',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: Text(
                                                'Are you sure want to delete this item?'
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text('Yes'),
                                                onPressed: () {
                                                  controllerTrc.deleteTransacttion(context, _trc.id);
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: Colors.red,
                                    child: Center(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

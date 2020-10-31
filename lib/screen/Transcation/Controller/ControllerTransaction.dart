import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app_rxdart/db/DatabaseServices.dart';
import 'package:test_app_rxdart/db/TransactionModel.dart';

class ControllerTransaction{

  bool _expense = true, _income = false;

  final _expenseType = PublishSubject<bool>();
  final _incomeType = PublishSubject<bool>();

  // ignore: close_sinks
  final _transaction = PublishSubject<TranscationModel>();

  final _trcDate = BehaviorSubject<String>();
  final _trcCat = BehaviorSubject<String>();
  final _trcAmmoun = BehaviorSubject<String>();
  final _trcDesc = BehaviorSubject<String>();

  Function(String) get trcDate => _trcDate.sink.add;
  Function(String) get trcCat => _trcCat.sink.add;
  Function(String) get trcAmmoun => _trcAmmoun.sink.add;
  Function(String) get trcDesc => _trcDesc.sink.add;

  initial(String name, TranscationModel trc)async{
    Timer(Duration(milliseconds: 100),() async{
      if(name == 'Add'){
        _expense = true;
        _income = false;
        await _expenseType.sink.add(_expense);
        await _incomeType.sink.add(_income);
      }else{
        if(trc.transcation_type == 'Expense'){
          _expense = true;
          _income = false;
        }else{
          _expense = false;
          _income = true;
        }
        await _expenseType.sink.add(_expense);
        await _incomeType.sink.add(_income);
      }
    });
  }

  Stream<TranscationModel> get transaction => _transaction;

  Stream<bool> get expenseType {
    return _expenseType.stream;
  }

  Stream<bool> get incomeType {
    return _incomeType.stream;
  }



  changeToIncome(){
    _expense = false;
    _income = true;
    _expenseType.sink.add(_expense);
    _incomeType.sink.add(_income);
  }

  changeToExpense(){
    _expense = true;
    _income = false;
    _expenseType.sink.add(_expense);
    _incomeType.sink.add(_income);
  }

  addTransaction(BuildContext context) async{
    TranscationModel trc = new TranscationModel(
      transcation_date: _trcDate.value,
      category: _trcCat.value,
      ammount: int.parse(_trcAmmoun.value),
      description: _trcDesc.value,
      transcation_type: _expense ? 'Expense' : 'Income'
    );
    await DatabaseServices.db.insertTrc(trc).then((value) {
      Navigator.of(context).pop();
    });
  }

  updateTransaction(BuildContext context, int id) async{
    TranscationModel trc = new TranscationModel(
        transcation_date: _trcDate.value,
        category: _trcCat.value,
        ammount: int.parse(_trcAmmoun.value),
        description: _trcDesc.value,
        transcation_type: _expense ? 'Expense' : 'Income'
    );
    await DatabaseServices.db.UpdateTrc(trc, id).then((value) {
      Navigator.of(context).pop();
    });
  }

  deleteTransacttion(BuildContext context, int id)async{
    await DatabaseServices.db.deleteTrc(id).then((value) {
      Navigator.of(context).pop();
    });
  }

  void dispose() {
    _expenseType.close();
    _incomeType.close();
    _trcDate.close();
    _trcCat.close();
    _trcAmmoun.close();
    _trcDesc.close();
  }

}

final controllerTrc = ControllerTransaction();
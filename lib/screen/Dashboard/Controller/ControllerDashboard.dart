import 'package:rxdart/rxdart.dart';
import 'package:test_app_rxdart/db/DatabaseServices.dart';
import 'package:test_app_rxdart/db/TransactionModel.dart';

class ControllerDashboard{

  // ignore: close_sinks
  final _listTrc = PublishSubject<List<TranscationModel>>();
  int _balanced = 0;

  // BehaviorSubject<int> _balancedSubject;
  // ignore: close_sinks
  final _balancedSubject = PublishSubject<int>();
  Stream<List<TranscationModel>> get listTrc => _listTrc.stream;

  initData()async{
    _balanced = 0;
    List<TranscationModel> trc = await DatabaseServices.db.getTrc();
    if(trc != null){
      trc.forEach((item) {
        if(item.transcation_type == 'Expense'){
          _balanced -= item.ammount;
        }else{
          _balanced += item.ammount;
        }
      });
    }else{
      trc = List<TranscationModel>();
    }
    _balancedSubject.sink.add(_balanced);
    _listTrc.sink.add(trc);

  }

  Stream<int> get balancedSubject => _balancedSubject.stream;

}

final controllerDash = ControllerDashboard();
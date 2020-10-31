import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app_rxdart/db/CategoryModel.dart';
import 'package:test_app_rxdart/db/DatabaseServices.dart';

class ControllerCategory {

  // ignore: close_sinks
  final _listCategory = PublishSubject<List<CategoryModel>>();
  // ignore: close_sinks
  final _namaCategory = BehaviorSubject<String>();

  Stream<List<CategoryModel>> get getListCategory => _listCategory.stream;
  Function(String) get namaCategory => _namaCategory.sink.add;

  fetchCategory() async{
    List<CategoryModel> listCategory = await DatabaseServices.db.getCat();
    _listCategory.sink.add(listCategory);
  }

  addCategory(BuildContext context) async{
    CategoryModel cat = new CategoryModel(
        category_name: _namaCategory.value
    );
    await DatabaseServices.db.insertCat(cat).then((value) {
      Navigator.of(context).pop();

    });
  }

  deleteCategory(BuildContext context, int idx)async{
    await DatabaseServices.db.deleteCat(idx).then((value) {
      Navigator.of(context).pop();

    });
  }

  void dispose() {
    _listCategory.close();
    _namaCategory.close();
  }


}


final controllerCategory = ControllerCategory();
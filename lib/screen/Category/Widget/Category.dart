import 'package:flutter/material.dart';
import 'package:test_app_rxdart/screen/Category/Controller/ControllerCategory.dart';

class Category extends StatelessWidget {

  Category(){
    controllerCategory.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) {
              final _formKey = GlobalKey<FormState>();
              return AlertDialog(
                title: Text('Create Category',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20
                  ),
                ),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Category Name"),
                    onSaved: controllerCategory.namaCategory,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Category Name cannot be blank';
                      }
                      return null;
                    },
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text('Save'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        controllerCategory.addCategory(context);
                        controllerCategory.fetchCategory();
                      }
                    },
                  )
                ],
              );
            },
          );
        },

        child: Center(
          child: Icon(Icons.add, size: 30,),
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: controllerCategory.getListCategory,
          // ignore: missing_return
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.pop(context, snapshot.data[index].category_name);
                    },
                    child: Container(
                      height: 70,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              spreadRadius: 2,
                              blurRadius: 2
                          )
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Container(
                                child: Text(
                                  snapshot.data[index].category_name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
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
                                              controllerCategory.deleteCategory(context, snapshot.data[index].id);
                                              controllerCategory.fetchCategory();
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Center(
                                  child: Icon(Icons.delete, color: Colors.grey,),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}

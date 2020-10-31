import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app_rxdart/screen/Dashboard/Controller/ControllerDashboard.dart';
import 'package:test_app_rxdart/screen/Transcation/Widget/Transaction.dart';

class Dashboard extends StatelessWidget {

  Dashboard(){
    controllerDash.initData();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expanse Manager'
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Transaction('Add', null),));
          controllerDash.initData();
        },
        child: Center(
          child: Icon(Icons.add, size: 30,),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
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
                  child: Center(
                    child: StreamBuilder(
                      stream: controllerDash.balancedSubject,
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return Text(
                            'Balanced: ' + NumberFormat.currency(locale: 'id', name: 'IDR'+' ',).format(
                                snapshot.data),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20
                            ),
                          );
                        }else{
                          return Text(
                            'Balanced: ' + NumberFormat.currency(locale: 'id', name: 'IDR'+' ',).format(
                                0),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: controllerDash.listTrc,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Scrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Transaction('Update', snapshot.data[index]),));
                                controllerDash.initData();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 100,
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
                                      flex: 1,
                                      child: Container(
                                        child: snapshot.data[index].transcation_type == "Expense" ? Icon(Icons.arrow_upward, color: Colors.green,size: 40,) : Icon(Icons.arrow_downward, color: Colors.red,size: 40,),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              NumberFormat.currency(locale: 'id', name: 'IDR'+' ',).format(
                                                  snapshot.data[index].ammount),
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index].category,
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index].description,
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          snapshot.data[index].transcation_date,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}

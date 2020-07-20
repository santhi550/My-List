import 'package:List/main.dart';
import 'package:flutter/material.dart';
import 'Database.dart';
import 'Items.dart';
import 'additem.dart';

class ListViewApp extends StatefulWidget {
  final id;
  ListViewApp({@required this.id});

  @override
  _ListViewAppState createState() => _ListViewAppState();
}

class _ListViewAppState extends State<ListViewApp> {
  List<Items> itemlists = [];

  void _updateItemslist(id) async {
    List<Items> updateitemlists = await DBProvider.db.getItemsById(id);
    if (mounted) {
      setState(() {
        itemlists = updateitemlists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateItemslist(widget.id);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(106, 90, 205, 1),
        title: const Text("My List"),
      ),
      body: itemlists.length > 0
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ITEM')),
                      DataColumn(label: Text('ACTION')),
                    ],
                    rows: itemlists
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    element.item_name +
                                        ' ' +
                                        element.quantity.toString() +
                                        ' ' +
                                        element.units,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromRGBO(106, 90, 205, 1)),
                                  )),
                                  DataCell(
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                    onTap: () {
                                      DBProvider.db.deleteitemfromlistbyId(
                                          element.id, widget.id);
                                      _updateItemslist(widget.id);
                                    },
                                  ),
                                ],
                              )),
                        )
                        .toList(),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                'No items added',
                style: TextStyle(fontSize: 20),
              ),
            ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: FittedBox(
                  child: Image.asset('graphics/icon.jpg'),
                  fit: BoxFit.fill,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Ink(
                color: Color.fromRGBO(106, 90, 205, 1),
                child: Card(
                  color: Color.fromRGBO(106, 90, 205, 1),
                  child: ListTile(
                    leading: const Icon(Icons.add_circle, color: Colors.white),
                    title: Text(
                      'Add Item to the List',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new MaterialApp(
                                      debugShowCheckedModeBanner: false,
                                      home: new AddItem(list_id: widget.id))));
                    },
                  ),
                ),
              ),
              Ink(
                color: Color.fromRGBO(106, 90, 205, 1),
                child: Card(
                  color: Color.fromRGBO(106, 90, 205, 1),
                  child: ListTile(
                    leading: const Icon(Icons.remove_shopping_cart,
                        color: Colors.white),
                    title: Text(
                      'Delete List',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      DBProvider.db.delete(widget.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new MaterialApp(
                                      debugShowCheckedModeBanner: false,
                                      home: new MyApp())));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

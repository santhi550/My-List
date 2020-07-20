import 'package:List/Database.dart';
import 'package:List/ItemNames.dart';
import 'package:flutter/material.dart';
import 'ItemNames.dart';

class ItemNamesView extends StatefulWidget {
  @override
  _ItemNamesViewState createState() => _ItemNamesViewState();
}

class _ItemNamesViewState extends State<ItemNamesView> {
  List<ItemNames> itemnames = [];
  final _formKey = GlobalKey<FormState>();
  void _updateitemnames() async {
    List<ItemNames> updateitemnames = await DBProvider.db.getItemnames();
    if (mounted) {
      setState(() {
        itemnames = updateitemnames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateitemnames();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(106, 90, 205, 1),
        title: const Text("My List"),
      ),
      body: itemnames.length > 0
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ITEM NAME')),
                      DataColumn(label: Text('ACTION')),
                    ],
                    rows: itemnames
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    element.item_name,
                                    style: TextStyle(
                                        fontSize: 15,
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
                                      DBProvider.db.deleteitemname(element.id);
                                      _updateitemnames();
                                    },
                                  ),
                                ],
                              )),
                        )
                        .toList(),
                  ),
                ),
              ))
          : Center(
              child: Text(
                'No itemnames added',
                style: TextStyle(fontSize: 20),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final _listnameController = TextEditingController();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter item name';
                                  }
                                  return null;
                                },
                                controller: _listnameController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.translate),
                                  hintText: 'Enter Item Name',
                                  labelText: 'Item Name',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text("Add Item Name"),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    DBProvider.db.insertitemname(
                                        _listnameController.text);
                                    Navigator.of(context).pop();
                                    _updateitemnames();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(106, 90, 205, 1),
      ),
    );
  }
}

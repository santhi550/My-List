import 'package:flutter/material.dart';
import 'Database.dart';
import 'listview.dart';
import 'ItemNamesView.dart';

class AddItem extends StatefulWidget {
  final list_id;
  AddItem({@required this.list_id});
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String itemname;
  String finalitemname;
  String units = 'Kg';
  List<String> names = [];
  int quantity = 0;
  void _changeitem(newValue) {
    finalitemname = newValue;
    setState(() {
      itemname = newValue;
    });
  }

  Future _getitemnames() async {
    names = await DBProvider.db.getNames();
    return names;
  }

  @override
  void initState() {
    super.initState();

    _getitemnames().then((names) {
      setState(() {
        this.names = names;
        if (names.length > 0) {
          itemname = names[0];
          finalitemname = itemname;
        }
      });
    });
  }

  void _changeunits(newValue) {
    setState(() {
      units = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_getitemnames() != null) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("My List"),
            backgroundColor: Color.fromRGBO(106, 90, 205, 1),
          ),
          body: names.length > 0
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(106, 90, 205, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              10.0) //                 <--- border radius here
                          ),
                    ),
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        DropdownButton<String>(
                          isExpanded: true,
                          value: units,
                          // icon: Icon(Icons.arrow_downward),
                          itemHeight: 50,
                          iconSize: 30,
                          iconEnabledColor: Color.fromRGBO(106, 90, 205, 1),
                          elevation: 16,
                          style:
                              TextStyle(color: Color.fromRGBO(106, 90, 205, 1)),
                          underline: Container(
                            height: 2,
                            color: Color.fromRGBO(106, 90, 205, 1),
                          ),
                          onChanged: (String newValue) {
                            _changeunits(newValue);
                          },
                          items: <String>[
                            'Kg',
                            'grams',
                            'Litre',
                            'ml',
                            'Packet',
                            'Box',
                            'Pieces'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: itemname,
                          itemHeight: 70,
                          iconEnabledColor: Color.fromRGBO(106, 90, 205, 1),
                          iconSize: 30,
                          elevation: 16,
                          style:
                              TextStyle(color: Color.fromRGBO(106, 90, 205, 1)),
                          underline: Container(
                            height: 2,
                            color: Color.fromRGBO(106, 90, 205, 1),
                          ),
                          onChanged: (String newValue) {
                            _changeitem(newValue);
                          },
                          items: names
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Container(
                          height: 40,
                        ),
                        Container(
                          height: 40,
                        ),
                        new TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            fillColor: Color.fromRGBO(106, 90, 205, 1),
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Color.fromRGBO(106, 90, 205, 1),
                            ),
                            hintText: 'Enter Quantity',
                            labelText: 'Quantity',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(106, 90, 205, 1)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(106, 90, 205, 1)),
                            ),
                          ),
                          onChanged: (text) {
                            quantity = int.parse(text);
                          },
                        ),
                        Container(
                          height: 20,
                        ),
                        RaisedButton(
                          onPressed: () {
                            int list_id = widget.list_id;
                            DBProvider.db.insertitem(
                                list_id, finalitemname, quantity, units);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new MaterialApp(
                                            debugShowCheckedModeBanner: false,
                                            home: new ListViewApp(
                                                id: widget.list_id))));
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(5.0),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color.fromRGBO(106, 90, 205, 1),
                                  Color.fromRGBO(106, 90, 205, 1),
                                  Color.fromRGBO(106, 90, 205, 1),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('Add Item',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        children: <Widget>[
                          Text('You must add atleast one itemname'),
                          RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new MaterialApp(
                                                debugShowCheckedModeBanner:
                                                    false,
                                                home: new ItemNamesView())));
                              },
                              child: Text('Go to ItemNames')),
                        ],
                      )),
                ));
    } else {
      _getitemnames();
      return Text('Loading');
    }
  }
}

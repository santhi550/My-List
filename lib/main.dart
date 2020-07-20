import 'package:List/Database.dart';
import 'package:List/ItemNamesView.dart';
import 'package:flutter/material.dart';
import 'Lists.dart';
import 'listview.dart';
import 'ItemNamesView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(debugShowCheckedModeBanner: false, home: new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  List<Lists> lists = [];
  void _updatelist() async {
    List<Lists> updatelists = await DBProvider.db.getAllLists();

    setState(() {
      lists = updatelists;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updatelist();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
        backgroundColor: Color.fromRGBO(106, 90, 205, 1),
      ),
      body: lists.length > 0
          ? ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: lists.length,
              itemBuilder: (BuildContext context, int index) {
                // print(lists[index].list_id);
                return Container(
                  margin: EdgeInsets.all(5),
                  color: Colors.white,
                  child: Card(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      side: BorderSide(
                        color: Color.fromRGBO(106, 90, 205, 1),
                        width: 0.5,
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_cart,
                        color: Color.fromRGBO(106, 90, 205, 1),
                      ),
                      title: Text(
                        lists[index].list_name,
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(106, 90, 205, 1)),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new MaterialApp(
                                        debugShowCheckedModeBanner: false,
                                        home: new ListViewApp(
                                            id: lists[index].list_id))));
                      },
                    ),
                  ),
                  height: 60,
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Color.fromRGBO(106, 90, 205, 1),
              ),
            )
          : Center(
              child: Text(
                'No lists added',
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(106, 90, 205, 1)),
              ),
            ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.zero,
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
                    leading: const Icon(Icons.translate, color: Colors.white),
                    title: Text(
                      'Item Names',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new MaterialApp(
                                      debugShowCheckedModeBanner: false,
                                      home: new ItemNamesView())));
                    },
                  ),
                ),
              ),
              Ink(
                color: Color.fromRGBO(106, 90, 205, 1),
                child: Card(
                  color: Color.fromRGBO(106, 90, 205, 1),
                  child: ListTile(
                    leading: const Icon(Icons.add_shopping_cart,
                        color: Colors.white),
                    title: Text(
                      'Add List',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
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
                                                return 'Please enter some name';
                                              }
                                              return null;
                                            },
                                            controller: _listnameController,
                                            decoration: const InputDecoration(
                                              icon: Icon(Icons.list),
                                              hintText: 'Enter List Name',
                                              labelText: 'List Name',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            child: Text("Add list"),
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                DBProvider.db.insert(
                                                    _listnameController.text);

                                                Navigator.of(context).pop();
                                                _updatelist();
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

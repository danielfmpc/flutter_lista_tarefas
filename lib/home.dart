import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _textEditingController = TextEditingController();
  List _toDoList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _readData().then((data) {
      setState(() {
        _toDoList = jsonDecode(data);
      });
    });
  }

  void _addToDoList(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _textEditingController.text;
      _textEditingController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(
                        color: Colors.blueAccent
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text(
                    "Criar"                      
                  ),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  onPressed: _addToDoList,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _toDoList.length,
              itemBuilder: (context, index){
                return CheckboxListTile(
                  title: Text(_toDoList[index]["title"]),
                  value: _toDoList[index]["ok"],
                  onChanged: (value){
                    setState(() {
                      _toDoList[index]["ok"] = value;
                      _saveData();
                    });
                  },
                  secondary: CircleAvatar(
                    child: Icon(
                      _toDoList[index]["ok"] ? Icons.check : Icons.error
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationSupportDirectory();
    return File("${directory.path}/data.json");
  }
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return e.toString();
    }
  }
}


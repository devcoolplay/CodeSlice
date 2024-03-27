import "package:flutter/material.dart";

import "../../../services/auth.dart";
import "../../../services/database.dart";
import "../../../shared/app_data.dart";
import "../../../shared/constants.dart";

class EditFolder extends StatefulWidget {
  EditFolder({required this.currentName});

  String currentName;

  @override
  State<EditFolder> createState() => _EditFolderState();
}

class _EditFolderState extends State<EditFolder> {
  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);

  String _name = "";
  String _color = "blue";
  final String _path = AppData.mySnippetsPath;
  List<String> _folders = [];

  void _loadFolders() async {
    _folders = await _db.getFolderNames(_auth.userId!, _path);
  }

  void _saveFolder() async {
    // TODO: toChangeFolers somehow aren't changing their path
    final toUpdateSnippets = await _db.getToChangeSnippetIDs(_path != "/" ? "$_path/${widget.currentName}" : _path + widget.currentName);
    final getToChangeFolders = await _db.getToChangeFolders(_path != "/" ? "$_path/${widget.currentName}" : _path + widget.currentName);
    for (int i = 0; i < toUpdateSnippets.length; i++) {
      _db.updateSnippetPath(toUpdateSnippets[i], _path != "/" ? "$_path/$_name" : _path + _name);
    }
    for (int i = 0; i < getToChangeFolders.length; i++) {
      _db.updateFolderPath(_path != "/" ? "$_path/${widget.currentName}" : _path + widget.currentName, _path != "/" ? "$_path/$_name" : _path + _name, getToChangeFolders[i]["name"]);
    }
    _db.updateFolderName(_path, widget.currentName, _name);
    /*try {
      await _db.addFolder(_name, _color, _path);
    } catch (e) {
      print("Failed to save folder in database!");
      print(e);
    }*/
  }

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Folder"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: widget.currentName,
                  decoration: textInputDecoration.copyWith(hintText: "Name"),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter a name";
                    }
                    if (_folders.contains(_name)) {
                      return "A folder with this name already exists";
                    }
                    return null;
                  },
                  onChanged: (val) => _name = val,
                )
              ]
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveFolder();
                Navigator.of(context).pop();
              }
            },
            child: const Text("Save")
        ),
      ),
    );
  }
}

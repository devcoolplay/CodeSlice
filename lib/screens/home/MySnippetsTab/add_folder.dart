import 'package:flutter/material.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../shared/constants.dart';

class AddFolder extends StatefulWidget {
  const AddFolder({super.key});

  @override
  State<AddFolder> createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> {
  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);

  String _name = "";
  List<String> _folders = [];

  void _loadFolders() async {
    _folders = await _db.getFolders(_auth.userId!);
  }

  void _saveFolder() async {
    try {
      await _db.addFolder(_name);
    } catch (e) {
      print("Failed to save folder in database!");
      print(e);
    }
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
        title: const Text("Add Folder"),
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
      bottomNavigationBar:       Padding(
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

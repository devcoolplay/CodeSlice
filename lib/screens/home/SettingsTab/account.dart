import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/services/notification.dart';
import 'package:mobile_app/services/storage.dart';
import 'package:mobile_app/shared/constants.dart';
import 'package:mobile_app/shared/user_data.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../services/auth.dart';
import '../../../services/database.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _usernameController = TextEditingController();
  final _infoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  late DatabaseService _db;

  bool _editUsername = false;
  bool _editInfo = false;

  void _saveUsername(String username) {
    try {
      _db.updateUsername(username, UserData.username);
      setState(() {
        UserData.username = username;
      });
    } catch (e) {
      print("Could not update username: $e");
    }
  }

  void _saveInfo(String info) {
    try {
      _db.updateInfo(info);
      setState(() {
        UserData.info = info;
      });
    } catch (e) {
      print("Could not update bio: $e");
    }
  }

  Future _selectImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Uint8List img = await file.readAsBytes();
      setState(() {
        UserData.profilePicture = img;
      });
      String imgUrl = await _storage.uploadImage(fileName: _auth.userId, image: img);
      //await _db.updateProfilePicture(imgUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    _db = DatabaseService(uuid: _auth.userId);
    _usernameController.text = UserData.username;
    _infoController.text = UserData.info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  UserData.profilePicture != null ?
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    backgroundImage: MemoryImage(UserData.profilePicture),
                  ) :
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    backgroundImage: AssetImage("assets/images/DefaultProfile.jpg"),
                  ),
                  Positioned(
                    bottom: -10.0,
                    left: 65.0,
                    child: IconButton(
                      color: Colors.black54,
                      icon: const Icon(Icons.image),
                      onPressed: _selectImageFromGallery,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30.0),
              ListTile(
                leading: const Icon(CupertinoIcons.person),
                title: const Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey
                  ),
                ),
                subtitle: TextFormField(
                  decoration: settingsInputDecoration,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9\.a-zA-Z_]")),
                  ],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLength: 32,
                  controller: _usernameController,
                  enabled: _editUsername,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter a username";
                    }
                    else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (val) async {
                    if (_usernameController.text == UserData.username) {
                      setState(() {
                        _editUsername = false;
                      });
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      if (!await _auth.checkUsername(_usernameController.text)) {
                        _saveUsername(_usernameController.text);
                        setState(() {
                          _editUsername = false;
                        });
                      }
                      else {
                        showNameNotAvailableDialog();
                      }
                    }
                  },
                  onTapOutside: (val) async {
                    if (_usernameController.text == UserData.username) {
                      setState(() {
                        _editUsername = false;
                      });
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      if (!await _auth.checkUsername(_usernameController.text)) {
                        _saveUsername(_usernameController.text);
                        setState(() {
                          _editUsername = false;
                        });
                      }
                      else {
                        setState(() {
                          _editUsername = false;
                          _usernameController.text = UserData.username;
                        });
                        await showNameNotAvailableDialog();
                      }
                    }
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _editUsername = true;
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.info),
                title: const Text(
                  "Bio",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey
                  ),
                ),
                subtitle: TextFormField(
                  decoration: settingsInputDecoration,
                  maxLines: 5,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLength: 128,
                  controller: _infoController,
                  enabled: _editInfo,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter a bio";
                    }
                    else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (val) async {
                    if (_infoController.text == UserData.info) {
                      setState(() {
                        _editInfo = false;
                      });
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      if (_infoController.text != UserData.info) {
                        _saveInfo(_infoController.text);
                        setState(() {
                          _editInfo = false;
                        });
                      }
                    }
                  },
                  onTapOutside: (val) async {
                    if (_infoController.text == UserData.info) {
                      setState(() {
                        _editInfo = false;
                      });
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      if (_infoController.text != UserData.info) {
                        _saveInfo(_infoController.text);
                        setState(() {
                          _editInfo = false;
                        });
                      }
                    }
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _editInfo = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
        child: ElevatedButton(
            onPressed: () async {
              await showSignOutDialog();
              Navigator.of(context).pop();
            },
            child: const Text("Sign Out")
        ),
      ),
    );
  }

  Future showSignOutDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        //title: const Text("Delete Snippets"),
        content: const Text(
          "Are you sure you want to sign out?",
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              //final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);
              //selectedSnippetsProvider.selectedSnippets.clear();
              await NotificationService().invalidateToken();
              await _auth.signOut();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primarySwatchColor,
            ),
            child: const Text("Yes, Sign Out"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
            ),
            child: const Text("Cancel"),
          ),
        ],
      )
  );

  Future showNameNotAvailableDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
      actionsAlignment: MainAxisAlignment.center,
      content: const Text("This username is already taken"),
      actions: [
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    )
  );
}


/// The Home widget shows app bar and navigation bar.
/// Also, it decides what screen to show according to the currently selected tab

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/folder.dart';
import 'package:mobile_app/screens/home/MySnippetsTab/add_snippet.dart';
import 'package:mobile_app/screens/home/MySnippetsTab/edit_snippet.dart';
import 'package:mobile_app/screens/home/SettingsTab/settings.dart';
import 'package:mobile_app/services/social.dart';
import 'package:mobile_app/services/storage.dart';
import 'package:mobile_app/shared/app_data.dart';
import 'package:mobile_app/shared/constants.dart';
import 'package:mobile_app/shared/friends_data.dart';
import 'package:mobile_app/shared/user_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_app/services/notification.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../../shared/friends_list.dart';
import 'CommunityTab/community.dart';
import 'MySnippetsTab/add_folder.dart';
import 'SnippetGeneratorTab/ai.dart';
import 'package:mobile_app/screens/home/MySnippetsTab/my_snippets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // nav bar
  var _selectedTab = 0;

  late final AuthService _auth;
  late final StorageService _storage;
  late final DatabaseService _db;
  late final SocialService _social;

  // Checking internet connectivity
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var tabs = [
    Consumer<MySnippetsPathProvider>(
      builder: (context, pa, _) => MySnippets(search: "", path: pa.path),
    ),
    const Feed(),
    const AI(),
    const Settings(),
  ];

  void _loadUsername() async {
    UserData.username = await _auth.username;
  }

  void _loadInfo() async {
    UserData.info = await _db.info;
  }

  void _loadProfilePicture() async {
    UserData.profilePicture = await _storage.getImage(_auth.userId);
  }

  void _loadFriendProfilePictures() async {
    List friendsList = await _social.friendsAsList;
    for (String friendId in friendsList) {
      try {
        FriendsData.profilePictures[friendId] = (await _storage.getImage(friendId))!;
      } catch (e) {
        FriendsData.profilePictures[friendId] = null;
        print("User has no profile picture");
      }
    }
  }

  void _initNotifications() async {
    if (!kIsWeb) {
      await NotificationService().initNotifications();
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Couldn't check connectivity status: $e");
    }

    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  var _noInternetDialogOpen = false;
  BuildContext? _dContext;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print("Connection status changed: $result");
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus == ConnectivityResult.none && !_noInternetDialogOpen) {
      showNoInternetDialog();
      _noInternetDialogOpen = true;
    }
    if ((_connectionStatus == ConnectivityResult.wifi || _connectionStatus == ConnectivityResult.mobile) && _noInternetDialogOpen) {
      if (_dContext != null) {
        Navigator.of(_dContext!).pop();
      }
      _noInternetDialogOpen= false;
      _dContext = null;
    }

  }

  var mySnippetPathNotifier = MySnippetsPathProvider();

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _storage = StorageService();
    _db = DatabaseService(uuid: _auth.userId);
    _social = SocialService(uuid: _auth.userId);
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _loadUsername();
    _loadInfo();
    _loadProfilePicture();
    _loadFriendProfilePictures();
    _initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);
    final selectedFoldersProvider = Provider.of<SelectedFoldersProvider>(context);
    final mySnippetsPathProvider = Provider.of<MySnippetsPathProvider>(context);

    void showAddFolderPage() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AddFolder())
      );
    }
    void showAddSnippetPage() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AddSnippet())
      );
    }
    void showEditSnippetPage() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EditSnippet(snippetId: selectedSnippetsProvider.selectedSnippets[0]))
      );
    }
    void showSharePanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                selectedSnippetsProvider.selectedSnippets.length == 1 ?
                Text(
                  "Share Selected Snippet",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ) :
                Text(
                  "Share Selected Snippets",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20.0),
                StreamProvider<List<String>?>.value(
                  value: _social.friends,
                  initialData: null,
                  child: const FriendsList(isShareMenu: true),
                ),
              ],
            ),
          );
        }
      );
    }

    List<AppBar> appBars = [
      AppBar(       // My Snippets tab app bar
        title: const Text("My Snippets"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.search),
          tooltip: "Search",
          onPressed: () {
            showSearch(
                context: context,
                delegate: SnippetSearchBar()
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.folder_badge_plus),
            tooltip: "Add folder",
            onPressed: () {
              showAddFolderPage();
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            tooltip: "Add Snippet",
            onPressed: () {
              showAddSnippetPage();
            },
          ),
        ],
      ),
      AppBar(       // Community Feed tab app bar
        title: const Text("Community Feed"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {

            },
          )
        ],
      ),
      AppBar(       // Snippet Generator tab app bar
        title: const Text("Snippet Generator"),
        centerTitle: true,
      ),
      AppBar(       // Settings tab app bar
        title: const Text("Settings"),
        centerTitle: true,
      ),
      AppBar(       // Single snippet selected app bar
        title: Text("Select (${selectedSnippetsProvider.selectedSnippets.length})"),
        centerTitle: false,
        actions: _selectedTab == 0 ? [
          IconButton(
            onPressed: () {
              showSharePanel();
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              showEditSnippetPage();
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDeleteDialog(_db, selectedSnippetsProvider, selectedFoldersProvider);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ] : [
          IconButton(
            onPressed: () {
              showDeleteDialog(_db, selectedSnippetsProvider, selectedFoldersProvider);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ]
      ),
      AppBar(       // Multiple snippets selected app bar
        title: Text("Select (${selectedSnippetsProvider.selectedSnippets.length})"),
        centerTitle: false,
        actions: _selectedTab == 0 ? [
          IconButton(
            onPressed: () {
              showSharePanel();
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              showDeleteDialog(_db, selectedSnippetsProvider, selectedFoldersProvider);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ] : [
          IconButton(
            onPressed: () {
              showDeleteDialog(_db, selectedSnippetsProvider, selectedFoldersProvider);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ]
      ),
      AppBar(       // Single folder selected app bar
        title: Text("Selected (${selectedFoldersProvider.selectedFolders.length})"),
        centerTitle: false,
        actions: selectedFoldersProvider.selectedFolders.length == 1 ? [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDeleteDialog(_db, selectedSnippetsProvider, selectedFoldersProvider);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )
        ] : [
          IconButton(
            onPressed: () {
              showDeleteDialog(_db, selectedSnippetsProvider, selectedFoldersProvider);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )
        ],
      )
    ];

    return WillPopScope(
      onWillPop: () async {
        if (selectedSnippetsProvider.selectedSnippets.isNotEmpty) {
          setState(() {
            selectedSnippetsProvider.unselectAllSnippets();
          });
          return false;
        }
        if (selectedFoldersProvider.selectedFolders.isNotEmpty) {
          setState(() {
            selectedFoldersProvider.unselectAllFolders();
          });
          return false;
        }
        if (AppData.mySnippetsPath != "/") {
          print(AppData.mySnippetsPath);
          String newPath = AppData.mySnippetsPath.substring(0, AppData.mySnippetsPath.lastIndexOf('/'));
          if (newPath == "") {
            newPath = "/";
          }
          mySnippetsPathProvider.setPath(newPath);
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        appBar: _selectedTab == 0 && selectedFoldersProvider.selectedFolders.isNotEmpty ? appBars[6] : _selectedTab == 0 || _selectedTab == 1 ? selectedSnippetsProvider.selectedSnippets.isEmpty ? appBars[_selectedTab == 0 ? 0 : 1] : (selectedSnippetsProvider.selectedSnippets.length > 1 ? appBars[5] : appBars[4]) : appBars[_selectedTab],
        bottomNavigationBar: _buildFloatingBar(context),
        body: _selectedTab == 2 && _connectionStatus == ConnectivityResult.none ? const Center(child: Text("You are not connected to the internet!"),) : tabs[_selectedTab],
        /*floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
              themeProvider.setTheme("light");
            }
            else {
              C
            }
          },
        ),*/
      ),
    );
  }

  Widget _buildFloatingBar(BuildContext context) {
    final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomNavigationBar(
        iconSize: 30.0,
        selectedColor: primarySwatchColor,
        strokeColor: const Color(0x300c18fb),
        //unSelectedColor: Colors.grey[600],
        backgroundColor: Theme.of(context).cardColor,
        borderRadius: const Radius.circular(20.0),
        items: [
          CustomNavigationBarItem(
            icon: const Icon(
                CupertinoIcons.chevron_left_slash_chevron_right
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
                CupertinoIcons.person_2
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
                CupertinoIcons.lightbulb
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
                CupertinoIcons.settings
            ),
          ),
        ],
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
            selectedSnippetsProvider.unselectAllSnippets();
          });
        },
        isFloating: true,
      ),
    );
  }

  Future showDeleteDialog(DatabaseService db, SelectedSnippetsProvider selectedSnippetsProvider, SelectedFoldersProvider selectedFoldersProvider) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.delete),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      //title: const Text("Delete Snippets"),
      content: Text(
        selectedSnippetsProvider.selectedSnippets.isNotEmpty ? (selectedSnippetsProvider.selectedSnippets.length > 1 ?
          "Are you sure you want to delete the selected Snippets?\nThey can't be restored." :
            "Are your sure you want to delete the selected Snippet?\nIt can't be restored."
        ) : (selectedFoldersProvider.selectedFolders.length > 1 ?
          "Are you sure you want to delete the selected Folders?\nAll Snippets inside the folder will also be deleted." :
            "Are you sure you want to delete the selected Folder?\nAll Snippets inside the folders will also be deleted."
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_selectedTab == 0) {
              if (selectedSnippetsProvider.selectedSnippets.isNotEmpty) {
                for (String snip in selectedSnippetsProvider.selectedSnippets) {
                  await db.deleteSnippets(snip);
                }
              }
              else {
                for (String folder in selectedFoldersProvider.selectedFolders) {
                  await db.removeFolder(folder, AppData.mySnippetsPath);
                }
              }
            }
            else if (_selectedTab == 1) {
              for (String snip in selectedSnippetsProvider.selectedSnippets) {
                await _social.deleteSharedSnippet(userId: _auth.userId!, snippetId: snip);
              }
            }
            selectedSnippetsProvider.unselectAllSnippets();
            selectedFoldersProvider.unselectAllFolders();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text("Delete"),
        ),
        ElevatedButton(
          onPressed: () {
            selectedSnippetsProvider.unselectAllSnippets();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text("Cancel"),
        ),
      ],
    )
  );

  Future showNoInternetDialog() => showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        _dContext = context;
        return AlertDialog(
          icon: const Icon(CupertinoIcons.wifi_slash),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          //title: const Text("Delete Snippets"),
          content: const Text("You are not connected to the internet!\nSome functions might not be available",
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                //backgroundColor: Colors.grey,
              ),
              child: const Text("OK"),
            ),
          ],
        );
      }
  );
}

class SnippetSearchBar extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(CupertinoIcons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null); // close search bar
          }
          else {
            query = "";
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.back),
      onPressed: () => close(context, null), // close search bar
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<MySnippetsPathProvider>(
      builder: (context, pa, _) => MySnippets(search: query.toLowerCase(), path: pa.path),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<MySnippetsPathProvider>(
      builder: (context, pa, _) => MySnippets(search: query.toLowerCase(), path: pa.path),
    );
  }

}
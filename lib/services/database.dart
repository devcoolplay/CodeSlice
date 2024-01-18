
/// The DatabaseService class acts as an interface between the database and the front-end (the app).
/// Specifically, it is responsible for updating a user's personal information (such as the username) and snippets.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/models/snippet.dart';

import '../models/folder.dart';

class DatabaseService {

  String uid = "";

  // Collection reference
  CollectionReference userDataCollection = FirebaseFirestore.instance.collection("dummy");
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  DatabaseService({required uuid}) {
    uid = uuid;
    userDataCollection = FirebaseFirestore.instance.collection(uid);
  }

  // Create user in database
  Future createUser({required String username}) async {
    // create a new document for the user with uid in the database
    await addSnippet("My First Snippet", "print('Hello World!')", "Python", "empty", "/");

    // Store username in user's collection
    usersCollection.doc(uid).set({
      "username": username,
      "info": "Hello World!",
      "folders": [{"name": "", "path": "/", "color": "none"}],
      "friends": [""],
      "friend_requests": [""],
      "shared_snippets": [{"empty": "empty"}],
      "notification_token": [""],
    });

    // Add username to users list
    return await usersCollection.doc(username).set({
      "id": uid
    });
  }

  // Update friends list in database
  Future updateFriends({required String? listOf, required String listEntry}) async {
    try {
      List<String>? friendList = await getFriendsId(userId: listOf);
      friendList?.insert(0, "");
      if (friendList != null) {
        if (friendList.contains(listEntry)) {
          friendList.remove(listEntry);
          await usersCollection.doc(listOf).update({
            "friends": friendList
          });
        }
        else {
          friendList.add(listEntry);
          await usersCollection.doc(listOf).update({
            "friends": friendList
          });
        }
      }
      else {
        throw Exception("getFriends return null");
      }
    } catch (e) {
      print("Something went wrong while trying to update friends list in database: $e");
    }
  }

  // Get a users friends list with name
  Future<List<String>?> getFriendsName({required String? userId}) async {
    try {
      DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String>  friendsListId = (data["friends"] as List).map((item) => item as String).toList();
      List<String> friendsListName = [""];
      if (friendsListId.isNotEmpty) {
        if (friendsListId.length > 1) {
          for (String id in friendsListId) {
            if (id != "") {
              String name = await getNameById(id);
              friendsListName.add(name);
            }
          }
        }
      }
      friendsListName.remove("");
      return friendsListName;
    } catch (e) {
      print("Could not fetch friends list from database: $e");
      return null;
    }
  }

  // Get a users friends list with id
  Future<List<String>?> getFriendsId({required String? userId}) async {
    try {
      DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String>  friendsListId = (data["friends"] as List).map((item) => item as String).toList();
      friendsListId.remove("");
      return friendsListId;
    } catch (e) {
      print("Could not fetch friends list from database: $e");
      return null;
    }
  }

  // Get a users friend_requests list with names
  Stream<List<String>> getFriendRequestsStream({required String? userId}) {
    return usersCollection.doc(userId).snapshots().map((doc) {
      List<String> idList = [];
      for (String id in doc.get("friend_requests")) {
        if (id != "") {
          idList.add(id);
        }
      }
      return idList;
    });
  }

  // Get a users friend_requests list with id
  Future<List<String>?> getFriendRequestsId({required String? userId}) async {
    try {
      DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String>  friendRequestsListId = (data["friend_requests"] as List).map((item) => item as String).toList();
      friendRequestsListId.remove("");
      return friendRequestsListId;
    } catch (e) {
      print("Could not fetch friend_requests list from database: $e");
      return null;
    }
  }

  // Update friend_requests list in database
  Future updateFriendRequests({required String? listOf, required String listEntry}) async {
    try {
      List<String>? friendRequestList = await getFriendRequestsId(userId: listOf);
      friendRequestList?.insert(0, "");
      if (friendRequestList != null) {
        if (friendRequestList.contains(listEntry)) {
          friendRequestList.remove(listEntry);
          return await usersCollection.doc(listOf).update({
            "friend_requests": friendRequestList
          });
        }
        else {
          friendRequestList.add(listEntry);
          return await usersCollection.doc(listOf).update({
            "friend_requests": friendRequestList
          });
        }
      }
      else {
        throw Exception("getFriendRequests returned null");
      }
    } catch (e) {
      print("Something went wrong while trying to update friend_requests list in database: $e");
    }
  }

  // Get the id of a user by its name
  Future<String> getIdByName(String name) async {
    try {
      DocumentSnapshot snapshot = await usersCollection.doc(name).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data["id"];
    } catch (e) {
      print(e);
      return "NotFound";
    }
  }

  // Get the name of a user by its id
  Future<String> getNameById(String id) async {
    try {
      DocumentSnapshot snapshot = await usersCollection.doc(id).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data["username"];
    } catch (e) {
      print(e);
      return "NotFound";
    }
  }

  // Add snippet to the database
  Future addSnippet(String snippetName, String snippetContent, String snippetLanguage, String snippetDescription, String snippetPath) async {
    return await userDataCollection.doc().set({
      "name": snippetName,
      "content": snippetContent,
      "language": snippetLanguage,
      "description": snippetDescription,
      "path": snippetPath,
      "timestamp": FieldValue.serverTimestamp()
    });
  }

  // Get snippet data by ID
  Future<Snippet> getSnippetById(String snippetId) async {
      DocumentSnapshot snapshot = await userDataCollection.doc(snippetId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Snippet(
        id: snippetId,
        name: data["name"] ?? "",
        content: data["content"] ?? "",
        language: data["language"] ?? "",
        description: data["description"] ?? "",
        path: data["path"] ?? "",
        timestamp: data["timestamp"].toDate() ?? ""
      );
  }

  // Update snippet
  Future updateSnippet(String id, String snippetName, String snippetContent, String snippetLanguage, String snippetDescription) async {
    return await userDataCollection.doc(id).update({
      "name": snippetName,
      "content": snippetContent,
      "language": snippetLanguage,
      "description": snippetDescription
    });
  }

  // Delete Snippet from database
  Future<void> deleteSnippets(String id) async {
    try {
      await userDataCollection.doc(id).delete();
    } catch (e) {
      print("Failed to delete database entry");
      print(e);
    }
  }

  // Snippet list from Snapshot
  List<Snippet> _snippetListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      DateTime timestamp;
      try {
        Timestamp timestampData = doc.get("timestamp");
        if (timestampData != null) {
          timestamp = timestampData.toDate();
        } else {
          // Handle the case where timestamp is null
          timestamp = DateTime.now(); // Provide a default value or handle it as needed
        }
      } catch (e) {
        timestamp = DateTime.now(); // Provide a default value or handle it as needed
      }
      return Snippet(
        id: doc.id,
        name: doc.get("name") ?? "",
        content: doc.get("content") ?? "",
        language: doc.get("language") ?? "",
        description: doc.get("description") ?? "",
        path: doc.get("path") ?? "",
        timestamp: timestamp
      );
    }).toList();
  }

  // Get snippets stream
  Stream<List<Snippet>> get snippets {
    return userDataCollection.snapshots()
        .map(_snippetListFromSnapshot);
  }

  List<Folder> _folderListFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<Folder> folders = [];
    for (var folder in data["folders"]) {
      folders.add(Folder(name: folder["name"]!, color: folder["color"]!, path: folder["path"]!));
    }
    return folders;
  }

  Stream<List<Folder>> get folders {
    return usersCollection.doc(uid).snapshots().map(_folderListFromSnapshot);
  }

  Future<List<String>> getNotificationTokens(String userId) async {
    DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<String> tokenList = [];
    for (String token in data["notification_tokens"]) {
      if (token != "") {
        tokenList.add(token);
      }
    }
    return tokenList;
  }

  Future<List<String>> getFolderNames(String userId, String path) async {
    DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<String> folders = [];
    for (var folder in data["folders"]) {
      if (folder["path"] == path) {
        folders.add(folder["name"]!);
      }
    }
    return folders;
  }

  Future<List<Map<String, String>>> getFolders(String userId) async {
    DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<Map<String, String>> folders = [];
    for (var folder in data["folders"]) {
      folders.add({"name": folder["name"]!, "color": folder["color"]!, "path": folder["path"]!});
    }
    return folders;
  }

  Future addNotificationToken(String? token) async {
    try {
      List<String> tokenList = await getNotificationTokens(uid);
      tokenList.insert(0, "");
      if (!tokenList.contains(token)) {
        tokenList.add(token!);
      }
      return await usersCollection.doc(uid).update({
        "notification_tokens": tokenList,
      });
    } catch (e) {
      print("Something went wrong while trying to add notification token to database: $e");
    }
  }

  Future removeNotificationToken(String? token) async {
    try {
      List<String> tokenList = await getNotificationTokens(uid);
      tokenList.insert(0, "");
      if (tokenList.contains(token)) {
        tokenList.remove(token!);
      }
      return await usersCollection.doc(uid).update({
        "notification_tokens": tokenList,
      });
    } catch (e) {
      print("Something went wrong while trying to remove notification token from database: $e");
    }
  }

  Future addFolder(String folderName, String folderColor, String folderPath) async {
    try {
      List<Map<String, String>> folders = await getFolders(uid);
      folders.add({"name": folderName, "color": folderColor, "path": folderPath});
      return await usersCollection.doc(uid).update({
        "folders": folders
      });
    } catch (e) {
      print("Couldn't add folder: $e");
    }
  }

  Future<List> getToDeleteSnippetIDs(String folderPath) async {
    QuerySnapshot querySnapshot = await userDataCollection.get();
    final allData = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
    final snips = allData.where((snip) => snip["path"] == folderPath).toList();
    final documentIds = snips.map((snip) => snip["id"]).toList();
    return documentIds;
  }
  
  Future<List<Map<String, String>>> getToDeleteFolders(String path) async {
    List<Map<String, String>> folders = await getFolders(uid);
    return folders.where((folder) => folder["path"] == path).toList();
  }

  Future removeFolder(String folderName, String folderPath) async {
    try {
      // Delete folders contained in the folder
      final toDeleteFolders = await getToDeleteFolders(folderPath != "/" ? "$folderPath/$folderName" : folderPath + folderName);
      print(toDeleteFolders);
      for (int i = 0; i < toDeleteFolders.length; i++) {
        await removeFolder(toDeleteFolders[i]["name"]!, toDeleteFolders[i]["path"]!);
      }
      // Delete snippets contained in the folder
      final toDeleteSnippets = await getToDeleteSnippetIDs(folderPath != "/" ? "$folderPath/$folderName" : folderPath + folderName);
      for (int i = 0; i < toDeleteSnippets.length; i++) {
        await deleteSnippets(toDeleteSnippets[i]);
      }
      // Delete folder itself
      List<Map<String, String>> folders = await getFolders(uid);
      folders.removeWhere((element) => element["name"] == folderName && element["path"] == folderPath);
      return await usersCollection.doc(uid).update({
        "folders": folders
      });
    } catch (e) {
      print("Couldn't remove folder: $e");
    }
  }

  Future updateUsername(String username, String oldUsername) async {
    // Store username in user's collection
    await usersCollection.doc(uid).update({
      "username": username,
    });

    // Remove old username from users list
    await usersCollection.doc(oldUsername).delete();

    // Add new username to users list
    return await usersCollection.doc(username).set({
      "id": uid
    });
  }

  // Update user info
  Future updateInfo(String info) async {
    return await usersCollection.doc(uid).update({
      "info": info
    });
  }

  // Get user info
  Future<String> get info async {
    DocumentSnapshot snapshot = await usersCollection.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["info"];
  }
}
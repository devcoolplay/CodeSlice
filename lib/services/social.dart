
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/community_snippet.dart';
import '../models/snippet.dart';
import '../shared/user_data.dart';
import 'database.dart';
import 'notification.dart';

class SocialService {

  late final DatabaseService _db;
  String uid = "";

  SocialService({required uuid}) {
    uid = uuid;
    _db = DatabaseService(uuid: uid);
  }

  Future<String> getUserInfo(String id) async {
    DocumentSnapshot snapshot = await _db.usersCollection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["info"];
  }

  Stream<List<String>?> get friends {
    return _db.usersCollection.doc(uid).snapshots().map((doc) {
      List<String> idList = [];
      for (String id in doc.get("friends")) {
        if (id != "") {
          idList.add(id);
        }
      }
      return idList;
    });
    //return await _db.getFriendsName(userId: uid);
  }

  Future<List<dynamic>> get friendsAsList async {
    DocumentSnapshot snapshot = await _db.usersCollection.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["friends"];
  }

  Stream<List<CommunitySnippet>?> get sharedSnippets {
    return _db.usersCollection.doc(uid).snapshots().map((doc) {
      List<CommunitySnippet> snippetList = [];
      for (Map<String, dynamic> map in doc.get("shared_snippets")) {
        if (!map.containsKey("empty")) {
          /* DateTime timestamp;
          try {
            Timestamp timestampData = map["timestamp"];
            if (timestampData != null) {
              timestamp = timestampData.toDate();
            } else {
              // Handle the case where timestamp is null
              timestamp = DateTime.now(); // Provide a default value or handle it as needed
            }
          } catch (e) {
            timestamp = DateTime.now(); // Provide a default value or handle it as needed
          }*/
          snippetList.add(CommunitySnippet(
            from: map["from_user"],
            id: map["id"],
            name: map["name"],
            content: map["content"],
            language: map["language"],
            description: map["description"],
            //timestamp: timestamp, // Firebase: Timestamp currently not allowed in arrays
          ));
        }
      }
      return snippetList;
    });
  }

  Future<List<dynamic>> getSharedSnippetsOf(String id) async {
    DocumentSnapshot snapshot = await _db.usersCollection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["shared_snippets"];
  }

  Future shareSnippet({required String userId, required Snippet snippet}) async {
    try {
      // Get user's current shared_snippets list
      List<dynamic> snippetList = await getSharedSnippetsOf(userId);
      if (!snippetList.any((element) => element["id"] == snippet.id)) {
        snippetList.add({
          "from_user": uid,
          "id": snippet.id,
          "name": snippet.name,
          "content": snippet.content,
          "language": snippet.language,
          "description": snippet.description,
          //"timestamp": FieldValue.serverTimestamp() // Firebase: Timestamp currently not allowed in arrays
        });
        NotificationService().sendShareNotification(userId, UserData.username, snippet.name);
      }
      return await _db.usersCollection.doc(userId).update({
        "shared_snippets": snippetList,
      });
    } catch (e) {
      print("Something went wrong while trying to share snippet: $e");
    }
  }

  Future deleteSharedSnippet({required String userId, required String snippetId}) async {
    try {
      List<dynamic> snippetList = await getSharedSnippetsOf(userId);
      snippetList.removeWhere((snip) => snip["id"] == snippetId);
      return await _db.usersCollection.doc(userId).update({
        "shared_snippets": snippetList,
      });
    } catch (e) {
      print("Something went wrong while trying to delete shared snippet: $e");
    }
  }

  Stream<List<String>?> get friendRequests {
    return _db.usersCollection.doc(uid).snapshots().map((doc) {
      List<String> idList = [];
      for (String id in doc.get("friend_requests")) {
        if (id != "") {
          idList.add(id);
        }
      }
      return idList;
    });
  }

  Future removeFriend({required String friendId}) async {
    try {
      // Remove friend's username from my friends list (in database)
      _db.updateFriends(listOf: uid, listEntry: friendId);
      // Remove my username from my friend's friends list (in database)
      _db.updateFriends(listOf: friendId, listEntry: uid);
    } catch (e) {
      print("Something went wrong while trying to unfriend: $e");
    }
  }

  Future<bool> sendFriendRequest({required String friendUsername}) async {
    try {
      String userId = await _db.getIdByName(friendUsername);
      if (userId == "NotFound") {
        return false;
      }
      await _db.updateFriendRequests(listOf: userId, listEntry: uid);
      return true;
    } catch (e) {
      print("Something went wrong while trying to send friend request: $e");
      return false;
    }
  }

  Future acceptFriendRequest({required String friendId}) async {
    try {
      // Get the friends userId in order to add my name to friend's friends list
      String friendUsername = await _db.getNameById(friendId);
      if (friendId == "NotFound") {
        throw Exception("This user does not exist in the database");
      }
      // Add friend's username to my friends list (in database)
      _db.updateFriends(listOf: uid, listEntry: friendId);
      // Add my username to my friend's friends list (in database)
      _db.updateFriends(listOf: friendId, listEntry: uid);
      // Add friend to local friends list
      UserData.friends.add(friendUsername);
      // Remove friend request from my friend_requests list (in database)
      _db.updateFriendRequests(listOf: uid, listEntry: friendId);
      // Remove friend request from my local friendRequests list
      UserData.friendRequests.remove(friendUsername);
    } catch (e) {
      print("Something went wrong while trying to accept friend request: $e");
    }
  }

  Future rejectFriendRequest({required String friendId}) async {
    try {
      String friendUsername = await _db.getNameById(friendId);
      if (friendId == "NotFound") {
        throw Exception("This user does not exist in the database");
      }
      // Remove friend request from my friend_requests list (in database)
      _db.updateFriendRequests(listOf: uid, listEntry: friendId);
      // Remove friend request from my local friendRequests list
      UserData.friendRequests.remove(friendUsername);
    } catch (e) {
      print("Something went wrong while trying to reject friend request: $e");
    }
  }
}
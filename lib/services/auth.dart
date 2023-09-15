
/// The AuthService class acts as an interface between the database and the front-end (the app).
/// Specifically, it manages every process that has to do with authentication

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  String? get userId {
    return _auth.currentUser?.uid;
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email & password
  Future signInWithEmailAndPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email & password
  Future registerWithEmailAndPass({required String email, required String password, required String username}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Create user
      await DatabaseService(uuid: user?.uid).createUser(username: username);

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Retrieve username
  Future<String> get username async {
    DocumentSnapshot snapshot = await DatabaseService(uuid: userId).usersCollection.doc(userId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["username"];
  }

  // Check whether username already exists on sign up
  Future<bool> checkUsername(String username) async {
    try {
      final DocumentSnapshot snapshot = await DatabaseService(uuid: userId).usersCollection.doc(username).get();
      return snapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
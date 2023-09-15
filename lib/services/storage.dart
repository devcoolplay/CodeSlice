
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to cloud storage
  Future<String> uploadImage({required String? fileName, required Uint8List image}) async {
    Reference ref = _storage.ref().child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL(); // return download URL
  }

  // Get image from cloud storage
  Future<Uint8List?> getImage(String? fileName) async {
    try {
      Reference ref = _storage.ref().child(fileName!);
      return await ref.getData();
    } catch (e) {
      print("Couldn't load profile picture. Maybe it doesn't exist?");
      print(e);
    }
  }
}
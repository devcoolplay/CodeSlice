import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/services/storage.dart';
import 'package:mobile_app/shared/friends_data.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({super.key, required this.userId, required this.size});

  final String userId;
  final double size;

  final StorageService _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    // If user is a friend, get the profile picture from memory
    if (FriendsData.profilePictures.containsKey(userId)) {
      if (FriendsData.profilePictures[userId] != null) {
        return CircleAvatar(
          backgroundColor: Colors.white,
          radius: size,
          backgroundImage: MemoryImage(FriendsData.profilePictures[userId]!),
        );
      }
      else {
        return CircleAvatar(
          backgroundColor: Colors.white,
          radius: size,
          backgroundImage: const AssetImage("assets/images/DefaultProfile.jpg"),
        );
      }
    }
    // If user is not a friend, then try to load the profile picture from firebase
    else {
      return FutureBuilder<Uint8List?>(
        future: _storage.getImage(userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return const SizedBox(height: 100.0, child: SpinKitThreeBounce(color: Colors.grey, size: 20));
            default:
              if (snapshot.hasError) {
                return const Text("Error while trying to fetch profile picture");
              }
              if (snapshot.data == null) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: size,
                  backgroundImage: const AssetImage("assets/images/DefaultProfile.jpg"),
                );
              }
              return CircleAvatar(
                backgroundColor: Colors.white,
                radius: size,
                backgroundImage: MemoryImage(snapshot.data!),
              );
          }
        },
      );
    }
  }
}

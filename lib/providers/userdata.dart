import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  String? _username;
  String? _imageUrl; // Rename the private variable with a leading underscore

  String? get username => _username; // getter for username
  String? get imageUrl => _imageUrl; // getter for imageUrl

  UserData() {
    _getUser(); // Call the function in the constructor
  }

  Future<void> _getUser() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      _username = value.data()!['username'];
      _imageUrl =
          value.data()!['imageUrl'][0]; // Store the URL in the private variable
      notifyListeners();
    });
  }

  Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Gửi thông báo cho các listener để cập nhật UI hoặc trạng thái
      notifyListeners();
      print("User successfully logged out.");
    } catch (e) {
      print("Error during logout: $e");
      throw Exception("Failed to log out. Please try again.");
    }
  }

  Future<void> saveLikedUser({
    required String likedUsername,
    required String likedUserage,
    required List imageurls,
    required List likedUserInterest,
    required String likedUseremail,
    required String likedUserAddress,
    required String currentUsername,
    required String job,
    required List currentUserImageurls,
    required String currentUserAge,
    required List currentUserInterest,
    required String currentUserAddress,
    required String currentoccupation,
    required String occupation,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('likeduser').doc().set({
        'email': FirebaseAuth.instance.currentUser!.email,
        'username': currentUsername,
        'imageUrl': currentUserImageurls,
        'age': currentUserAge,
        'job': job,
        'interest': currentUserInterest,
        'address': currentUserAddress,
        'occupation': currentoccupation,
        'likedUsername': likedUsername,
        'likedUserEmail': likedUseremail,
        'likedUserage': likedUserage,
        'likedUserImageUrls': imageurls,
        'likedUserInterests': likedUserInterest,
        'likeduserAddress': likedUserAddress,
        'likedUseroccupation': occupation,
        'matched': false,
      });
    } catch (e) {
      print('Error saving liked user: $e');
    }
  }

  Future<void> deleteUser(id) async {
    await FirebaseFirestore.instance.collection('likeduser').doc(id).delete();
  }
}

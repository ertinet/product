import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageUtils {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String>  uploadFinishedRecordingToCloud(String localPath) async {
    var folder = storage.ref('user_recordings');
    var uploadLocation =
        folder.child('${_auth.currentUser?.uid}/${const Uuid().v1()}.m4a');
    uploadLocation.putFile(File(localPath));
    await addSong(uploadLocation.fullPath);
    return uploadLocation.fullPath;
  }


  Future<void> addSong(String downloadUrl) {
    return FirebaseFirestore.instance
        .collection('songs')
        .add({
      'title': 'Song Title ${const Uuid().v1()}',  // Replace with actual data
      'fileURL': downloadUrl, // URL from Firebase Storage
      'owner': _auth.currentUser!.uid, // Current user ID
      'organization': 'org1', // Replace with actual data
    })
        .then((value) => print("Song Added"))
        .catchError((error) => print("Failed to add song: $error"));
  }

}

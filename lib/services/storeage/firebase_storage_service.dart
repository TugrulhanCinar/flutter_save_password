import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_save_password/services/storeage/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekDosya) async {
    var uploadTask =await _firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child("profile_photo")
        .putFile(yuklenecekDosya);
    return uploadTask.ref.getDownloadURL();
  }
}

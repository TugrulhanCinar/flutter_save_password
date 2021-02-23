import 'dart:io';

abstract class StorageBase {
  Future<String> saveUserPhoto(String userID, String fileType, File file);

}

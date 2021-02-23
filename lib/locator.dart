import 'package:flutter_save_password/services/auth/firebase_auth.dart';
import 'package:flutter_save_password/services/repository/user_repository.dart';
import 'package:flutter_save_password/services/storage/firebase_storage_service.dart';
import 'package:get_it/get_it.dart';
import 'services/database/firebase_db_services.dart';


final locator = GetIt.instance;
void setup() {
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseAuthServices());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
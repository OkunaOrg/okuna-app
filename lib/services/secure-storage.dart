import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

/// TODO Create namespaced storages to prevent overwrite

class SecureStorageService {
  final storage = new FlutterSecureStorage();

  Future<String> get({@required String key}) {
    return storage.read(key: key);
  }

  Future<void> set({@required String key, @required String value}) {
    return storage.write(key: key, value: value);
  }

  Future<void> remove({@required String key}){
    return storage.delete(key: key);
  }

  Future<void> clear(){
    return storage.deleteAll();
  }
}

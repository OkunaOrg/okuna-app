import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  OBStorage getSecureStorage({String namespace}) {
    return OBStorage(store: _SecureStore(), namespace: namespace);
  }
}

class OBStorage {
  _Store store;
  String namespace;

  OBStorage({this.store, this.namespace});

  Future<String> get(String key) {
    return this.store.get(_makeKey(key));
  }

  Future<void> set(String key, dynamic value) {
    return this.store.set(_makeKey(key), value);
  }

  Future<void> remove(String key) {
    return this.store.remove(this._makeKey(key));
  }

  Future<void> clear() {
    return this.store.clear();
  }

  String _makeKey(String key) {
    if (this.namespace == null) return key;
    return '$namespace.$key';
  }
}

class _SecureStore implements _Store<String> {
  final storage = new FlutterSecureStorage();

  Future<String> get(String key) {
    return storage.read(key: key);
  }

  Future<void> set(String key, String value) {
    return storage.write(key: key, value: value);
  }

  Future<void> remove(String key) {
    return storage.delete(key: key);
  }

  Future<void> clear() {
    return storage.deleteAll();
  }
}

abstract class _Store<T> {
  Future<String> get(String key);

  Future<void> set(String key, T value);

  Future<void> remove(String key);

  Future<void> clear();
}

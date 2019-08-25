import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class StorageService {
  OBStorage getSecureStorage({String namespace}) {
    return OBStorage(store: _SecureStore(), namespace: namespace);
  }

  OBStorage getSystemPreferencesStorage({String namespace}) {
    return OBStorage(store: _SystemPreferencesStorage(namespace), namespace: namespace);
  }
}

class OBStorage {
  _Store store;
  String namespace;

  OBStorage({this.store, this.namespace});

  Future<String> get(String key) {
    return this.store.get(_makeKey(key));
  }

  Future<List<String>> getList(String key) {
    return this.store.getList(_makeKey(key));
  }

  Future<void> set(String key, dynamic value) {
    return this.store.set(_makeKey(key), value);
  }

  Future<void> setList(String key, dynamic value) {
    return this.store.setList(_makeKey(key), value);
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
  Set<String> _storedKeys = Set();

  _SecureStore() {
    _loadPreviouslyStoredKeys();
  }

  void _loadPreviouslyStoredKeys() async {
    // Storing the previous keys in a list in preferences instead of obtaining
    // them using storage.readAll(). For one thing, readAll() would decrypt all
    // stored data and send it back, which is unnecessary. On top of that,
    // readAll() doesn't work on iOS (https://github.com/mogol/flutter_secure_storage/issues/70).
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _storedKeys.addAll(preferences.getStringList('secure_store.keylist'));
  }

  void _saveStoredKeys() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('secure_store.keylist', _storedKeys.toList());
  }

  Future<String> get(String key) async {
    try {
      return storage.read(key: key);
    } on PlatformException {
      // This might happen when failed to decrypt
      await storage.delete(key: key);
      return null;
    }
  }

  Future<List<String>> getList(String key) {
    throw UnimplementedError("_SecureStore.getList and .setList haven't been"
        "implemented yet as they require custom parsing between strings and lists.");
    // Additional note: when implemented, the parsing must be able to handle elements
    // that contain whatever delimiter is used to separate elements.
  }

  Future<void> set(String key, String value) {
    if (_storedKeys.add(key)) {
      _saveStoredKeys();
    }
    return storage.write(key: key, value: value);
  }

  Future<void> setList(String key, List<String> value) {
    throw UnimplementedError("_SecureStore.getList and .setList haven't been"
        "implemented yet as they require custom parsing between strings and lists.");
    // Additional note: when implemented, the conversion from list to string must
    // escape element separators that are found within elements themselves.
  }

  Future<void> remove(String key) {
    if (_storedKeys.remove(key)) {
      _saveStoredKeys();
    }
    return storage.delete(key: key);
  }

  Future<void> clear() {
    return Future.wait(
        _storedKeys.map((String key) => storage.delete(key: key)));
  }
}

class _SystemPreferencesStorage implements _Store<String> {
  final String _namespace;

  Future<SharedPreferences> _sharedPreferencesCache;

  _SystemPreferencesStorage(String namespace) : _namespace = namespace;

  Future<SharedPreferences> _getSharedPreferences() async {
    if (_sharedPreferencesCache != null) return _sharedPreferencesCache;
    _sharedPreferencesCache = SharedPreferences.getInstance();
    return _sharedPreferencesCache;
  }

  Future<String> get(String key) async {
    SharedPreferences sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.get(key);
  }

  Future<List<String>> getList(String key) async {
    SharedPreferences sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.getStringList(key);
  }

  Future<void> set(String key, String value) async {
    SharedPreferences sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.setString(key, value);
  }

  Future<void> setList(String key, List<String> value) async {
    SharedPreferences sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.setStringList(key, value);
  }

  Future<void> remove(String key) async {
    SharedPreferences sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.remove(key);
  }

  Future<void> clear() async {
    SharedPreferences preferences = await _getSharedPreferences();
    return Future.wait(preferences
        .getKeys()
        .where((key) => key.startsWith('$_namespace.'))
        .map((key) => preferences.remove(key)));
  }
}

abstract class _Store<T> {
  Future<String> get(String key);

  Future<List<String>> getList(String key);

  Future<void> set(String key, T value);

  Future<void> setList(String key, List<T> value);

  Future<void> remove(String key);

  Future<void> clear();
}

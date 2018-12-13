import 'package:dcache/dcache.dart';
import 'package:rxdart/rxdart.dart';

abstract class UpdatableModel<T> {
  final int id;

  Stream<T> get updateSubject => _updateChangeSubject.stream;
  final _updateChangeSubject = ReplaySubject<T>(maxSize: 1);

  UpdatableModel({this.id}) {
    notifyUpdate();
  }

  void notifyUpdate() {
    this._updateChangeSubject.add(this as T);
  }

  void update(Map json) {
    updateFromJson(json);
    notifyUpdate();
  }

  void updateFromJson(Map json);

  void dispose() {
    this._updateChangeSubject.close();
  }
}

abstract class UpdatableModelFactory<T extends UpdatableModel> {
  SimpleCache<int, T> cache;

  UpdatableModelFactory({this.cache}) {
    if (this.cache == null)
      cache = SimpleCache(storage: SimpleStorage(size: 10));
  }

  T fromJson(Map<String, dynamic> json) {
    int itemId = json['id'];

    UpdatableModel item = getItemWithIdFromCache(itemId);

    if (item != null) {
      item.update(json);
      return item;
    }

    item = makeFromJson(json);
    addToCache(item);
    return item;
  }

  T makeFromJson(Map json);

  T getItemWithIdFromCache(int itemId) {
    return cache.get(itemId);
  }

  void addToCache(T item) {
    cache.set(item.id, item);
  }

  void clearCache() {
    cache.clear();
  }
}

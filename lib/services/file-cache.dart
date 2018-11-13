import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FileCacheService {
  FileCacheService() {
    CacheManager.inBetweenCleans = new Duration(hours: 1);
    CacheManager.maxAgeCacheObject = new Duration(days: 1);
  }
}

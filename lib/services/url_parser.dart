import 'package:flutter/services.dart';
import 'package:public_suffix/public_suffix.dart';

class UrlParserService {
  Map<String, PublicSuffix> parsedUrlCache = {};

  void loadSuffixRules() async {
    String suffixListString =
        await rootBundle.loadString('assets/public_suffix_list.dat');
    SuffixRules.initFromString(suffixListString);
  }

  PublicSuffix parse(String url) {
    return parsedUrlCache.putIfAbsent(url, () => PublicSuffix(Uri.parse(url)));
  }
}

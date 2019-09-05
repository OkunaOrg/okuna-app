import 'dart:convert';
import 'dart:io';

void main() {
  final i18nPath = File('${Directory.current.path}/assets/i18n');

  var langs = Directory(i18nPath.path).listSync().where(
      (langDir) => langDir.statSync().type == FileSystemEntityType.directory);

  var jsonEncoder = JsonEncoder.withIndent('  ');
  langs.forEach((lang) {
    var files = Directory(lang.path).listSync().where(
        (arbFile) => arbFile.statSync().type == FileSystemEntityType.file);
    var langObj = _unify(lang, files);
    var output = jsonEncoder.convert(langObj);

    File('${i18nPath.path}/intl_${_getBaseName(lang)}.arb')
        .writeAsStringSync(output);
    print('Built locale ${_getBaseName(lang)}.');
  });

  print('Done!');
}

Map<String, dynamic> _unify(
    FileSystemEntity lang, Iterable<FileSystemEntity> files) {
  var obj = <String, dynamic>{};

  files.forEach((file) {
    var contents = File(file.path).readAsStringSync();
    Map<String, dynamic> json = jsonDecode(contents);

    var mainKey = _getBaseName(file);

    json.keys.forEach((key) {
      var newKey = key.startsWith('@')
          ? '@${mainKey}__${key.substring(1)}'
          : '${mainKey}__$key';
      obj[newKey] = json[key];
    });
  });

  return obj;
}

String _getBaseName(FileSystemEntity file) {
  var filename = file.path.replaceFirst(file.parent.path, '');

  if ((Platform.isWindows && filename.startsWith(r'\')) ||
      filename.startsWith('/')) {
    filename = filename.substring(1);
  }

  var dotIndex = filename.lastIndexOf('.');
  if (dotIndex >= 0) {
    return filename.substring(0, dotIndex);
  } else {
    return filename;
  }
}

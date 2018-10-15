import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:Openbook/services/localization.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HttpService {
  LocalizationService _localizationService;

  void setLocalizationService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  Future<http.Response> post(url,
      {Map<String, String> headers,
      body,
      Encoding encoding,
      bool appendLanguageHeader,
      bool appendTimezoneHeader}) {
    var finalHeaders = _getHeadersWithConfig(
        headers: headers,
        appendLanguageHeader: appendLanguageHeader);

    return http.post(url,
        headers: finalHeaders, body: body, encoding: encoding);
  }

  Future<http.Response> postJSON(url,
      {Map<String, String> headers = const {},
      body,
      Encoding encoding,
      bool appendLanguageHeader,
      bool appendTimezoneHeader}) {
    String jsonBody = json.encode(body);

    Map<String, String> jsonHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    jsonHeaders.addAll(headers);

    return post(url,
        headers: jsonHeaders,
        body: jsonBody,
        encoding: encoding,
        appendLanguageHeader: appendLanguageHeader,
        appendTimezoneHeader: appendTimezoneHeader);
  }

  Future<http.StreamedResponse> postMultiform(String url,
      {Map<String, String> headers = const {},
      Map<String, dynamic> body,
      Encoding encoding,
      bool appendLanguageHeader,
      bool appendTimezoneHeader}) {
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    var finalHeaders = _getHeadersWithConfig(
        headers: headers,
        appendLanguageHeader: appendLanguageHeader);

    request.headers.addAll(finalHeaders);

    List<Future> fileFields = [];

    body.forEach((String key, dynamic value) {
      if (value is String) {
        request.fields[key] = value;
      } else if (value is File) {
        var fileMimeType = lookupMimeType(value.path);
        // The silly multipart API requires media type to be in type & subtype.
        var fileMimeTypeSplit = fileMimeType.split('/');

        var fileFuture = http.MultipartFile.fromPath('avatar', value.path,
            contentType:
                new MediaType(fileMimeTypeSplit[0], fileMimeTypeSplit[1]));

        fileFields.add(fileFuture);
      } else {
        throw ('Unsupported multiform value type');
      }
    });

    return Future.wait(fileFields).then((files) {
      files.forEach((file) => request.files.add(file));
      return request.send();
    });
  }

  String _getLanguage() {
    return _localizationService.getLocale().languageCode;
  }

  Map<String, String> _getHeadersWithConfig(
      {Map<String, String> headers = const {},
      bool appendLanguageHeader}) {
    Map<String, String> finalHeaders = Map.from(headers);

    /// NOTE If we set the default value in the parameters, if other functions
    /// pass an empty argument, it will become null and override the default value
    /// This is a very weird thing of dart. It should take the default value
    /// when the value passed down is null.
    /// See https://github.com/dart-lang/sdk/issues/33918

    appendLanguageHeader = appendLanguageHeader ?? true;

    if (appendLanguageHeader) finalHeaders['Accept-Language'] = _getLanguage();

    return finalHeaders;
  }
}

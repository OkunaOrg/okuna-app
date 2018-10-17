import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:Openbook/services/localization.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HttpieService {
  LocalizationService _localizationService;

  void setLocalizationService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  Future<HttpieResponse> post(url,
      {Map<String, String> headers,
      body,
      Encoding encoding,
      bool appendLanguageHeader}) async {
    var finalHeaders = _getHeadersWithConfig(
        headers: headers, appendLanguageHeader: appendLanguageHeader);

    try {
      var response = await http.post(url,
          headers: finalHeaders, body: body, encoding: encoding);
      return HttpieResponse(response);
    } on SocketException catch (error) {
      if (error.osError.errorCode == 61) {
        // Connection refused.
        throw HttpieConnectionRefusedError(error);
      } else {
        rethrow;
      }
    }
  }

  Future<HttpieResponse> postJSON(url,
      {Map<String, String> headers = const {},
      body,
      Encoding encoding,
      bool appendLanguageHeader}) {
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
        appendLanguageHeader: appendLanguageHeader);
  }

  Future<HttpieResponse> get(url,
      {Map<String, String> headers, bool appendLanguageHeader}) async {
    var finalHeaders = _getHeadersWithConfig(
        headers: headers, appendLanguageHeader: appendLanguageHeader);

    var response = await http.get(url, headers: finalHeaders);
    return HttpieResponse(response);
  }

  Future<HttpieStreamedResponse> postMultiform(String url,
      {Map<String, String> headers = const {},
      Map<String, dynamic> body,
      Encoding encoding,
      bool appendLanguageHeader}) async {
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    var finalHeaders = _getHeadersWithConfig(
        headers: headers, appendLanguageHeader: appendLanguageHeader);

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
        throw HttpieArgumentsError('Unsupported multiform value type');
      }
    });

    var files = await Future.wait(fileFields);
    files.forEach((file) => request.files.add(file));
    var response = await request.send();
    return HttpieStreamedResponse(response);
  }

  String _getLanguage() {
    return _localizationService.getLocale().languageCode;
  }

  Map<String, String> _getHeadersWithConfig(
      {Map<String, String> headers = const {}, bool appendLanguageHeader}) {
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

abstract class BaseResponse<T extends http.BaseResponse> {
  T _httpResponse;

  BaseResponse(this._httpResponse);

  bool isInternalServerError() {
    return _httpResponse.statusCode == HttpStatus.internalServerError;
  }

  bool isBadRequest() {
    return _httpResponse.statusCode == HttpStatus.badRequest;
  }

  bool isOk() {
    return _httpResponse.statusCode == HttpStatus.ok;
  }

  bool isUnauthorized() {
    return _httpResponse.statusCode == HttpStatus.unauthorized;
  }

  bool isAccepted() {
    return _httpResponse.statusCode == HttpStatus.accepted;
  }

  bool isCreated() {
    return _httpResponse.statusCode == HttpStatus.created;
  }

  int get statusCode => _httpResponse.statusCode;
}

class HttpieResponse extends BaseResponse<http.Response> {
  HttpieResponse(_httpResponse) : super(_httpResponse);

  String get body => _httpResponse.body;

  Map<String, dynamic> parseJsonBody() {
    return json.decode(body);
  }

  http.Response get httpResponse => _httpResponse;
}

class HttpieStreamedResponse extends BaseResponse<http.StreamedResponse> {
  HttpieStreamedResponse(_httpResponse) : super(_httpResponse);
}

class HttpieRequestError implements Exception {
  final HttpieResponse response;

  const HttpieRequestError(HttpieResponse this.response);

  String toString() =>
      'HttpieRequestError:$response.statusCode - $response.body';
}

class HttpieConnectionRefusedError implements Exception {
  final SocketException socketException;

  const HttpieConnectionRefusedError(this.socketException);

  String toString(){
    String address = socketException.address.toString();
    String port = socketException.port.toString();
    return 'HttpieConnectionRefusedError: Connection refused on $address and port $port';
  }

}

class HttpieArgumentsError implements Exception {
  final String msg;

  const HttpieArgumentsError(this.msg);

  String toString() => 'HttpieArgumentsError: $msg';
}

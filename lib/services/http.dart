import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HttpService {
  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return http.post(url, headers: headers, body: body, encoding: encoding);
  }

  Future<http.Response> postJSON(url,
      {Map<String, String> headers = const {}, body, encoding}) {
    String jsonBody = json.encode(body);

    Map<String, String> jsonHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, String> mergedHeaders = {};

    mergedHeaders.addAll(headers);
    mergedHeaders.addAll(jsonHeaders);

    return post(url,
        headers: mergedHeaders, body: jsonBody, encoding: encoding);
  }

  Future<http.StreamedResponse> postMultiform(String url,
      {Map<String, String> headers = const {},
        Map<String, dynamic> body,
        encoding}) {
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    List<Future> fileFields = [];

    body.forEach((String key, dynamic value) {
      if (value is String) {
        request.fields[key] = value;
      } else if (value is File) {

        var fileMimeType = lookupMimeType(value.path);
        // The silly multipart API requires media type to be in type & subtype.
        var fileMimeTypeSplit = fileMimeType.split('/');

        var fileFuture =  http.MultipartFile.fromPath('avatar', value.path,
            contentType: new MediaType(fileMimeTypeSplit[0], fileMimeTypeSplit[1]));

        fileFields.add(fileFuture);
      } else {
        throw('Unsupported multiform value type');
      }
    });

    return Future.wait(fileFields).then((files){
      files.forEach((file) => request.files.add(file));
      return request.send();
    });
  }
}

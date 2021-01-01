import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class Network {
  final String _url = 'http://127.0.0.1:8000/api/v1';
  //See: https://stackoverflow.com/questions/49855754/unable-to-make-calls-to-localhost-using-flutter-random-port-being-assigned-to-h?answertab=votes#tab-top
  //to correctly comunicate the Android Emulator with an API running on localhost.

  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
  }

  authData(data, apiUrl) async {
    //Handles post requests (log-in/register)
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  register(data, photoPath, apiUrl) async {
    //Endpoint url
    var fullUrl = _url + apiUrl;
    print(fullUrl);

    //Multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(fullUrl),
    );

    //Add headers to request
    request.headers.addAll(_setHeadersRegister());

    //Add fields to request
    request.fields.addAll(data);

    //Add photo to request
    File photo = new File(photoPath);
    request.files.add(
      http.MultipartFile(
        'photo',
        photo.readAsBytes().asStream(),
        photo.lengthSync(),
        filename: basename(photoPath),
        contentType: MediaType('image', 'jpg'),
      ),
    );

    //Send request
    //https://stackoverflow.com/questions/55520829/how-to-get-response-body-with-request-send-in-dart
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  getData(apiUrl) async {
    //Handles get requests (including log-out)
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  _setHeadersRegister() => {
        'Content-type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}

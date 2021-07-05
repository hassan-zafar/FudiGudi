import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  //final String _url = 'https://fudigudi.ro/Fudigudi/webservice/';
  final String _url = "https://reqres.in/api/";
  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;

    // var fullUrl = exampleUrl + apiUrl;
    // + await _getToken();
    print(fullUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    print(token);
    return '?token=$token';
  }
}

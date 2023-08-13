import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiGlobal = "https://www....";
var headersAll = {'user': 'halohalo', 'Content-Type': 'application/json'};

class ApiAll {
  loginOke(Map<String, String> body, String endpoin) async {
    try {
      var request = http.Request('POST', Uri.parse('$apiGlobal/$endpoin'));
      request.body = json.encode(body);
      headersAll.addAll({'x-token': 'biasanya make statis token'});
      request.headers.addAll(headersAll);
      http.StreamedResponse response = await request.send();
      var responApi = await response.stream.bytesToString();
      Map allRespon = jsonDecode(responApi);
      if (response.statusCode == 200) {
        return allRespon;
      } else
        throw allRespon;
    } on TimeoutException catch (_) {
      throw "timeout";
    } catch (err) {
      throw err;
    }
  }

  apiGet() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      // headers: {'Authorization': 'Bearer YOUR_AUTH_TOKEN'}, //ini pas pake header
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal mendapatkan data get');
    }
  }

  hapusVoid(int param) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$param'),
      // headers: {'Authorization': 'Bearer YOUR_AUTH_TOKEN'}, //ini pas pake header
    );
    dynamic data = json.decode(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw data;
    }
  }

  updateItem(int id, String newName) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
      headers: {
        // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
        'Content-Type': 'application/json',
      },
      body: json.encode({'title': newName}),
    );
    dynamic data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw data;
    }
  }
}

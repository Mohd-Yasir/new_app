import 'package:http/http.dart' as http;
import 'dart:convert';

const String url =
    'https://my-json-server.typicode.com/tryninjastudy/dummyapi/db';

class ApiService {
  Future<List<Map<String, String>>> fetchConv() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> restaurant = data['restaurant'];

      List<Map<String, String>> conversations = restaurant
          .map((conversation) => {
                'bot': conversation['bot'].toString(),
                'human': conversation['human'].toString(),
              })
          .toList();
      return conversations;
    } else {
      throw Exception('Failed to load Data');
    }
  }
}

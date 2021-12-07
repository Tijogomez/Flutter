import 'dart:convert';

import 'package:flut_news/data/User.dart';
import 'package:http/http.dart' as http;

String url = 'https://randomuser.me/api/';

User? user = null;

Future getUser() async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final body = json.decode(response.body)['results'][0];
    user = User(
        body['name']['first'],
        body['name']['last'],
        body['login']['username'],
        body['picture']['large'],
        body['registered']['date']);

    return true;
  } else {
    return false;
  }
}

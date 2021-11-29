import 'package:flut_news/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

String url = 'https://randomuser.me/api/';

Future _fetchApi() async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return body;
  } else {
    throw Exception('Failed to load');
  }
}

String dateTimeConvertor(String date) {
  DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(dateTime);
  return formatted;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder(
        future: _fetchApi(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Image.network(
                          snapshot.data['results'][0]['picture']['large'],
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    snapshot.data['results'][0]['name']['first'] +
                        ' ' +
                        snapshot.data['results'][0]['name']['last'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '#' + snapshot.data['results'][0]['login']['username'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Card(
                          color: Colors.grey[300],
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'JOINED ON',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    dateTimeConvertor(snapshot.data['results']
                                        [0]['registered']['date']),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.grey[300],
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PERSONAL',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Gender: ' +
                                        snapshot.data['results'][0]['gender'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Birthday: ' +
                                        dateTimeConvertor(snapshot
                                            .data['results'][0]['dob']['date']),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Address: ' +
                                        snapshot.data['results'][0]['location']
                                            ['street']['name'] +
                                        ', ' +
                                        snapshot.data['results'][0]['location']
                                            ['city'] +
                                        ', ' +
                                        snapshot.data['results'][0]['location']
                                            ['state'] +
                                        ', ' +
                                        snapshot.data['results'][0]['location']
                                            ['country'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.grey[300],
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CONTACT',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Email: ' +
                                        snapshot.data['results'][0]['email'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Phone: ' +
                                        snapshot.data['results'][0]['phone'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Cell: ' +
                                        snapshot.data['results'][0]['cell'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

import 'package:flut_news/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'details_page.dart';

final List categories = [
  'All',
  'National',
  'Business',
  'Sports',
  'World',
  'Politics',
  'Technology',
  'Startup',
  'Entertainment',
  'Miscellaneous',
  'Hatke',
  'Science',
  'Automobile',
];

var snapshotData;
List favList = [];
int selectedCategory = 0;

String url =
    'https://inshortsapi.vercel.app/news?category=${categories[selectedCategory].toString().toLowerCase()}';

Future _fetchApi() async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return body;
  } else {
    throw Exception('Failed to load');
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void setCategory(int index) {
    setState(() {
      selectedCategory = index;
      url =
          'https://inshortsapi.vercel.app/news?category=${categories[selectedCategory].toString().toLowerCase()}';
    });
  }

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
          'FlutNews-Today',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 5.0,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(width: 0.8),
                      ),
                      hintText: 'Search Categories',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 30.0,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Available Categories',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue[100],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 13,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
                                  child: Center(
                                    child: Card(
                                      color: Colors.blueAccent,
                                      child: InkWell(
                                        onTap: () {
                                          setCategory(index);
                                        },
                                        splashColor: Colors.white30,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            categories[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Selected Category',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    FutureBuilder(
                      future: _fetchApi(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          snapshotData = snapshot.data;
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.572,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data['data'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      leading: Image.network(
                                        snapshot.data['data'][index]
                                            ['imageUrl'],
                                        height: 50.0,
                                        width: 60.0,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                        snapshot.data['data'][index]['title']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                              author: snapshot.data['data']
                                                  [index]['author'],
                                              title: snapshot.data['data']
                                                  [index]['title'],
                                              imageUrl: snapshot.data['data']
                                                  [index]['imageUrl'],
                                              content: snapshot.data['data']
                                                  [index]['content'],
                                              url: snapshot.data['data'][index]
                                                  ['url'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

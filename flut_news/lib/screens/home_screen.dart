import 'package:flut_news/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'details_page.dart';
import '../data/model/News.dart';
import '../data/db/NewsDataSource.dart';

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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsDataSource dataSource = NewsDataSource();

  String categorySelected = categories[0];

  String searchQuery = "";

  Future refreshList() async {
    print("Refreshing News");
    String url =
        'https://inshortsapi.vercel.app/news?category=${categorySelected.toLowerCase()}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List news = body['data']
          .map((news) => News(
              title: news['title'],
              author: news['author'],
              category: categorySelected,
              content: news['content'],
              imageUrl: news['imageUrl'],
              isFavourite: false))
          .toList();

      for (var news in news) {
        dataSource.insertNews(news);
      }
    }
  }

  Future<List<News>> getNewsFromDb() async {
    final result =
        await dataSource.getAllNewsForCategory(categorySelected, searchQuery);

    print("DB News Empty - ${result.isEmpty}");

    if (result.isEmpty) {
      await refreshList();
    }
    return await dataSource.getAllNewsForCategory(
        categorySelected, searchQuery);
  }

  void onQueryChange(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void setCategory(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', index);
    setState(() {
      categorySelected = categories[index];
      // savedCategory?.setInt('selectedCategory', selectedCategory);
      // url =
      //    'https://inshortsapi.vercel.app/news?category=${categories[selectedCategory].toString().toLowerCase()}';
    });
  }

  void getSelectedCategoryIndexFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = await prefs.getInt('selectedIndex') ?? 0;
    categorySelected = categories[index];
  }

  void initState() {
    super.initState();
    getSelectedCategoryIndexFromPref();
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
                  child: Focus(
                    onFocusChange: (hasFocus) {},
                    child: TextField(
                      onChanged: (text) {
                        onQueryChange(text);
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(width: 0.8),
                        ),
                        hintText: 'Search News',
                        prefixIcon: Icon(
                          Icons.search,
                          size: 30.0,
                        ),
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
                                      color:
                                          categorySelected == categories[index]
                                              ? Colors.white
                                              : Colors.blueAccent,
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
                                              color: categorySelected ==
                                                      categories[index]
                                                  ? Colors.blueAccent
                                                  : Colors.white,
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
                      future: getNewsFromDb(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final snapshotData = snapshot.data;
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.572,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshotData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      leading: Image.network(
                                        snapshotData[index].imageUrl,
                                        height: 50.0,
                                        width: 60.0,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                        snapshotData[index].title.toString(),
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
                                                  title: snapshotData[index]
                                                      .title),
                                            ));
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return const Padding(
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

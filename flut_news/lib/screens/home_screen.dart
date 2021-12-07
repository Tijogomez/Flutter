import 'package:flut_news/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'details_page.dart';
import '../data/News.dart';

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

void saveToPref(selectedIndex) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('selectedIndex', selectedIndex);
}

void getSelectedCategoryIndexFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int index = await prefs.getInt('selectedIndex') ?? 0;
  selectedCategory = index;
}

var snapshotData;
List favList = [];
List allNews = [];
List filteredNews = [];
bool _isInSearchMode = false;

SharedPreferences? savedCategory;
int selectedCategory = (savedCategory?.getInt('selectedIndex') ?? 0);

void searchNews(text) {
  if (text.isEmpty) {
    filteredNews.clear();
    return;
  }
  filteredNews.clear();
  filteredNews.addAll(allNews.where((news) => news.title.contains(text)));
}

String url =
    'https://inshortsapi.vercel.app/news?category=${categories[selectedCategory].toString().toLowerCase()}';

Future _fetchApi() async {
  // print(selectedCategory);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    List news = body['data']
        .map((news) => News(
            news['title'], news['author'], news['content'], news['imageUrl']))
        .toList();
    allNews = news;
    return true;
  } else {
    return false;
    // throw Exception('Failed to load');
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> initializePreference() async {
    savedCategory = await SharedPreferences.getInstance();
  }

  void initState() {
    super.initState();
    getSelectedCategoryIndexFromPref();
    // initializePreference().whenComplete(() => setState(() {}));
  }

  void setCategory(int index) {
    setState(() {
      selectedCategory = index;
      url =
          'https://inshortsapi.vercel.app/news?category=${categories[selectedCategory].toString().toLowerCase()}';
      savedCategory?.setInt('selectedCategory', selectedCategory);
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
                  child: Focus(
                    onFocusChange: (hasFocus) {},
                    child: TextField(
                      onChanged: (text) {
                        searchNews(text);
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
                        suffixIcon: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            setState(() {
                              _isInSearchMode = filteredNews.isNotEmpty;
                            });
                          },
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
                                      color: selectedCategory == index
                                          ? Colors.white
                                          : Colors.blueAccent,
                                      child: InkWell(
                                        onTap: () {
                                          saveToPref(index);
                                          setCategory(index);
                                        },
                                        splashColor: Colors.white30,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            categories[index],
                                            style: TextStyle(
                                              color: selectedCategory == index
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
                                itemCount: _isInSearchMode
                                    ? filteredNews.length
                                    : allNews.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      leading: Image.network(
                                        _isInSearchMode
                                            ? filteredNews[index].imageUrl
                                            : allNews[index].imageUrl,
                                        height: 50.0,
                                        width: 60.0,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                        _isInSearchMode
                                            ? filteredNews[index]
                                                .title
                                                .toString()
                                            : allNews[index].title.toString(),
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
                                                  author: _isInSearchMode
                                                      ? filteredNews[index]
                                                          .author
                                                      : allNews[index].author,
                                                  title: _isInSearchMode
                                                      ? filteredNews[index]
                                                          .title
                                                      : allNews[index].title,
                                                  imageUrl: _isInSearchMode
                                                      ? filteredNews[index]
                                                          .imageUrl
                                                      : allNews[index].imageUrl,
                                                  content: _isInSearchMode
                                                      ? filteredNews[index]
                                                          .content
                                                      : allNews[index].content,
                                                  isFavourite: _isInSearchMode
                                                      ? filteredNews[index]
                                                          .isFavourite
                                                      : allNews[index]
                                                          .isFavourite,
                                                  onFavouriteClick:
                                                      ((isFavourite) => {
                                                            allNews[index]
                                                                    .isFavourite =
                                                                isFavourite
                                                          }))),
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

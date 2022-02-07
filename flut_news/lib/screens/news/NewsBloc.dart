// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:flut_news/data/db/NewsDataSource.dart';
import 'package:flut_news/data/model/Bloc.dart';
import 'package:flut_news/data/model/News.dart';
import 'package:flut_news/screens/news/NewsEvents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewsBloc implements Bloc {
  final NewsDataSource dataSource = NewsDataSource();

  final List newsCategories = [
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

  // Selected Category
  final _selectedCategoryController = StreamController<String>();
  Stream<String> get selectedCategory =>
      _selectedCategoryController.stream.asBroadcastStream();

  // Events Stream Controller
  final _eventsController = StreamController<NewsEvents>();
  StreamSink<NewsEvents> get eventsSink => _eventsController.sink;

  final _searchQueryController = StreamController<String>();
  Stream<String> get searchQuery => _searchQueryController.stream;

  // News List
  final _newsController = StreamController<List<News>>();
  Stream<List<News>> get newsList => _newsController.stream;

  NewsBloc() {
    _eventsController.stream.listen((event) {
      _onEvent(event);
    });
  }

  Future _refreshList(String category) async {
    String url =
        'https://inshortsapi.vercel.app/news?category=${category.toLowerCase()}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List news = body['data']
          .map((news) => News(
              title: news['title'],
              author: news['author'],
              category: category,
              content: news['content'],
              imageUrl: news['imageUrl'],
              isFavourite: false))
          .toList();

      for (var news in news) {
        dataSource.insertNews(news);
      }
    }
  }

  void _onEvent(NewsEvents event) {
    if (event is NewsCategoryChanged) {
      _updateCategoryAndAddNews(newsCategories[event.index]);
      _setCategory(event.index);
    } else if (event is SearchQueryChanged) {
      _filterNews(event.query);
    }
  }

  void _updateCategoryAndAddNews(String category) async {
    _selectedCategoryController.sink.add(category);
    _addNews(category, "");
  }

  void _addNews(String category, String query) async {
    var _result = await dataSource.getAllNewsForCategory(category, query);

    if (query.isEmpty && _result.isEmpty) {
      await _refreshList(category);
      _result = await dataSource.getAllNewsForCategory(category, query);
    }
    _newsController.sink.add(_result);
  }

  void _getSelectedCategoryIndexFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = await prefs.getInt('selectedIndex') ?? 0;
    _selectedCategoryController.sink.add(newsCategories[index]);
  }

  void _setCategory(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', index);
  }

  void _filterNews(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentSelectedCategoryIndex = await prefs.getInt('selectedIndex') ?? 0;
    _newsController.sink.add(await dataSource.getAllNewsForCategory(
        newsCategories[currentSelectedCategoryIndex], query));
  }

  void initState() async {
    _getSelectedCategoryIndexFromPref();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = await prefs.getInt('selectedIndex') ?? 0;
    _addNews(newsCategories[index], "");
  }

  @override
  void dispose() {
    _newsController.close();
    _selectedCategoryController.close();
    _eventsController.close();
  }
}

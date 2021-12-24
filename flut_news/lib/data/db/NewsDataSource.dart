import 'package:flut_news/data/db/NewsDatabase.dart';
import 'package:sqflite/sqflite.dart';

import '../model/News.dart';

class NewsDataSource {
  Future<List<News>> getAllNewsForCategory(
      String category, String query) async {
    final Database db = await FlutNewsDatabase.instance.database;

    final result = await db.query(NewsTableName,
        columns: NewsColumns,
        where: 'category = ? AND title LIKE ?',
        whereArgs: [category, '%$query%']);

    return result.map((newsEntitiy) => News.fromJson(newsEntitiy)).toList();
  }

  Future insertNews(News news) async {
    final Database db = await FlutNewsDatabase.instance.database;

    await db.insert(NewsTableName, news.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<News>> getFavourites() async {
    final db = await FlutNewsDatabase.instance.database;

    final result = await db.query(NewsTableName,
        columns: NewsColumns, where: 'isFavourite = ?', whereArgs: [1]);

    return result.map((news) => News.fromJson(news)).toList();
  }

  Future updateNewsFavourite(String title, bool isFavourite) async {
    final db = await FlutNewsDatabase.instance.database;

    await db.rawUpdate(
        "UPDATE $NewsTableName SET isFavourite = ? WHERE title LIKE ?",
        [isFavourite, title]);
  }

  Future<News> getNewsByTitle(String title) async {
    final db = await FlutNewsDatabase.instance.database;

    final result = await db.query(NewsTableName,
        columns: NewsColumns, where: 'title LIKE ?', whereArgs: [title]);

    return News.fromJson(result.first);
  }

  Future deleteAll() async {
    final db = await FlutNewsDatabase.instance.database;

    await db.rawDelete("DELETE FROM $NewsTableName");
  }
}

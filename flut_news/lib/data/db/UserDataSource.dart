import 'package:flut_news/data/db/NewsDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../model/User.dart';

class UserDataSource {
  String url = 'https://randomuser.me/api/';

  static User? loggedInUser = null;

  Future _getUserFromApi() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future createUser(String username, String password, String? email) async {
    final Database db = await FlutNewsDatabase.instance.database;

    final apiResult = await _getUserFromApi();

    final userFromApi = apiResult['results'][0];
    final user = User(
        username: username,
        password: password,
        email: email,
        imageUrl: userFromApi['picture']['large']);

    await db.insert(UserTableName, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> authenticate(String username, String password) async {
    final Database db = await FlutNewsDatabase.instance.database;

    final result = await db.query(UserTableName,
        columns: UserColumns,
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);

    if (result.isNotEmpty) {
      loggedInUser = User.fromJson(result[0]);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateUserPassword(String username, String newPassword) async {
    final Database db = await FlutNewsDatabase.instance.database;

    try {
      await db.rawUpdate(
          "UPDATE $UserTableName SET password = ? WHERE username = ?",
          [newPassword, username]);
      return true;
    } catch (e) {
      return false;
    }
  }
}

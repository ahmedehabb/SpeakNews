import 'dart:io';

import 'package:newssnap/articles_screen/model/cnn_article_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'bookmark.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE bookmarked_articles (
        _id TEXT PRIMARY KEY,
        headline TEXT,
        body TEXT,
        byLine TEXT,
        url TEXT,
        thumbnail TEXT,
        lastPublishDate TEXT
      )''');
  }

  Future<List<CnnArticleModel>> getBookmarkedArticles() async {
    final db = await database;
    var bookmarks = await db.query("bookmarked_articles");
    List<CnnArticleModel> articlesList = bookmarks.isEmpty
        ? []
        : bookmarks.map((entry) => CnnArticleModel.fromJson(entry)).toList();
    return articlesList;
  }

  Future<int> addBookmark(CnnArticleModel article) async {
    final db = await instance.database;
    return await db.insert("bookmarked_articles", article.toJson());
  }

  Future<int> removeBookmark(CnnArticleModel article) async {
    final db = await instance.database;
    return await db.delete("bookmarked_articles",
        where: "_id = ?", whereArgs: [article.id]);
  }
}

// lib/data/app_database.dart

import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, 'dangguide.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
      // 버전 변경시 onUpgrade 사용 가능
    );
  }

  static FutureOr<void> _onCreate(Database db, int version) async {
    // 품종 테이블 생성
    await db.execute('''
      CREATE TABLE dog_breeds (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        bred_for TEXT,
        breed_group TEXT,
        life_span TEXT,
        temperament TEXT,
        origin TEXT,
        weight_metric TEXT,
        height_metric TEXT,
        image_url TEXT
      )
    ''');

    // 필요하면 다른 테이블도 여기에 추가
  }
}

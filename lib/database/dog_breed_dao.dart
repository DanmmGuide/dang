// lib/data/dog_breed_dao.dart

import 'package:sqflite/sqflite.dart';
import '../models/dog_breed.dart';
import 'app_database.dart';

class DogBreedDao {
  static const String tableName = 'dog_breeds';

  Future<Database> get _db async => AppDatabase.database;

  Future<List<DogBreed>> getAllBreeds() async {
    final db = await _db;
    final maps = await db.query(tableName);

    return maps.map((m) {
      return DogBreed(
        id: m['id'] as int,
        name: m['name'] as String,
        bredFor: m['bred_for'] as String?,
        breedGroup: m['breed_group'] as String?,
        lifeSpan: m['life_span'] as String?,
        temperament: m['temperament'] as String?,
        origin: m['origin'] as String?,
        weightMetric: m['weight_metric'] as String?,
        heightMetric: m['height_metric'] as String?,
        imageUrl: m['image_url'] as String?,
      );
    }).toList();
  }

  Future<void> insertBreeds(List<DogBreed> breeds) async {
    final db = await _db;
    final batch = db.batch();

    for (final b in breeds) {
      batch.insert(
        tableName,
        {
          'id': b.id,
          'name': b.name,
          'bred_for': b.bredFor,
          'breed_group': b.breedGroup,
          'life_span': b.lifeSpan,
          'temperament': b.temperament,
          'origin': b.origin,
          'weight_metric': b.weightMetric,
          'height_metric': b.heightMetric,
          'image_url': b.imageUrl,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> clearAll() async {
    final db = await _db;
    await db.delete(tableName);
  }

  Future<void> replaceAll(List<DogBreed> breeds) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete(tableName);
      final batch = txn.batch();
      for (final b in breeds) {
        batch.insert(
          tableName,
          {
            'id': b.id,
            'name': b.name,
            'bred_for': b.bredFor,
            'breed_group': b.breedGroup,
            'life_span': b.lifeSpan,
            'temperament': b.temperament,
            'origin': b.origin,
            'weight_metric': b.weightMetric,
            'height_metric': b.heightMetric,
            'image_url': b.imageUrl,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }
}

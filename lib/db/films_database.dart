import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ets_ppb/model/film.dart';

class FilmsDatabase {
  static final FilmsDatabase instance = FilmsDatabase._init();

  static Database? _database;

  FilmsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('films.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableFilms (
      ${FilmFields.id} $idType,
      ${FilmFields.title} $textType,
      ${FilmFields.number} $integerType,
      ${FilmFields.coverLink} $textType,
      ${FilmFields.description} $textType,
      ${FilmFields.createdTime} $textType
      )
      ''');
  }

  Future<Film> create(Film film) async {
    final db = await instance.database;

    final id = await db.insert(tableFilms, film.toJson());
    return film.copy(id: id);
  }

  void insertDummyFilm() async {
    Film dummyFilm = Film(
      number: 1,
      id: 0, // This will be auto-incremented by the database
      title: 'Kono Subarashii Sekai ni Shukufuku wo! 3',
      coverLink: 'https://cdn.myanimelist.net/images/anime/1758/141268.jpg',
      description: 'Third season of Kono Subarashii Sekai ni Shukufuku wo!.',
      createdTime: DateTime.now(),
    );

    await create(dummyFilm);
  }

  Future<Film> readFilm(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFilms,
      columns: FilmFields.values,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Film.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Film>> readAllFilms() async {
    final db = await instance.database;

    final result = await db.query(tableFilms);

    return result.map((json) => Film.fromJson(json)).toList();
  }

  Future<int> update(Film film) async {
    final db = await instance.database;

    return db.update(
      tableFilms,
      film.toJson(),
      where: '${FilmFields.id} = ?',
      whereArgs: [film.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableFilms,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
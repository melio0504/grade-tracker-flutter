import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  // Store the current logged in user
  Map<String, dynamic>? currentUser;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'student_grade_tracker.db');
    return await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT UNIQUE,
        password TEXT,
        profileImage TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE subjects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        overallGrade REAL,
        terminalAssessment REAL,
        assignments REAL,
        activity REAL,
        imageUrl TEXT,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
    await _createActivitiesTable(db, version);
  }

  Future<void> _createActivitiesTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subjectId INTEGER,
        name TEXT,
        description TEXT,
        grade REAL,
        isCompleted INTEGER,
        dueDate TEXT,
        type TEXT,
        FOREIGN KEY (subjectId) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE subjects(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          title TEXT,
          overallGrade REAL,
          terminalAssessment REAL,
          assignments REAL,
          activity REAL,
          FOREIGN KEY (userId) REFERENCES users (id)
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE subjects ADD COLUMN imageUrl TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE users ADD COLUMN profileImage TEXT');
    }
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE activities(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          subjectId INTEGER,
          name TEXT,
          description TEXT,
          grade REAL,
          isCompleted INTEGER,
          dueDate TEXT,
          FOREIGN KEY (subjectId) REFERENCES subjects (id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('ALTER TABLE activities ADD COLUMN type TEXT');
    }
  }

  Future<int> registerUser(String username, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      currentUser = results.first;
      await _saveUserSession(currentUser!['id']);
      return results.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> _saveUserSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    currentUser = null;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final db = await database;
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (results.isNotEmpty) {
        currentUser = results.first;
        return true;
      }
    }
    return false;
  }

  Future<void> updateProfileImage(int userId, String imagePath) async {
    final db = await database;
    await db.update(
      'users',
      {'profileImage': imagePath},
      where: 'id = ?',
      whereArgs: [userId],
    );
    // Refresh currentUser with new data
    if (currentUser != null && currentUser!['id'] == userId) {
      List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (results.isNotEmpty) {
        currentUser = results.first;
      }
    }
  }

  Future<List<Map<String, dynamic>>> getSubjects(int userId) async {
    final db = await database;
    return await db.query('subjects', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<int> addSubject(Map<String, dynamic> subject) async {
    final db = await database;
    return await db.insert('subjects', subject);
  }

  Future<int> updateSubject(int id, Map<String, dynamic> subject) async {
    final db = await database;
    return await db.update('subjects', subject, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSubject(int id) async {
    final db = await database;
    return await db.delete('subjects', where: 'id = ?', whereArgs: [id]);
  }

  // Activities methods
  Future<List<Map<String, dynamic>>> getActivities(int subjectId) async {
    final db = await database;
    return await db.query('activities', where: 'subjectId = ?', whereArgs: [subjectId]);
  }

  Future<List<Map<String, dynamic>>> getAllUserActivities(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT activities.* FROM activities
      JOIN subjects ON activities.subjectId = subjects.id
      WHERE subjects.userId = ?
    ''', [userId]);
  }

  Future<int> addActivity(Map<String, dynamic> activity) async {
    final db = await database;
    return await db.insert('activities', activity);
  }

  Future<int> updateActivity(int id, Map<String, dynamic> activity) async {
    final db = await database;
    return await db.update('activities', activity, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int userId) async {
    final db = await database;
    // Delete subjects first (activities will cascade if subjects are deleted)
    await db.delete('subjects', where: 'userId = ?', whereArgs: [userId]);
    return await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }
}

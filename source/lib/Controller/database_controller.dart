import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class ChatDatabase {
  static final ChatDatabase instance = ChatDatabase._init();
  static Database? _database;

  ChatDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quark_ultimate_v1.db'); 
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        header TEXT NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        isSaved INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionId INTEGER,
        text TEXT NOT NULL,
        isUser INTEGER,
        FOREIGN KEY (sessionId) REFERENCES sessions (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE usage_limit (
        date TEXT PRIMARY KEY,
        count INTEGER DEFAULT 0
      )
    ''');
  }

  // --- Daily Prompt Methods ---

  Future<int> getTodayPromptCount() async {
    final db = await instance.database;
    final String today = DateTime.now().toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'usage_limit',
      where: 'date = ?',
      whereArgs: [today],
    );
    return maps.isEmpty ? 0 : maps.first['count'] as int;
  }

  Future<void> incrementPromptCount() async {
    final db = await instance.database;
    final String today = DateTime.now().toIso8601String().split('T')[0];
    await db.rawInsert('''
      INSERT INTO usage_limit(date, count) VALUES(?, 1)
      ON CONFLICT(date) DO UPDATE SET count = count + 1
    ''', [today]);
  }

  // --- Corrected Session Methods ---

  Future<int> createSession(String firstPrompt) async {
    final db = await instance.database;
    return await db.insert('sessions', {'header': firstPrompt});
  }

  /// Corrected for Dashboard: Uses the actual column names 'id' and 'timestamp'
  Future<List<Map<String, dynamic>>> getRecentSessions(int limit) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      'sessions',
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    // Map the 'id' to 'session_id' so the Dashboard UI doesn't break
    return result.map((row) {
      var n = Map<String, dynamic>.from(row);
      n['session_id'] = row['id']; 
      return n;
    }).toList();
  }

  /// Corrected for Saved Chats: Queries 'sessions' table where isSaved = 1
  Future<List<Map<String, dynamic>>> getAllSavedSessions() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      'sessions',
      where: 'isSaved = ?',
      whereArgs: [1],
      orderBy: 'timestamp DESC',
    );

    // Map internal 'id' and 'timestamp' to match what your UI expects
    return result.map((row) {
      var n = Map<String, dynamic>.from(row);
      n['session_id'] = row['id'];
      n['last_active'] = row['timestamp'];
      return n;
    }).toList();
  }

  Future<void> toggleSave(int sessionId, bool isSaved) async {
    final db = await instance.database;
    await db.update('sessions', {'isSaved': isSaved ? 1 : 0}, 
      where: 'id = ?', whereArgs: [sessionId]);
  }

  Future<void> insertMessage(int sessionId, String text, bool isUser) async {
    final db = await instance.database;
    await db.insert('messages', {
      'sessionId': sessionId,
      'text': text,
      'isUser': isUser ? 1 : 0,
    });
  }

  Future<int> deleteSession(int sessionId) async {
    final db = await instance.database;
    // This will delete messages too because of ON DELETE CASCADE
    return await db.delete('sessions', where: 'id = ?', whereArgs: [sessionId]);
  }
}
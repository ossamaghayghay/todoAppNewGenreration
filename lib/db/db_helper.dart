import 'package:sqflite/sqflite.dart';
import '/models/task.dart';

class DBHelper {
  static Database? db;
  static const int version = 1;
  static const String tabelName = 'tasks';

  static Future<void> initDb() async {
    if (db != null) {
      print('not null db');
      return;
    } else {
      try {
        // String path = await getDatabasesPath() + 'task.db';
        // var pathdataBase = await getDatabasesPath();
        // String path2 = await join(pathdataBase, 'task,db');
        db = await openDatabase('task.db', version: version,
            onCreate: (Database db, int version) async {
          print('Create New One!!');
          await db.execute(
              'CREATE TABLE $tabelName(id INTEGER PRIMARY KEY AUTOINCREMENT,title STRING,note TEXT,date STRING,startTime STRING,endTime STRING,remind INTEGER,repeat STRING ,color INTEGER,isCompleted INTEGER)');
        });
        print('DataBase Has Been Created!!');
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task task) async {
    print('insert Function Called');
    return await db!.insert(tabelName, task.toJson());
  }

  static Future<int> delete(Task task) async {
    print('delete Function Called');
    return await db!.delete(tabelName, where: 'id = ?', whereArgs: [task.id]);
  }
  static Future<int> deleteAll(Task task) async {
    print('delete All Function Called');
    return await db!.delete(tabelName);
  }
 
  static Future<int> update(int id) async {
    print('Update Function Called ');
    return await db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted=?
      WHERE id=?''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query2() async {
    print('Query Function Called');
    return await db!.query(tabelName);
  }
}

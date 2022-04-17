import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask(Task task) {
    return DBHelper.insert(task);
  }

// ::::::::::::::::::::::This it use to Get Data from database::::::::::::::::::
  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query2();
    taskList.assignAll(tasks.map((items) => Task.fromJson(items)).toList());
  }
// ::::::::::::::::::::::This it use to Get delete Data from database::::::::::::::::::

  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }
   void deleteAllTasks() async {
    DBHelper.deleteAll;
    getTasks();
  }

// ::::::::::::::::::::::This it use to Get Update from database::::::::::::::::::
  void changeStateCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
                                    
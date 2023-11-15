import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'task_creation_screen.dart';
import 'task_editing_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<ParseObject> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..orderByAscending('done')
      ..orderByAscending('createdAt');

    final where = Uri.encodeComponent('{}');
    final orderBy = Uri.encodeComponent('dueDate');

    final url = 'https://parseapi.back4app.com/parse/classes/Task?where=$where&order=$orderBy';

    final response = await query.query();
    if (response.success) {
      setState(() {
        tasks = response.results as List<ParseObject>;
      });
    } else {
      print('Error fetching tasks: ${response.error?.message}');
    }
  }


  void refreshTaskList() {
    _fetchTasks();
  }

  void _showTaskDetailsDialog(ParseObject task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.get('title')),
          content: Text(task.get('description')),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                task.set('done', !task.get('done'));
                await task.save();
                refreshTaskList();
              },
              child: Text(
                task.get('done') ? 'To Do' : 'Done',
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF800080),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskEditingScreen(task: task, onTaskUpdated: (taskUpdated) {
                      if (taskUpdated) {
                        refreshTaskList();
                      }
                    }),
                  ),
                );
              },
              child: Text('Edit'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF800080),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final ParseResponse response = await task.delete();
                if (response.success) {
                  refreshTaskList();
                } else {
                  print('Error deleting task: ${response.error?.message}');
                }
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF800080),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taskify!', style: TextStyle(fontSize: 30)),
        backgroundColor: Color(0xFF9370DB),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundImg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  MediaQuery.of(context).size.height * 0.05,
                  MediaQuery.of(context).size.width * 0.1,
                  MediaQuery.of(context).size.height * 0.02,
                ),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: task.get('done') == true ? Colors.black26 : Colors.white70,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(
                            task.get('title'),
                            style: task.get('done') == true
                                ? TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2.0,
                            )
                                : TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            task.get('description'),
                            style: task.get('done') == true
                                ? TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2.0,
                            )
                                : TextStyle(fontSize: 16),
                          ),
                          trailing: Text(
                            task.get('dueDate').toString().split(" ").first,
                            style: task.get('done') == true
                                ? TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2.0,
                            )
                                : TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            _showTaskDetailsDialog(task);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskCreationScreen(
                        onTaskAdded: (taskAdded) {
                          if (taskAdded) {
                            refreshTaskList();
                          }
                        },
                      ),
                    ),
                  );
                },
                child: const Text('New Task', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF800080),
                  padding: EdgeInsets.all(16.0),
                  minimumSize: Size(150, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

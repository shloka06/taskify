import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TaskCreationScreen extends StatelessWidget {
  final void Function(bool) onTaskAdded;

  TaskCreationScreen({required this.onTaskAdded});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF9370DB),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              colorScheme: ColorScheme.light(primary: Color(0xFF800080)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      dueDateController.text = picked.toLocal().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task', style: TextStyle(fontSize: 24)),
        backgroundColor: Color(0xFF9370DB),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundImg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.05,
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: titleController,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: descriptionController,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  labelStyle: TextStyle(fontSize: 18),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: dueDateController,
                style: TextStyle(fontSize: 18),
                onTap: () {
                  _selectDueDate(context);
                },
              ),
              SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    String title = titleController.text;
                    String description = descriptionController.text;

                    if (title.isEmpty || description.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Title and description cannot be empty.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      final ParseObject newTask = ParseObject('Task')
                        ..set('title', title)
                        ..set('description', description)
                        ..set('done', false);

                      if (dueDateController.text.isNotEmpty) {
                        DateTime pickedDate = DateTime.parse(dueDateController.text).add(Duration(days: 1));
                        newTask.set<DateTime>('dueDate', pickedDate);
                      }

                      final response = await newTask.save();

                      if (response.success) {
                        onTaskAdded(true);
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Failed to save the task. Please try again.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text('Add Task', style: TextStyle(fontSize: 18)),
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
      ),
    );
  }
}

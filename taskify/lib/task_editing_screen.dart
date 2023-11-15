import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TaskEditingScreen extends StatefulWidget {
  final ParseObject task;
  final ValueChanged<bool> onTaskUpdated;

  TaskEditingScreen({required this.task, required this.onTaskUpdated});

  @override
  _TaskEditingScreenState createState() => _TaskEditingScreenState();
}

class _TaskEditingScreenState extends State<TaskEditingScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.get('title'));
    descriptionController = TextEditingController(text: widget.task.get('description'));
    dueDateController = TextEditingController(text: widget.task.get('dueDate').toString().split(" ").first);
  }

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
      dueDateController.text = picked.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task', style: TextStyle(fontSize: 30)),
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
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(fontSize: 20),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(fontSize: 20),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: dueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  labelStyle: TextStyle(fontSize: 20),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontSize: 20),
                onTap: () {
                  _selectDueDate(context);
                },
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    final String newTitle = titleController.text;
                    final String newDescription = descriptionController.text;
                    final String newDueDate = dueDateController.text;

                    widget.task.set('title', newTitle);
                    widget.task.set('description', newDescription);
                    widget.task.set('dueDate', DateTime.parse(newDueDate).add(Duration(days: 1)));

                    final ParseResponse response = await widget.task.save();

                    if (response.success) {
                      widget.onTaskUpdated(true);

                      Navigator.pop(context);
                    } else {
                      print('Error updating task: ${response.error?.message}');
                    }
                  },
                  child: const Text('Update Task', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF800080),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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

class Task {
  String title;
  String description;
  bool done;
  DateTime duedate = DateTime.timestamp();

  Task({required this.title, required this.description, required this.done, required this.duedate});
}
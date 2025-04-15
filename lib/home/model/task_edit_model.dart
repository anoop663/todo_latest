class TaskModel {
  final String title;
  final String description;
  final String dueDate;
  final bool isDone;

  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isDone': isDone,
    };
  }
}

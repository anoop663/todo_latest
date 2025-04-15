class TodoModel {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final bool isDone;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isDone,
  });

  factory TodoModel.fromMap(String id, Map<String, dynamic> data) {
    return TodoModel(
      id: id,
      title: data['title'],
      description: data['description'],
      dueDate: data['dueDate'],
      isDone: data['isDone'] ?? false,
    );
  }
}

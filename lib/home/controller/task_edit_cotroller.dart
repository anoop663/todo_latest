// controllers/edit_task_provider.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_application_1/home/model/add_task_model.dart';

class EditTaskProvider with ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  void initialize({
    required String title,
    required String description,
    required String dueDate,
  }) {
    titleController.text = title;
    descriptionController.text = description;
    selectedDate = DateFormat('yyyy-MM-dd').parse(dueDate);
  }

  String? get formattedDate =>
      selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : null;

  bool get isFormValid =>
      titleController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      selectedDate != null;

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  TaskModel updateTask() {
    return TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      dueDate: formattedDate!,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

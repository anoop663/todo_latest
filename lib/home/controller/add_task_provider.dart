// controllers/add_task_provider.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_application_1/home/model/add_task_model.dart';

class AddTaskProvider with ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;

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

  TaskModel createTask() {
    return TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      dueDate: formattedDate!,
    );
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedDate = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

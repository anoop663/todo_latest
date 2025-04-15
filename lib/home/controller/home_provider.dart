import 'package:flutter/material.dart';
import 'package:to_do_application_1/home/model/home_model.dart';
import '../controller/home_controller.dart';

class TodoProvider with ChangeNotifier {
  final _controller = HomeController();
  List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  void fetchTodos() {
    _controller.getTodosStream().listen((event) {
      _todos = event;
      notifyListeners();
    });
  }

  Future<void> addTodo(Map<String, dynamic> data) async {
    await _controller.addTodo(data);
  }

  Future<void> updateTodo(String id, Map<String, dynamic> data) async {
    await _controller.updateTodo(id, data);
  }

  Future<void> deleteTodo(String id) async {
    await _controller.deleteTodo(id);
  }

  Future<void> toggleDone(String id, bool value) async {
    await _controller.toggleDone(id, value);
  }
}

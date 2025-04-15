// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_application_1/home/controller/home_provider.dart';
import 'package:to_do_application_1/home/view/add_task.dart';
import 'package:to_do_application_1/home/view/edit_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<TodoProvider>(context, listen: false).fetchTodos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _navigateToAddTask() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskPage()),
    );

    if (newTask != null && newTask is Map<String, dynamic>) {
      await Provider.of<TodoProvider>(context, listen: false).addTodo(newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<TodoProvider>(context).todos;
    final filteredTodos = _searchQuery.isEmpty
        ? todos
        : todos.where((todo) =>
            todo.title.toLowerCase().contains(_searchQuery) ||
            todo.description.toLowerCase().contains(_searchQuery)
        ).toList();

    final pendingCount = filteredTodos.where((t) => !t.isDone).length;
    final completedCount = filteredTodos.where((t) => t.isDone).length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text('My Tasks', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statusCounter('Pending', pendingCount),
                _statusCounter('Completed', completedCount),
              ],
            ),
            Expanded(
              child: filteredTodos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/list_custom.png',
                            width: 100,
                            height: 100,
                            color: const Color.fromARGB(255, 83, 82, 82),
                          ),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'You don’t have any tasks yet.\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 130, 129, 129),
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Start adding tasks and manage your time effectively.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 111, 110, 110),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (_, index) {
                        final todo = filteredTodos[index];
                        return Card(
                          color: const Color(0xFF303030),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Checkbox(
                              value: todo.isDone,
                              onChanged: (value) {
                                Provider.of<TodoProvider>(context,
                                        listen: false)
                                    .toggleDone(todo.id, value!);
                              },
                              activeColor: const Color(0xFF1E6F9F),
                              checkColor: Colors.white,
                              shape: const CircleBorder(),
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                color: Colors.white,
                                decoration: todo.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: Colors.white,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todo.description,
                                  style: TextStyle(
                                    color: Colors.white60,
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Due: ${todo.dueDate}',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.384),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Image.asset(
                                    'assets/icons/edit.png',
                                    width: 25,
                                    height: 25,
                                    color: const Color.fromARGB(
                                        255, 204, 200, 200),
                                  ),
                                  onPressed: () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditTaskPage(
                                          taskId: todo.id,
                                          initialTitle: todo.title,
                                          initialDescription: todo.description,
                                          initialDueDate: todo.dueDate,
                                        ),
                                      ),
                                    );
                                    if (updated != null &&
                                        updated is Map<String, dynamic>) {
                                      Provider.of<TodoProvider>(context,
                                              listen: false)
                                          .updateTodo(todo.id, updated);
                                    }
                                  },
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Image.asset(
                                    'assets/icons/delete.png',
                                    width: 21,
                                    height: 21,
                                    color: const Color.fromARGB(
                                        255, 204, 200, 200),
                                  ),
                                  onPressed: () {
                                    Provider.of<TodoProvider>(context,
                                            listen: false)
                                        .deleteTodo(todo.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCounter(String label, int count) {
    return Row(
      children: [
        Text('$label: ',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('$count', style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase(); // to make it case-insensitive
                });
              },
              decoration: const InputDecoration(
                hintText: '🚀 Search...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _navigateToAddTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E6F9F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Row(
            children: [
              Text('Add', style: TextStyle(color: Colors.white)),
              SizedBox(width: 6),
              Icon(Icons.add_circle_outline, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}

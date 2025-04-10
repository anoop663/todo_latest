// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application_1/home/view/add_task.dart';
import 'package:to_do_application_1/home/view/edit_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _navigateToAddTask() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskPage(),
      ),
    );

    if (newTask != null && newTask is Map<String, dynamic>) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('todos')
          .add(newTask);
      setState(() {}); // Refresh UI
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 13, 13, 1),
        title: const Text('My Tasks', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('todos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'title': data['title'],
              'description': data['description'],
              'dueDate': data['dueDate'],
              'isDone': data['isDone'],
            };
          }).toList();

          final pendingCount = todos.where((t) => t['isDone'] == false).length;
          final completedCount = todos.where((t) => t['isDone'] == true).length;

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: screenHeight * 0.2,
                    color: const Color.fromRGBO(13, 13, 13, 1),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color.fromRGBO(26, 26, 26, 1),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: screenHeight * 0.2 - 20,
                left: 16,
                right: 16,
                bottom: 0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(38, 38, 38, 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: '🚀 Search...',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _navigateToAddTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(30, 111, 159, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Add',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              SizedBox(width: 6),
                              Icon(Icons.add_circle_outline,
                                  size: 22, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statusCounter('Pending', pendingCount),
                        _statusCounter('Completed', completedCount),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return Card(
                            color: const Color.fromRGBO(48, 48, 48, 1),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Checkbox(
                                value: todo['isDone'],
                                onChanged: (value) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .collection('todos')
                                      .doc(todo['id'])
                                      .update({'isDone': value});
                                },
                                activeColor:
                                    const Color.fromRGBO(30, 111, 159, 1),
                                checkColor: Colors.white,
                                shape: const CircleBorder(),
                              ),
                              title: Text(todo['title'],
                                  style:
                                      const TextStyle(color: Colors.white)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(todo['description'],
                                      style: const TextStyle(
                                          color: Colors.white60)),
                                  Text('Due: ${todo['dueDate']}',
                                      style: const TextStyle(
                                          color: Colors.white38)),
                                ],
                              ),
                              trailing: Wrap(
                                spacing: -20,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.grey),
                                    onPressed: () async {
                                      final updatedTask = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditTaskPage(
                                            taskId: todo['id'],
                                            title: todo['title'],
                                            description: todo['description'],
                                            dueDate: todo['dueDate'], initialTitle: 'no', initialDescription: '', initialDueDate: '',
                                          ),
                                        ),
                                      );

                                      if (updatedTask != null &&
                                          updatedTask
                                              is Map<String, dynamic>) {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .collection('todos')
                                            .doc(todo['id'])
                                            .update(updatedTask);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.grey),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user!.uid)
                                          .collection('todos')
                                          .doc(todo['id'])
                                          .delete();
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
            ],
          );
        },
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
            color: const Color.fromRGBO(38, 38, 38, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('$count',
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

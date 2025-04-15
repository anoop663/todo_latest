import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_application_1/home/model/home_model.dart';

class HomeController {
  final user = FirebaseAuth.instance.currentUser;

  Stream<List<TodoModel>> getTodosStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('todos')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return TodoModel.fromMap(doc.id, doc.data());
            }).toList());
  }

  Future<void> addTodo(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('todos')
        .add(data);
  }

  Future<void> updateTodo(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('todos')
        .doc(id)
        .update(data);
  }

  Future<void> deleteTodo(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('todos')
        .doc(id)
        .delete();
  }

  Future<void> toggleDone(String id, bool value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('todos')
        .doc(id)
        .update({'isDone': value});
  }
}

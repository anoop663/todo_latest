// views/add_task_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application_1/home/controller/add_task_provider.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTaskProvider(),
      child: const _AddTaskView(),
    );
  }
}

class _AddTaskView extends StatelessWidget {
  const _AddTaskView();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddTaskProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 13, 13, 1),
        title: const Text('Add Task'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField('Task Title', provider.titleController),
            const SizedBox(height: 16),
            _buildTextField('Description', provider.descriptionController),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(38, 38, 38, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  provider.formattedDate ?? 'Select Due Date',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: provider.isFormValid
                  ? () {
                      final task = provider.createTask();
                      Navigator.pop(context, task.toMap());
                      provider.clearForm();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(30, 111, 159, 1),
                disabledBackgroundColor: Colors.grey,
              ),
              child: const Text('Save Task',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color.fromRGBO(38, 38, 38, 1),
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _pickDate(BuildContext context) async {
    final provider = Provider.of<AddTaskProvider>(context, listen: false);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
                primary: Color.fromRGBO(30, 111, 159, 1)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      provider.setDate(picked);
    }
  }
}

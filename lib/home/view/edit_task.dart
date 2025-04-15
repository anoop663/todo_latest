// views/edit_task_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application_1/home/controller/task_edit_cotroller.dart';


class EditTaskPage extends StatelessWidget {
  final String taskId;
  final String initialTitle;
  final String initialDescription;
  final String initialDueDate;

  const EditTaskPage({
    super.key,
    required this.taskId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialDueDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditTaskProvider()
        ..initialize(
          title: initialTitle,
          description: initialDescription,
          dueDate: initialDueDate,
        ),
      child: const _EditTaskView(),
    );
  }
}

class _EditTaskView extends StatelessWidget {
  const _EditTaskView();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditTaskProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 13, 13, 1),
        title: const Text('Edit Task'),
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
                      final task = provider.updateTask();
                      Navigator.pop(context, task.toMap());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(30, 111, 159, 1),
                disabledBackgroundColor: Colors.grey,
              ),
              child: const Text('Update Task',
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
    final provider = Provider.of<EditTaskProvider>(context, listen: false);
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromRGBO(30, 111, 159, 1),
            ),
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

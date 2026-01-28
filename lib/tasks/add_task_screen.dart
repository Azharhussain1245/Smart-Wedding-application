// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/notification_service.dart';


// class AddTaskScreen extends StatefulWidget {
//   const AddTaskScreen({super.key});

//   @override
//   State<AddTaskScreen> createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final titleController = TextEditingController();
//   DateTime? selectedDate;

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );

//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _saveTask() async {
//     if (titleController.text.isEmpty || selectedDate == null) return;

//     final userId = FirebaseAuth.instance.currentUser!.uid;

//     await FirebaseFirestore.instance
//         .collection('tasks')
//         .doc(userId)
//         .collection('items')
//         .add({
//       'title': titleController.text.trim(),
//       'date':
//           '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
//       'isDone': false,
//       'createdAt': Timestamp.now(),
//     });

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Task'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Task Title',
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Text(
//                   selectedDate == null
//                       ? 'No date selected'
//                       : 'Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
//                 ),
//                 const Spacer(),
//                 TextButton(
//                   onPressed: _pickDate,
//                   child: const Text('Pick Date'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _saveTask,
//               child: const Text('Save Task'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (titleController.text.isEmpty || selectedDate == null) return;

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('items')
        .add({
      'title': titleController.text.trim(),
      'date': Timestamp.fromDate(selectedDate!),
      'isDone': false,
      'createdAt': Timestamp.now(),
    });

    // 🔔 Schedule notification at 9:00 AM on task date
    final notificationDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      9,
      0,
    );

    await NotificationService.scheduleTaskNotification(
      id: docRef.id.hashCode,
      title: titleController.text.trim(),
      scheduledDate: notificationDate,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? 'No date selected'
                      : 'Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                ),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}

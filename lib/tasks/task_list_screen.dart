// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({super.key});

//   @override
//   State<TaskListScreen> createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<TaskListScreen> {
//   bool _reminderShown = false;

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//     final today =
//         DateTime.now().toIso8601String().substring(0, 10);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wedding Tasks'),
//         backgroundColor: Colors.pinkAccent,
//       ),

//       // ➕ ADD TASK
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.pinkAccent,
//         child: const Icon(Icons.add),
//         onPressed: () {
//           _showAddTaskBottomSheet(context, userId);
//         },
//       ),

//       body: Column(
//         children: [
//           // 🔔 USER TIP
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             color: Colors.pinkAccent.withOpacity(0.1),
//             child: Row(
//               children: const [
//                 Icon(Icons.info_outline,
//                     color: Colors.pinkAccent),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Tip: Swipe a task to delete it.',
//                     style: TextStyle(
//                       color: Colors.pinkAccent,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 📋 TASK LIST
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('tasks')
//                   .doc(userId)
//                   .collection('items')
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                       child: CircularProgressIndicator());
//                 }

//                 final tasks = snapshot.data!.docs;

//                 // 🔔 SHOW REMINDER ONCE (TODAY TASK)
//                 if (!_reminderShown) {
//                   final hasTodayTask = tasks.any(
//                     (doc) => doc['date'] == today,
//                   );

//                   if (hasTodayTask) {
//                     WidgetsBinding.instance
//                         .addPostFrameCallback((_) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             '🔔 You have tasks due TODAY!',
//                           ),
//                           backgroundColor: Colors.pinkAccent,
//                         ),
//                       );
//                     });
//                     _reminderShown = true;
//                   }
//                 }

//                 if (tasks.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'No tasks yet.\nTap + to add one.',
//                       textAlign: TextAlign.center,
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: tasks.length,
//                   itemBuilder: (context, index) {
//                     final task = tasks[index];
//                     final taskId = task.id;
//                     final isToday = task['date'] == today;

//                     return Dismissible(
//                       key: ValueKey(taskId),
//                       background: _deleteBackground(),
//                       onDismissed: (_) async {
//                         await FirebaseFirestore.instance
//                             .collection('tasks')
//                             .doc(userId)
//                             .collection('items')
//                             .doc(taskId)
//                             .delete();

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Task deleted'),
//                             backgroundColor: Colors.redAccent,
//                           ),
//                         );
//                       },
//                       child: Card(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         child: ListTile(
//                           leading: Icon(
//                             Icons.check_circle_outline,
//                             color: isToday
//                                 ? Colors.redAccent
//                                 : Colors.pinkAccent,
//                           ),
//                           title: Text(task['title']),
//                           subtitle: Text(
//                             'Due: ${task['date']}',
//                           ),
//                           trailing: isToday
//                               ? Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: Colors.redAccent,
//                                     borderRadius:
//                                         BorderRadius.circular(12),
//                                   ),
//                                   child: const Text(
//                                     'TODAY',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 )
//                               : null,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🔴 DELETE BACKGROUND
//   Widget _deleteBackground() {
//     return Container(
//       color: Colors.redAccent,
//       alignment: Alignment.center,
//       child: const Icon(Icons.delete,
//           color: Colors.white, size: 30),
//     );
//   }

//   // ➕ ADD TASK BOTTOM SHEET
//   void _showAddTaskBottomSheet(
//       BuildContext context, String userId) {
//     final titleController = TextEditingController();
//     DateTime? selectedDate;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius:
//             BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 20,
//             bottom:
//                 MediaQuery.of(context).viewInsets.bottom + 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Add New Task',
//                 style: TextStyle(
//                     fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),

//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Task Title',
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate:
//                         DateTime.now().add(const Duration(days: 365)),
//                   );
//                   if (picked != null) selectedDate = picked;
//                 },
//                 icon: const Icon(Icons.calendar_month),
//                 label: const Text('Pick Due Date'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pinkAccent,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pinkAccent,
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   onPressed: () async {
//                     if (titleController.text.trim().isEmpty ||
//                         selectedDate == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content:
//                               Text('Please enter title & date'),
//                         ),
//                       );
//                       return;
//                     }

//                     await FirebaseFirestore.instance
//                         .collection('tasks')
//                         .doc(userId)
//                         .collection('items')
//                         .add({
//                       'title': titleController.text.trim(),
//                       'date':
//                           selectedDate!.toIso8601String().substring(0, 10),
//                       'isDone': false,
//                       'createdAt': Timestamp.now(),
//                     });

//                     Navigator.pop(context);
//                   },
//                   child: const Text('Add Task'),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // 🔹 Add Task Bottom Sheet
  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Pick Date'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addTask,
                child: const Text('Add Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔹 Add Task to Firestore
  Future<void> _addTask() async {
    if (_titleController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('items')
        .add({
      'title': _titleController.text.trim(),
      'date': Timestamp.fromDate(_selectedDate), // ✅ ALWAYS TIMESTAMP
      'isDone': false,
      'createdAt': Timestamp.now(),
    });

    _titleController.clear();
    _selectedDate = DateTime.now();
    Navigator.pop(context);
  }

  // 🔹 Toggle Done
  Future<void> _toggleDone(String taskId, bool current) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('items')
        .doc(taskId)
        .update({'isDone': !current});
  }

  // 🔹 Delete Task
  Future<void> _deleteTask(String taskId) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('items')
        .doc(taskId)
        .delete();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        backgroundColor: Colors.pinkAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: _showAddTaskSheet,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 🔔 Hint
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.pinkAccent.withOpacity(0.1),
            child: const Text(
              '💡 Tip: Swipe left to delete a task',
              style: TextStyle(fontSize: 13),
            ),
          ),

          // 🔹 Task List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(userId)
                  .collection('items')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text('No tasks added yet'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    // ✅ SAFE DATE PARSING (FIXED)
                    DateTime taskDate;
                    final rawDate = data['date'];

                    if (rawDate is Timestamp) {
                      taskDate = rawDate.toDate();
                    } else if (rawDate is String) {
                      taskDate = DateTime.parse(rawDate);
                    } else {
                      taskDate = DateTime.now();
                    }

                    final isDone = data['isDone'] ?? false;
                    final isToday = _isToday(taskDate);

                    return Dismissible(
                      key: Key(doc.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteTask(doc.id),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Checkbox(
                            value: isDone,
                            onChanged: (_) =>
                                _toggleDone(doc.id, isDone),
                          ),
                          title: Text(
                            data['title'],
                            style: TextStyle(
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            isToday
                                ? '⚠ Due Today'
                                : 'Due: ${taskDate.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(
                              color:
                                  isToday ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



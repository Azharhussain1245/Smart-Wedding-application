// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AddExpenseScreen extends StatefulWidget {
//   final String categoryId;

//   const AddExpenseScreen({
//     super.key,
//     required this.categoryId,
//   });

//   @override
//   State<AddExpenseScreen> createState() => _AddExpenseScreenState();
// }

// class _AddExpenseScreenState extends State<AddExpenseScreen> {
//   final _titleController = TextEditingController();
//   final _amountController = TextEditingController();

//   bool _isSaving = false;

//   Future<void> _saveExpense() async {
//     final title = _titleController.text.trim();
//     final amount = num.tryParse(_amountController.text.trim()) ?? 0;

//     if (title.isEmpty || amount <= 0) return;

//     setState(() => _isSaving = true);

//     final userId = FirebaseAuth.instance.currentUser!.uid;

//     final budgetRef =
//         FirebaseFirestore.instance.collection('budgets').doc(userId);

//     final categoryRef =
//         budgetRef.collection('categories').doc(widget.categoryId);

//     final expenseRef =
//         categoryRef.collection('expenses').doc();

//     /// 🔥 ATOMIC TRANSACTION (THIS FIXES EVERYTHING)
//     await FirebaseFirestore.instance.runTransaction((tx) async {
//       // 1️⃣ Save expense
//       tx.set(expenseRef, {
//         'title': title,
//         'amount': amount,
//         'createdAt': FieldValue.serverTimestamp(),
//         'isDone': false,
//       });

//       // 2️⃣ Update category spent
//       tx.update(categoryRef, {
//         'amountSpent': FieldValue.increment(amount),
//       });

//       // 3️⃣ Update total budget
//       tx.update(budgetRef, {
//         'totalBudget': FieldValue.increment(amount),
//       });
//     });

//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Expense'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Expense Title',
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Amount',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isSaving ? null : _saveExpense,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.pinkAccent,
//               ),
//               child: _isSaving
//                   ? const CircularProgressIndicator(
//                       color: Colors.white,
//                     )
//                   : const Text('Save Expense'),
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

class AddExpenseScreen extends StatefulWidget {
  final String categoryId;

  const AddExpenseScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveExpense() async {
    final title = _titleController.text.trim();
    final amount = num.tryParse(_amountController.text.trim()) ?? 0;

    if (title.isEmpty || amount <= 0) return;

    setState(() => _isSaving = true);

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final budgetRef =
        FirebaseFirestore.instance.collection('budgets').doc(userId);

    final categoryRef =
        budgetRef.collection('categories').doc(widget.categoryId);

    final expenseRef =
        categoryRef.collection('expenses').doc();

    /// 🔥 ATOMIC TRANSACTION (CORRECT & FINAL)
    await FirebaseFirestore.instance.runTransaction((tx) async {
      // 1️⃣ Save expense
      tx.set(expenseRef, {
        'title': title,
        'amount': amount,
        'done': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2️⃣ Update category spent ONLY
      tx.update(categoryRef, {
        'amountSpent': FieldValue.increment(amount),
      });

      // ❌ NO totalBudget update here
      // Spending & remaining budget are calculated automatically
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense Title',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}

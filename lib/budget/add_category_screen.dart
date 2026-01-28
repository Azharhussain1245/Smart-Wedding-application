import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration:
                  const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('budgets')
                    .doc(userId)
                    .set({
                  'totalBudget': 0,
                  'createdAt': Timestamp.now(),
                }, SetOptions(merge: true));

                await FirebaseFirestore.instance
                    .collection('budgets')
                    .doc(userId)
                    .collection('categories')
                    .add({
                  'name': controller.text.trim(),
                  'amountSpent': 0,
                });

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

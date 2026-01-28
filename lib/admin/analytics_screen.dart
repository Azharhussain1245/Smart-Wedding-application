import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Future<int> _count(String collection) async {
    final snap = await FirebaseFirestore.instance.collection(collection).get();
    return snap.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: FutureBuilder(
        future: Future.wait([
          _count('users'),
          _count('vendors'),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data![0];
          final vendors = snapshot.data![1];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _analyticsCard('Total Users', users),
                _analyticsCard('Total Vendors', vendors),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _analyticsCard(String title, int value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorPaymentsScreen extends StatelessWidget {
   VendorPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('vendorId', isEqualTo: vendorId)
            .orderBy('paidAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final payments = snapshot.data!.docs;

          if (payments.isEmpty) {
            return const Center(child: Text('No payments yet'));
          }

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment =
                  payments[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                      'Amount: ${payment['amount']} PKR'),
                  subtitle: Text(
                      'Status: ${payment['status']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

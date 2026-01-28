// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CoupleBookingsScreen extends StatelessWidget {
//   const CoupleBookingsScreen({super.key});

//   Color _statusColor(String status) {
//     switch (status) {
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.orange;
//     }
//   }
//     /// ✅ SAFELY CONVERT ANY VALUE TO STRING
//   String _safeText(dynamic value) {
//     if (value == null) return '';
//     if (value is String) return value;
//     if (value is List) return value.join(', ');
//     return value.toString();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final coupleId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(title: const Text('My Booking Requests')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('couples')
//             .doc(coupleId)
//             .collection('bookings')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No bookings yet'));
//           }

//           final bookings = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final data =
//                   bookings[index].data() as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   title: Text(data['vendorName'] ?? 'Vendor'),
//                   subtitle: Text(
//                     'Status: ${data['status']}',
//                     style: TextStyle(
//                       color: _statusColor(data['status']),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoupleBookingsScreen extends StatelessWidget {
  const CoupleBookingsScreen({super.key});

  // 🎨 APP THEME COLORS (Pink · White · Black)
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color softPink = Color(0xFFFCE4EC);
  static const Color pureWhite = Colors.white;
  static const Color pureBlack = Colors.black;

  /// ✅ STATUS COLOR
  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  /// ✅ SAFELY CONVERT ANY VALUE TO STRING
  String _safeText(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final coupleId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: pureWhite,
      appBar: AppBar(
        title: const Text(
          'My Booking Requests',
          style: TextStyle(color: pureWhite),
        ),
        backgroundColor: primaryPink,
        iconTheme: const IconThemeData(color: pureWhite),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('couples')
            .doc(coupleId)
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'No bookings yet',
                style: TextStyle(color: pureBlack),
              ),
            );
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final data = booking.data() as Map<String, dynamic>;

              return Card(
                color: softPink,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    _safeText(data['vendorName']),
                    style: const TextStyle(
                      color: pureBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Service: ${_safeText(data['service'])}\n'
                    'Date: ${_safeText(data['eventDate'])}\n'
                    'Status: ${_safeText(data['status'])}',
                    style: TextStyle(
                      color: _statusColor(
                        _safeText(data['status']),
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

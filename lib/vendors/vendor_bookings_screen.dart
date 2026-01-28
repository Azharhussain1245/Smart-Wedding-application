// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class VendorBookingsScreen extends StatelessWidget {
//   const VendorBookingsScreen({super.key});

//   Future<void> _updateStatus({
//     required String vendorId,
//     required String coupleId,
//     required String bookingId,
//     required String status,
//   }) async {
//     final batch = FirebaseFirestore.instance.batch();

//     // Vendor side
//     batch.update(
//       FirebaseFirestore.instance
//           .collection('vendors')
//           .doc(vendorId)
//           .collection('bookings')
//           .doc(bookingId),
//       {'status': status},
//     );

//     // Couple side
//     batch.update(
//       FirebaseFirestore.instance
//           .collection('couples')
//           .doc(coupleId)
//           .collection('bookings')
//           .doc(bookingId),
//       {'status': status},
//     );

//     await batch.commit();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vendorId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(title: const Text('My Bookings')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(vendorId)
//             .collection('bookings')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No bookings'));
//           }

//           final bookings = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final doc = bookings[index];
//               final data = doc.data() as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   title: Text(data['coupleName'] ?? 'Couple'),
//                   subtitle: Text('Status: ${data['status']}'),
//                   trailing: data['status'] == 'pending'
//                       ? Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.check, color: Colors.green),
//                               onPressed: () => _updateStatus(
//                                 vendorId: vendorId,
//                                 coupleId: data['coupleId'],
//                                 bookingId: doc.id,
//                                 status: 'approved',
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close, color: Colors.red),
//                               onPressed: () => _updateStatus(
//                                 vendorId: vendorId,
//                                 coupleId: data['coupleId'],
//                                 bookingId: doc.id,
//                                 status: 'rejected',
//                               ),
//                             ),
//                           ],
//                         )
//                       : null,
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

class VendorBookingsScreen extends StatelessWidget {
  const VendorBookingsScreen({super.key});

  /// ✅ SAFELY HANDLE STRING / LIST
  String _safeText(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }

  /// ✅ UPDATE STATUS ON BOTH VENDOR & COUPLE SIDE
  Future<void> _updateStatus({
    required String vendorId,
    required String coupleId,
    required String bookingId,
    required String status,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    // Vendor side
    batch.update(
      FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .collection('bookings')
          .doc(bookingId),
      {'status': status},
    );

    // Couple side
    batch.update(
      FirebaseFirestore.instance
          .collection('couples')
          .doc(coupleId)
          .collection('bookings')
          .doc(bookingId),
      {'status': status},
    );

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final vendorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId)
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final doc = bookings[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(_safeText(data['coupleName'] ?? 'Couple')),
                  subtitle: Text(
                    'Status: ${_safeText(data['status'])}',
                  ),
                  trailing: data['status'] == 'requested'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check,
                                  color: Colors.green),
                              onPressed: () => _updateStatus(
                                vendorId: vendorId,
                                coupleId: data['coupleId'],
                                bookingId: doc.id,
                                status: 'confirmed',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red),
                              onPressed: () => _updateStatus(
                                vendorId: vendorId,
                                coupleId: data['coupleId'],
                                bookingId: doc.id,
                                status: 'rejected',
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

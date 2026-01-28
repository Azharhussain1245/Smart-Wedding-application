// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class VendorBookingsScreen extends StatelessWidget {
//   const VendorBookingsScreen({super.key});

//   Future<void> _updateStatus(
//       String vendorId, String bookingId, String status) async {
//     await FirebaseFirestore.instance
//         .collection('vendors')
//         .doc(vendorId)
//         .collection('bookings')
//         .doc(bookingId)
//         .update({'status': status});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vendorId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Bookings'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(vendorId)
//             .collection('bookings')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final bookings = snapshot.data!.docs;

//           if (bookings.isEmpty) {
//             return const Center(child: Text('No bookings yet'));
//           }

//           return ListView.builder(
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final booking = bookings[index];

//               return Card(
//                 margin: const EdgeInsets.all(12),
//                 child: ListTile(
//                   title: Text(booking['service']),
//                   subtitle: Text(
//                       'Date: ${booking['eventDate']}\nStatus: ${booking['status']}'),
//                   trailing: booking['status'] == 'requested'
//                       ? Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.check,
//                                   color: Colors.green),
//                               onPressed: () => _updateStatus(
//                                   vendorId, booking.id, 'confirmed'),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close,
//                                   color: Colors.red),
//                               onPressed: () => _updateStatus(
//                                   vendorId, booking.id, 'rejected'),
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

  // 🎨 APP THEME COLORS (Pink · White · Black)
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color softPink = Color(0xFFFCE4EC);
  static const Color pureWhite = Colors.white;
  static const Color pureBlack = Colors.black;

  /// ✅ SAFELY CONVERT ANY VALUE TO STRING
  String _safeText(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }

  /// ✅ UPDATE STATUS ON BOTH VENDOR & COUPLE SIDE
  Future<void> _updateStatus(
    String vendorId,
    String bookingId,
    String coupleId,
    String status,
  ) async {
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
      backgroundColor: pureWhite,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(color: pureWhite),
        ),
        backgroundColor: primaryPink,
        iconTheme: const IconThemeData(color: pureWhite),
      ),
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
                    _safeText(data['service']),
                    style: const TextStyle(
                      color: pureBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${_safeText(data['eventDate'])}\n'
                    'Status: ${_safeText(data['status'])}',
                    style: const TextStyle(color: pureBlack),
                  ),
                  trailing: data['status'] == 'requested'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () => _updateStatus(
                                vendorId,
                                booking.id,
                                data['coupleId'],
                                'confirmed',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: () => _updateStatus(
                                vendorId,
                                booking.id,
                                data['coupleId'],
                                'rejected',
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

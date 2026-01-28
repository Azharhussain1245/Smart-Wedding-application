// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CreateBookingScreen extends StatefulWidget {
//   final String vendorId;
//   final String vendorName;

//   const CreateBookingScreen({
//     super.key,
//     required this.vendorId,
//     required this.vendorName,
//   });

//   @override
//   State<CreateBookingScreen> createState() =>
//       _CreateBookingScreenState();
// }

// class _CreateBookingScreenState extends State<CreateBookingScreen> {
//   final serviceController = TextEditingController();
//   DateTime? eventDate;

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 7)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) setState(() => eventDate = picked);
//   }

//   Future<void> _submitBooking() async {
//     if (serviceController.text.isEmpty || eventDate == null) return;

//     final coupleId = FirebaseAuth.instance.currentUser!.uid;
//     final bookingRef =
//         FirebaseFirestore.instance.collection('bookings').doc();

//     final bookingData = {
//       'vendorId': widget.vendorId,
//       'vendorName': widget.vendorName,
//       'coupleId': coupleId,
//       'service': serviceController.text.trim(),
//       'eventDate':
//           '${eventDate!.day}-${eventDate!.month}-${eventDate!.year}',
//       'status': 'requested',
//       'createdAt': Timestamp.now(),
//     };

//     // Save to vendor
//     await FirebaseFirestore.instance
//         .collection('vendors')
//         .doc(widget.vendorId)
//         .collection('bookings')
//         .doc(bookingRef.id)
//         .set(bookingData);

//     // Save to couple
//     await FirebaseFirestore.instance
//         .collection('couples')
//         .doc(coupleId)
//         .collection('bookings')
//         .doc(bookingRef.id)
//         .set(bookingData);

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Request Booking'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text(
//               'Vendor: ${widget.vendorName}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: serviceController,
//               decoration:
//                   const InputDecoration(labelText: 'Service Required'),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               children: [
//                 Text(
//                   eventDate == null
//                       ? 'No date selected'
//                       : 'Date: ${eventDate!.day}-${eventDate!.month}-${eventDate!.year}',
//                 ),
//                 const Spacer(),
//                 TextButton(
//                   onPressed: _pickDate,
//                   child: const Text('Pick Date'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),
//             ElevatedButton(
//               onPressed: _submitBooking,
//               child: const Text('Submit Booking'),
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

class CreateBookingScreen extends StatefulWidget {
  final String vendorId;
  final String vendorName;

  const CreateBookingScreen({
    super.key,
    required this.vendorId,
    required this.vendorName,
  });

  @override
  State<CreateBookingScreen> createState() =>
      _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final serviceController = TextEditingController();
  DateTime? eventDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => eventDate = picked);
    }
  }

  Future<void> _submitBooking() async {
    if (serviceController.text.isEmpty || eventDate == null) return;

    final user = FirebaseAuth.instance.currentUser!;
    final bookingId =
        FirebaseFirestore.instance.collection('tmp').doc().id;

    final bookingData = {
      'bookingId': bookingId,
      'vendorId': widget.vendorId,
      'vendorName': widget.vendorName,
      'coupleId': user.uid,
      'service': serviceController.text.trim(),
      'eventDate':
          '${eventDate!.day}-${eventDate!.month}-${eventDate!.year}',
      'status': 'requested',
      'createdAt': FieldValue.serverTimestamp(),
    };

    final batch = FirebaseFirestore.instance.batch();

    // ✅ COUPLE SIDE
    batch.set(
      FirebaseFirestore.instance
          .collection('couples')
          .doc(user.uid)
          .collection('bookings')
          .doc(bookingId),
      bookingData,
    );

    // ✅ VENDOR SIDE
    batch.set(
      FirebaseFirestore.instance
          .collection('vendors')
          .doc(widget.vendorId)
          .collection('bookings')
          .doc(bookingId),
      bookingData,
    );

    await batch.commit();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking request sent')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Booking'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Vendor: ${widget.vendorName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: serviceController,
              decoration:
                  const InputDecoration(labelText: 'Service Required'),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  eventDate == null
                      ? 'No date selected'
                      : 'Date: ${eventDate!.day}-${eventDate!.month}-${eventDate!.year}',
                ),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _submitBooking,
              child: const Text('Submit Booking'),
            ),
          ],
        ),
      ),
    );
  }
}

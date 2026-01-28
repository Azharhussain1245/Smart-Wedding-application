// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class VendorProfileScreen extends StatelessWidget {
//   final String vendorId;

//   const VendorProfileScreen({super.key, required this.vendorId});

//   Future<void> _requestBooking(
//     BuildContext context,
//     Map<String, dynamic> vendor,
//   ) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     await FirebaseFirestore.instance.collection('bookings').add({
//       'vendorId': vendorId,
//       'vendorName': vendor['companyName'],
//       'userId': user.uid,
//       'status': 'pending',
//       'requestedAt': Timestamp.now(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Booking request sent')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vendor Profile'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(vendorId)
//             .get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final vendor =
//               snapshot.data!.data() as Map<String, dynamic>;

//           // ✅ SAFE READS (NO CRASH)
//           final location = vendor['location'] ?? {};
//           final city = location['city'] ?? 'Not specified';

//           final List services = vendor['services'] ?? [];
//           final List categories = vendor['categories'] ?? [];

//           final description =
//               vendor['description'] ?? 'No description provided';

//           final priceRange =
//               vendor['priceRange'] ?? 'Not specified';

//           // ✅ FIXED PHONE & EMAIL (SUPPORT BOTH KEYS)
//           final phone =
//               vendor['phone'] ??
//               vendor['contactPhone'] ??
//               'Not available';

//           final email =
//               vendor['email'] ??
//               vendor['contactEmail'] ??
//               'Not available';

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   vendor['companyName'],
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text('City: $city'),
//                 const SizedBox(height: 5),
//                 Text(
//                   'Categories: ${categories.join(', ')}',
//                 ),
//                 const SizedBox(height: 15),

//                 Text(
//                   description,
//                   style: const TextStyle(fontSize: 15),
//                 ),

//                 const SizedBox(height: 15),
//                 const Divider(),

//                 const Text(
//                   'Services Offered',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // ✅ SAFE MAP (NO NULL CRASH)
//                 if (services.isNotEmpty)
//                   ...services.map<Widget>(
//                     (s) => Row(
//                       children: [
//                         const Icon(
//                           Icons.check,
//                           color: Colors.green,
//                           size: 18,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(s.toString()),
//                       ],
//                     ),
//                   )
//                 else
//                   const Text('No services listed'),

//                 const SizedBox(height: 15),
//                 const Divider(),

//                 Text('Price Range: $priceRange'),
//                 const SizedBox(height: 5),
//                 Text('Phone: $phone'),
//                 const SizedBox(height: 5),
//                 Text('Email: $email'),

//                 const SizedBox(height: 25),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () =>
//                         _requestBooking(context, vendor),
//                     child: const Text('Request Booking'),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bookings/create_booking_screen.dart';


class VendorProfileScreen extends StatelessWidget {
  final String vendorId;

  const VendorProfileScreen({super.key, required this.vendorId});

  Future<void> _requestBooking(
    BuildContext context,
    Map<String, dynamic> vendor,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('bookings').add({
      'vendorId': vendorId,
      'vendorName': vendor['companyName'],
      'userId': user.uid,
      'status': 'pending',
      'requestedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking request sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Profile'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final vendor =
              snapshot.data!.data() as Map<String, dynamic>;

          // ✅ SAFE READS
          final location = vendor['location'] ?? {};
          final city = location['city'] ?? 'Not specified';

          final List services = vendor['services'] ?? [];
          final List categories = vendor['categories'] ?? [];

          final description =
              vendor['description'] ?? 'No description provided';

          final priceRange =
              vendor['priceRange'] ?? 'Not specified';

          // ✅ SUPPORT BOTH OLD & NEW KEYS
          final phone =
              vendor['phone'] ??
              vendor['contactPhone'] ??
              'Not available';

          final email =
              vendor['email'] ??
              vendor['contactEmail'] ??
              'Not available';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor['companyName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('City: $city'),
                const SizedBox(height: 5),
                Text(
                  'Categories: ${categories.join(', ')}',
                ),
                const SizedBox(height: 15),

                Text(
                  description,
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 15),
                const Divider(),

                const Text(
                  'Services Offered',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (services.isNotEmpty)
                  ...services.map<Widget>(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(child: Text(s.toString())),
                        ],
                      ),
                    ),
                  )
                else
                  const Text('No services listed'),

                const SizedBox(height: 15),
                const Divider(),

                Text('Price Range: $priceRange'),
                const SizedBox(height: 5),
                Text('Phone: $phone'),
                const SizedBox(height: 5),
                Text('Email: $email'),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child:ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateBookingScreen(
          vendorId: vendorId,
          vendorName: vendor['companyName'],
        ),
      ),
    );
  },
  child: const Text('Request Booking'),
),

                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

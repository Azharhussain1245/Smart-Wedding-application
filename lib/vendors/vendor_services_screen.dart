// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class VendorServicesScreen extends StatefulWidget {
//   VendorServicesScreen({super.key});

//   @override
//   State<VendorServicesScreen> createState() => _VendorServicesScreenState();
// }

// class _VendorServicesScreenState extends State<VendorServicesScreen> {
//   final TextEditingController _serviceController = TextEditingController();

//   String get vendorId => FirebaseAuth.instance.currentUser!.uid;

//   Future<void> _addService() async {
//     if (_serviceController.text.isEmpty) return;

//     await FirebaseFirestore.instance
//         .collection('vendors')
//         .doc(vendorId)
//         .update({
//       'services': FieldValue.arrayUnion([_serviceController.text])
//     });

//     _serviceController.clear();
//   }

//   Future<void> _removeService(String service) async {
//     await FirebaseFirestore.instance
//         .collection('vendors')
//         .doc(vendorId)
//         .update({
//       'services': FieldValue.arrayRemove([service])
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Services'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(vendorId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(
//               child: Text(
//                 'No services found.\nPlease add your services.',
//                 textAlign: TextAlign.center,
//               ),
//             );
//           }

//           final vendor =
//               snapshot.data!.data() as Map<String, dynamic>;
//           final List services = vendor['services'] ?? [];

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _serviceController,
//                         decoration: const InputDecoration(
//                           labelText: 'Add new service',
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: _addService,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: services.isEmpty
//                       ? const Text('No services added')
//                       : ListView.builder(
//                           itemCount: services.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(services[index].toString()),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () =>
//                                     _removeService(services[index]),
//                               ),
//                             );
//                           },
//                         ),
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

class VendorServicesScreen extends StatefulWidget {
  VendorServicesScreen({super.key});

  @override
  State<VendorServicesScreen> createState() => _VendorServicesScreenState();
}

class _VendorServicesScreenState extends State<VendorServicesScreen> {
  final TextEditingController _serviceController = TextEditingController();

  String get vendorId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _addService() async {
    if (_serviceController.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .set({
      'services': FieldValue.arrayUnion([_serviceController.text.trim()])
    }, SetOptions(merge: true));

    _serviceController.clear();
  }

  Future<void> _removeService(String service) async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .update({
      'services': FieldValue.arrayRemove([service])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FA),
      appBar: AppBar(
        title: const Text('My Services'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data =
              snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final List services = data['services'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _serviceController,
                        decoration: const InputDecoration(
                          labelText: 'Add new service',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.pinkAccent),
                      onPressed: _addService,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: services.isEmpty
                      ? const Center(
                          child: Text(
                            'No services found.\nPlease add your services.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title:
                                    Text(services[index].toString()),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () =>
                                      _removeService(services[index]),
                                ),
                              ),
                            );
                          },
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

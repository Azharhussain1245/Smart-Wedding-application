// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class VendorProfileForm extends StatefulWidget {
//   const VendorProfileForm({super.key});

//   @override
//   State<VendorProfileForm> createState() => _VendorProfileFormState();
// }

// class _VendorProfileFormState extends State<VendorProfileForm> {
//   final companyController = TextEditingController();
//   final priceController = TextEditingController();

//   String selectedCity = 'Karachi';

//   final categories = [
//     'Photographer',
//     'Catering',
//     'Decoration',
//     'DJ',
//     'Event Planner',
//   ];

//   final selectedCategories = <String>{};

//   Future<void> _submitProfile() async {
//     if (companyController.text.isEmpty ||
//         selectedCategories.isEmpty) return;

//     final user = FirebaseAuth.instance.currentUser!;

//     await FirebaseFirestore.instance
//         .collection('vendors')
//         .doc(user.uid)
//         .set({
//       'companyName': companyController.text.trim(),
//       'categories': selectedCategories.toList(),
//       'location': {
//         'city': selectedCity,
//         'province': 'Pakistan',
//       },
//       'priceRange': priceController.text.trim(),
//       'status': 'pending',
//       'createdAt': Timestamp.now(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Profile submitted for approval'),
//       ),
//     );

//     Navigator.pop(context);
//   }

//   Widget _card({required Widget child}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.95),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: child,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complete Profile'),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           // Background image (same as dashboard)
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/vendor_dashboard_bg.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // Dark overlay
//           Container(
//             color: Colors.black.withOpacity(0.55),
//           ),

//           // Content
//           SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(20, 120, 20, 30),
//             child: Column(
//               children: [
//                 _card(
//                   child: TextField(
//                     controller: companyController,
//                     decoration: const InputDecoration(
//                       labelText: 'Company Name',
//                       labelStyle: TextStyle(color: Colors.black87),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.pinkAccent),
//                       ),
//                     ),
//                   ),
//                 ),

//                 _card(
//                   child: DropdownButtonFormField<String>(
//                     value: selectedCity,
//                     items: ['Karachi', 'Lahore', 'Islamabad']
//                         .map(
//                           (city) => DropdownMenuItem(
//                             value: city,
//                             child: Text(city),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) =>
//                         setState(() => selectedCity = value!),
//                     decoration: const InputDecoration(
//                       labelText: 'City',
//                       labelStyle: TextStyle(color: Colors.black87),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.pinkAccent),
//                       ),
//                     ),
//                   ),
//                 ),

//                 _card(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Select Categories',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       ...categories.map(
//                         (cat) => CheckboxListTile(
//                           contentPadding: EdgeInsets.zero,
//                           title: Text(
//                             cat,
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                           activeColor: Colors.pinkAccent,
//                           value: selectedCategories.contains(cat),
//                           onChanged: (checked) {
//                             setState(() {
//                               checked!
//                                   ? selectedCategories.add(cat)
//                                   : selectedCategories.remove(cat);
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 _card(
//                   child: TextField(
//                     controller: priceController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Price Range',
//                       labelStyle: TextStyle(color: Colors.black87),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.pinkAccent),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _submitProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.pinkAccent,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     child: const Text(
//                       'Submit for Approval',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorProfileForm extends StatefulWidget {
  const VendorProfileForm({super.key});

  @override
  State<VendorProfileForm> createState() => _VendorProfileFormState();
}

class _VendorProfileFormState extends State<VendorProfileForm> {
  final companyController = TextEditingController();
  final priceController = TextEditingController();

  String selectedCity = 'Karachi';

  final categories = [
    'Photographer',
    'Catering',
    'Decoration',
    'DJ',
    'Event Planner',
  ];

  final selectedCategories = <String>{};

  String get vendorId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _submitProfile() async {
    if (companyController.text.isEmpty ||
        selectedCategories.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .set({
      'companyName': companyController.text.trim(),
      'categories': selectedCategories.toList(),
      'location': {
        'city': selectedCity,
        'province': 'Pakistan',
      },
      'priceRange': priceController.text.trim(),
      'status': 'pending',
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile submitted for approval'),
      ),
    );

    Navigator.pop(context);
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/vendor_dashboard_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.55)),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 30),
            child: Column(
              children: [
                _card(
                  child: TextField(
                    controller: companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                    ),
                  ),
                ),

                _card(
                  child: DropdownButtonFormField<String>(
                    value: selectedCity,
                    items: ['Karachi', 'Lahore', 'Islamabad']
                        .map(
                          (city) => DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedCity = value!),
                    decoration:
                        const InputDecoration(labelText: 'City'),
                  ),
                ),

                /// 🔹 AUTO-UPDATED SERVICES (READ-ONLY)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('vendors')
                      .doc(vendorId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final data =
                        snapshot.data?.data() as Map<String, dynamic>? ?? {};
                    final List services = data['services'] ?? [];

                    return _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Services',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          services.isEmpty
                              ? const Text(
                                  'No services added yet',
                                )
                              : Column(
                                  children: services
                                      .map(
                                        (s) => ListTile(
                                          dense: true,
                                          leading: const Icon(
                                            Icons.check_circle,
                                            color: Colors.pinkAccent,
                                          ),
                                          title: Text(s.toString()),
                                        ),
                                      )
                                      .toList(),
                                ),
                        ],
                      ),
                    );
                  },
                ),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...categories.map(
                        (cat) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(cat),
                          activeColor: Colors.pinkAccent,
                          value: selectedCategories.contains(cat),
                          onChanged: (checked) {
                            setState(() {
                              checked!
                                  ? selectedCategories.add(cat)
                                  : selectedCategories.remove(cat);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                _card(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price Range',
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Submit for Approval',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

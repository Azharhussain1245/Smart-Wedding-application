import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../invitations/create_invitation_screen.dart';
import '../budget/budget_screen.dart';
import '../playlists/playlist_list_screen.dart';
import '../tasks/task_list_screen.dart';
import '../vendors/vendor_list_screen.dart';
import '../bookings/couple_bookings_screen.dart';
import '../ai/ai_assistant_screen.dart';

class CoupleDashboard extends StatefulWidget {
  const CoupleDashboard({super.key});

  @override
  State<CoupleDashboard> createState() => _CoupleDashboardState();
}

class _CoupleDashboardState extends State<CoupleDashboard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  DateTime _weddingDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    _loadWeddingDateAndStartTimer();
  }

  Future<void> _loadWeddingDateAndStartTimer() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (doc.exists &&
        doc.data() != null &&
        doc.data()!.containsKey('weddingDate')) {
      _weddingDate = (doc['weddingDate'] as Timestamp).toDate();
    }

    _updateRemaining();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final now = DateTime.now();
    setState(() {
      _remaining = _weddingDate.difference(now);
      if (_remaining.isNegative) {
        _remaining = Duration.zero;
      }
    });
  }

  Future<void> _pickWeddingDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _weddingDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_weddingDate),
      );

      if (pickedTime != null) {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'weddingDate': Timestamp.fromDate(fullDateTime),
        });

        setState(() {
          _weddingDate = fullDateTime;
        });

        _updateRemaining();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/couple_dashboard_bg.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.25),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Couple Dashboard 💍',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _CountdownCard(
                    duration: _remaining,
                    onPickDate: _pickWeddingDate,
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'Welcome 👰🤵',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Plan your wedding from one place',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _ActionCard(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Budget',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BudgetScreen(),
                            ),
                          );
                        },
                      ),
                      _ActionCard(
                        icon: Icons.storefront,
                        title: 'Vendors',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VendorListScreen(),
                            ),
                          );
                        },
                      ),
                      _ActionCard(
                        icon: Icons.check_circle_outline,
                        title: 'Tasks',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TaskListScreen(),
                            ),
                          );
                        },
                      ),
                      _ActionCard(
                        icon: Icons.music_note,
                        title: 'Playlists',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PlaylistListScreen(),
                            ),
                          );
                        },
                      ),
                      _ActionCard(
                        icon: Icons.mail_outline,
                        title: 'Invitations',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CreateInvitationScreen(),
                            ),
                          );
                        },
                      ),
                      _ActionCard(
                        icon: Icons.book_online,
                        title: 'My Bookings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CoupleBookingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 20,
            bottom: 30,
            child: FloatingActionButton(
              backgroundColor: Colors.pinkAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AIAssistantScreen(),
                  ),
                );
              },
              child: const Icon(Icons.smart_toy),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// COUNTDOWN CARD
////////////////////////////////////////////////////////////
class _CountdownCard extends StatelessWidget {
  final Duration duration;
  final VoidCallback onPickDate;

  const _CountdownCard({
    required this.duration,
    required this.onPickDate,
  });

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.pink],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wedding Countdown',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TimeBox(label: 'Days', value: days.toString()),
              _TimeBox(label: 'Hrs', value: twoDigits(hours)),
              _TimeBox(label: 'Min', value: twoDigits(minutes)),
              _TimeBox(label: 'Sec', value: twoDigits(seconds)),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onPickDate,
              icon: const Icon(Icons.calendar_month),
              label: const Text('Set Wedding Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String value;

  const _TimeBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.pinkAccent),
            const SizedBox(height: 10),
            Text(
              title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../invitations/create_invitation_screen.dart';
// import '../budget/budget_screen.dart';
// import '../playlists/playlist_list_screen.dart';
// import '../tasks/task_list_screen.dart';
// import '../vendors/vendor_list_screen.dart';
// import '../bookings/couple_bookings_screen.dart';
// import '../ai/ai_assistant_screen.dart';



// class CoupleDashboard extends StatefulWidget {
//   const CoupleDashboard({super.key});

//   @override
//   State<CoupleDashboard> createState() => _CoupleDashboardState();
// }

// class _CoupleDashboardState extends State<CoupleDashboard> {
//   Timer? _timer;
//   Duration _remaining = Duration.zero;
//   DateTime _weddingDate = DateTime.now().add(const Duration(days: 30));

//   @override
//   void initState() {
//     super.initState();
//     _loadWeddingDateAndStartTimer();
//   }

//   Future<void> _loadWeddingDateAndStartTimer() async {
//     final userId = FirebaseAuth.instance.currentUser!.uid;

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .get();

//     if (doc.exists &&
//         doc.data() != null &&
//         doc.data()!.containsKey('weddingDate')) {
//       _weddingDate = (doc['weddingDate'] as Timestamp).toDate();
//     }

//     _updateRemaining();

//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _updateRemaining();
//     });
//   }

//   void _updateRemaining() {
//     final now = DateTime.now();
//     setState(() {
//       _remaining = _weddingDate.difference(now);
//       if (_remaining.isNegative) {
//         _remaining = Duration.zero;
//       }
//     });
//   }

//   Future<void> _pickWeddingDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _weddingDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
//     );

//     if (pickedDate != null) {
//       final userId = FirebaseAuth.instance.currentUser!.uid;

//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .update({
//         'weddingDate': Timestamp.fromDate(pickedDate),
//       });

//       setState(() {
//         _weddingDate = pickedDate;
//       });

//       _updateRemaining();
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/couple_dashboard_bg.jpg'),
//                 fit: BoxFit.cover,
//                 alignment: Alignment.topCenter,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.55),
//                   Colors.black.withOpacity(0.25),
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Couple Dashboard 💍',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.logout, color: Colors.white),
//                         onPressed: () async {
//                           await FirebaseAuth.instance.signOut();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: _CountdownCard(
//                     duration: _remaining,
//                     onPickDate: _pickWeddingDate,
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     padding: const EdgeInsets.all(25),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 15,
//                           offset: Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: const [
//                         Text(
//                           'Welcome 👰🤵',
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Plan your wedding from one place',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 Expanded(
//                   child: GridView.count(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     children: [
//                       _ActionCard(
//                         icon: Icons.account_balance_wallet_outlined,
//                         title: 'Budget',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const BudgetScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       _ActionCard(
//                         icon: Icons.storefront,
//                         title: 'Vendors',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const VendorListScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       _ActionCard(
//                         icon: Icons.check_circle_outline,
//                         title: 'Tasks',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const TaskListScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       _ActionCard(
//                         icon: Icons.music_note,
//                         title: 'Playlists',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const PlaylistListScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       _ActionCard(
//                         icon: Icons.mail_outline,
//                         title: 'Invitations',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   const CreateInvitationScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       /// ✅ NEW CARD (ONLY ADDITION)
//                       _ActionCard(
//                         icon: Icons.book_online,
//                         title: 'My Bookings',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   const CoupleBookingsScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
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

// ////////////////////////////////////////////////////////////
// /// COUNTDOWN CARD
// ////////////////////////////////////////////////////////////
// class _CountdownCard extends StatelessWidget {
//   final Duration duration;
//   final VoidCallback onPickDate;

//   const _CountdownCard({
//     required this.duration,
//     required this.onPickDate,
//   });

//   String twoDigits(int n) => n.toString().padLeft(2, '0');

//   @override
//   Widget build(BuildContext context) {
//     final days = duration.inDays;
//     final hours = duration.inHours % 24;
//     final minutes = duration.inMinutes % 60;
//     final seconds = duration.inSeconds % 60;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         gradient: const LinearGradient(
//           colors: [Colors.pinkAccent, Colors.pink],
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Wedding Countdown',
//             style: TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _TimeBox(label: 'Days', value: days.toString()),
//               _TimeBox(label: 'Hrs', value: twoDigits(hours)),
//               _TimeBox(label: 'Min', value: twoDigits(minutes)),
//               _TimeBox(label: 'Sec', value: twoDigits(seconds)),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton.icon(
//               onPressed: onPickDate,
//               icon: const Icon(Icons.calendar_month),
//               label: const Text('Set Wedding Date'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.pinkAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TimeBox extends StatelessWidget {
//   final String label;
//   final String value;

//   const _TimeBox({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 12),
//         ),
//       ],
//     );
//   }
// }

// class _ActionCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const _ActionCard({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 10,
//             offset: Offset(0, 6),
//           ),
//         ],
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: onTap,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.pinkAccent),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



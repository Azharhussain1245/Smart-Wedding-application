// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../auth/login_screen.dart';

// import '../vendor_panel/vendor_profile_form.dart';
// import '../vendors/vendor_bookings_screen.dart';
// import '../vendors/vendor_services_screen.dart';
// import '../vendors/vendor_payments_screen.dart';
// import '../bookings/vendor_bookings_screen.dart';

// class VendorDashboard extends StatelessWidget {
//   const VendorDashboard({super.key});

//   // 🔐 LOGOUT
//   Future<void> _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginScreen()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 🔹 Background Image
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/vendor_dashboard_bg.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // 🔹 Gradient Overlay
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
//                 // 🔹 Header
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Vendor Dashboard 🎉',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       IconButton(
//                         icon:
//                             const Icon(Icons.logout, color: Colors.white),
//                         onPressed: () => _logout(context),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // 🔹 Welcome Card
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
//                           'Welcome 🎉',
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Manage bookings and services\nwith ease',
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

//                 // 🔹 Dashboard Grid
//                 Expanded(
//                   child: GridView.count(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     children: [
//                       // ✅ BOOKINGS
//                       _VendorDashboardCard(
//                         icon: Icons.event_available,
//                         title: 'Bookings',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                    VendorBookingsScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       // ✅ SERVICES
//                       _VendorDashboardCard(
//                         icon: Icons.list_alt,
//                         title: 'Services',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                    VendorServicesScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       // ✅ PAYMENTS
//                       _VendorDashboardCard(
//                         icon: Icons.payments,
//                         title: 'Payments',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                    VendorPaymentsScreen(),
//                             ),
//                           );
//                         },
//                       ),

//                       // ✅ COMPLETE PROFILE (UNCHANGED)
//                       _VendorDashboardCard(
//                         icon: Icons.edit_note,
//                         title: 'Complete Profile',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                    VendorProfileForm(),
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
// /// 🔹 DASHBOARD CARD
// ////////////////////////////////////////////////////////////
// class _VendorDashboardCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const _VendorDashboardCard({
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
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';

import '../vendor_panel/vendor_profile_form.dart';
import '../vendors/vendor_services_screen.dart';
import '../vendors/vendor_payments_screen.dart';
import '../bookings/vendor_bookings_screen.dart';
import '../bookings/vendor_bookings_screen.dart';


class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  // 🔐 LOGOUT
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/vendor_dashboard_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Gradient Overlay
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
                // 🔹 Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vendor Dashboard 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () => _logout(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Welcome Card
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
                          'Welcome 🎉',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Manage bookings and services\nwith ease',
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

                // 🔹 Dashboard Grid
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      // ✅ BOOKINGS (UPDATED ONLY HERE)
                      _VendorDashboardCard(
                        icon: Icons.event_available,
                        title: 'Bookings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const VendorBookingsScreen(),
                            ),
                          );
                        },
                      ),

                      // ✅ SERVICES
                      _VendorDashboardCard(
                        icon: Icons.list_alt,
                        title: 'Services',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VendorServicesScreen(),
                            ),
                          );
                        },
                      ),

                      // ✅ PAYMENTS
                      _VendorDashboardCard(
                        icon: Icons.payments,
                        title: 'Payments',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VendorPaymentsScreen(),
                            ),
                          );
                        },
                      ),

                      // ✅ COMPLETE PROFILE
                      _VendorDashboardCard(
                        icon: Icons.edit_note,
                        title: 'Complete Profile',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VendorProfileForm(),
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
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 DASHBOARD CARD
////////////////////////////////////////////////////////////
class _VendorDashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _VendorDashboardCard({
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

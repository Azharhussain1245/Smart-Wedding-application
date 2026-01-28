// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../auth/login_screen.dart';
// import 'pending_vendors_screen.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   // 🔐 LOGOUT FUNCTION (UNCHANGED)
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
//             height: MediaQuery.of(context).size.height,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/admin_dashboard_bg.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // 🔹 Dark Gradient Overlay
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.65),
//                   Colors.black.withOpacity(0.35),
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//             ),
//           ),

//           // 🔹 Main Content
//           SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔹 Header
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 16,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Admin Dashboard 🛡️',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => _logout(context),
//                         icon: const Icon(
//                           Icons.logout,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // 🔹 Welcome / Control Panel Card
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     padding: const EdgeInsets.all(25),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.92),
//                       borderRadius: BorderRadius.circular(28),
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
//                           'Admin Control Panel',
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Manage users, vendors,\nweddings & platform settings',
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

//                 // 🔹 Increased spacing (requested)
//                 const SizedBox(height: 42),

//                 // 🔹 Admin Options Grid
//                 Expanded(
//                   child: GridView.count(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     children: [
//                       _AdminDashboardCard(
//                         icon: Icons.verified_user,
//                         title: 'Pending Vendors',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const PendingVendorsScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                       const _AdminDashboardCard(
//                         icon: Icons.analytics,
//                         title: 'Analytics',
//                         onTap: null,
//                       ),
//                       const _AdminDashboardCard(
//                         icon: Icons.people,
//                         title: 'Users',
//                         onTap: null,
//                       ),
//                       const _AdminDashboardCard(
//                         icon: Icons.settings,
//                         title: 'Settings',
//                         onTap: null,
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

// // 🔹 Reusable Admin Dashboard Card
// // (subtle tap animation added — logic unchanged)
// class _AdminDashboardCard extends StatefulWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback? onTap;

//   const _AdminDashboardCard({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   State<_AdminDashboardCard> createState() => _AdminDashboardCardState();
// }

// class _AdminDashboardCardState extends State<_AdminDashboardCard> {
//   double _scale = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => setState(() => _scale = 0.96),
//       onTapUp: (_) => setState(() => _scale = 1.0),
//       onTapCancel: () => setState(() => _scale = 1.0),
//       onTap: widget.onTap,
//       child: AnimatedScale(
//         scale: _scale,
//         duration: const Duration(milliseconds: 120),
//         curve: Curves.easeOut,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.95),
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 12,
//                 offset: Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 widget.icon,
//                 size: 42,
//                 color: Colors.pinkAccent,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 widget.title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';
import 'pending_vendors_screen.dart';

// ✅ ADDED IMPORTS
import 'users_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // 🔐 LOGOUT FUNCTION (UNCHANGED)
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
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/admin_dashboard_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Dark Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.black.withOpacity(0.35),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // 🔹 Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Admin Dashboard 🛡️',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _logout(context),
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Welcome / Control Panel Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(28),
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
                          'Admin Control Panel',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Manage users, vendors,\nweddings & platform settings',
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

                const SizedBox(height: 42),

                // 🔹 Admin Options Grid
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      // ✅ Pending Vendors
                      _AdminDashboardCard(
                        icon: Icons.verified_user,
                        title: 'Pending Vendors',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PendingVendorsScreen(),
                            ),
                          );
                        },
                      ),

                      // ✅ Analytics
                      _AdminDashboardCard(
                        icon: Icons.analytics,
                        title: 'Analytics',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AnalyticsScreen(),
                            ),
                          );
                        },
                      ),

                      // ✅ Users
                      _AdminDashboardCard(
                        icon: Icons.people,
                        title: 'Users',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UsersScreen(),
                            ),
                          );
                        },
                      ),

                      // ✅ Settings
                      _AdminDashboardCard(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
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

// 🔹 Reusable Admin Dashboard Card
class _AdminDashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _AdminDashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<_AdminDashboardCard> createState() => _AdminDashboardCardState();
}

class _AdminDashboardCardState extends State<_AdminDashboardCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 42,
                color: Colors.pinkAccent,
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

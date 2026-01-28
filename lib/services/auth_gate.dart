import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:smart_wed_app/dashboards/couple_dashboard.dart';
import 'package:smart_wed_app/vendor_panel/vendor_dashboard.dart';
import '../auth/login_screen.dart';
import '../auth/verify_email_screen.dart';
import '../vendor_panel/vendor_dashboard.dart';
import '../vendor_panel/vendor_dashboard.dart';
import '../admin/admin_dashboard.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔹 Not logged in
        if (!snapshot.hasData) {
          return LoginScreen();
        }

        final user = snapshot.data!;

        // 🔹 Email not verified
        if (!user.emailVerified) {
          return const VerifyEmailScreen();
        }

        // 🔹 Fetch role from Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnapshot) {
            // 🔹 Loading state (FYP-level UI)
            if (roleSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const _AuthLoadingScreen();
            }

            if (!roleSnapshot.hasData ||
                !roleSnapshot.data!.exists) {
              return const _AuthErrorScreen(
                message: 'User data not found',
              );
            }

            final role = roleSnapshot.data!['role'];

            switch (role) {
              case 'couple':
                return  CoupleDashboard();
              case 'vendor':
                return  VendorDashboard();
              case 'admin':
                return  AdminDashboard();
              default:
                return const _AuthErrorScreen(
                  message: 'Unknown user role',
                );
            }
          },
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 LOADING SCREEN (Same UI language as app)
////////////////////////////////////////////////////////////
class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/login_page_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Loading Card
          Center(
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
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(
                    color: Colors.pinkAccent,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Setting things up...\nPlease wait',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 ERROR SCREEN (Clean fallback)
////////////////////////////////////////////////////////////
class _AuthErrorScreen extends StatelessWidget {
  final String message;

  const _AuthErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}



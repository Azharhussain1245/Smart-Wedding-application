// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class VerifyEmailScreen extends StatelessWidget {
//   const VerifyEmailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Verify Email')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.email, size: 80, color: Colors.pinkAccent),
//             const SizedBox(height: 20),
//             const Text(
//               'A verification email has been sent.\n'
//               'Please verify your email and press the button below.',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () async {
//                 User? user = FirebaseAuth.instance.currentUser;
//                 await user?.reload();

//                 if (user != null && user.emailVerified) {
//                   Navigator.pushReplacementNamed(context, '/home');
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Email not verified yet'),
//                     ),
//                   );
//                 }
//               },
//               child: const Text('I Verified'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image (same as Login & Signup)
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_page_bg.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
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

          // 🔹 Verify Card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
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
                  children: [
                    const Icon(
                      Icons.email,
                      size: 80,
                      color: Colors.pinkAccent,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Verify Your Email 📧',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'A verification email has been sent.\n'
                      'Please verify your email and then press the button below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Verify Button with feedback
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        // 🔔 Feedback: checking
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Checking email verification status...'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        User? user =
                            FirebaseAuth.instance.currentUser;
                        await user?.reload();
                        user = FirebaseAuth.instance.currentUser;

                        if (user != null && user.emailVerified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Email verified successfully ✅'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          await Future.delayed(
                              const Duration(seconds: 1));

                          Navigator.pushReplacementNamed(
                              context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Email not verified yet. Please check your inbox.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'I Verified',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Back Button
          Positioned(
            top: 45,
            left: 15,
            child: IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

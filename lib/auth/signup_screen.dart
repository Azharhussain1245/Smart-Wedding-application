// import 'package:flutter/material.dart';
// import '../widgets/custom_textfield.dart';
// import '../widgets/primary_button.dart';
// import 'role_selector.dart';
// import '../services/auth_service.dart';
// import 'verify_email_screen.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final adminCodeController = TextEditingController();

//   String selectedRole = 'Couple';

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
//                 image: AssetImage('assets/images/login_page_bg.jpg'),
//                 fit: BoxFit.cover,
//                 alignment: Alignment.center,
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

//           // 🔹 Signup Card
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: Theme(
//                 data: Theme.of(context).copyWith(
//                   inputDecorationTheme: InputDecorationTheme(
//                     filled: false,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.all(25),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.88),
//                     borderRadius: BorderRadius.circular(25),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 15,
//                         offset: Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Create Account 💍',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Join SmartWed and start planning today',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                       const SizedBox(height: 30),

//                       CustomTextField(
//                         label: 'Full Name',
//                         controller: nameController,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomTextField(
//                         label: 'Email',
//                         controller: emailController,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomTextField(
//                         label: 'Password',
//                         controller: passwordController,
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: 20),

//                       RoleSelector(
//                         selectedRole: selectedRole,
//                         onChanged: (role) {
//                           setState(() {
//                             selectedRole = role;
//                           });
//                         },
//                       ),

//                       if (selectedRole == 'Admin') ...[
//                         const SizedBox(height: 10),
//                         CustomTextField(
//                           label: 'Admin Code',
//                           controller: adminCodeController,
//                         ),
//                       ],

//                       const SizedBox(height: 25),

//                       // 🔹 UPDATED BUTTON WITH USER FEEDBACK
//                       PrimaryButton(
//                         text: 'Create Account',
//                         onPressed: () async {
//                           // Immediate feedback
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                   'Creating account, please wait...'),
//                               duration: Duration(seconds: 2),
//                             ),
//                           );

//                           final authService = AuthService();

//                           final error = await authService.signUp(
//                             name: nameController.text.trim(),
//                             email: emailController.text.trim(),
//                             password:
//                                 passwordController.text.trim(),
//                             role: selectedRole,
//                           );

//                           if (error != null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(error),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Account created! Verification email sent 📧',
//                                 ),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );

//                             // Let user see the success message
//                             await Future.delayed(
//                                 const Duration(seconds: 1));

//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     const VerifyEmailScreen(),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // 🔹 Back Button
//           Positioned(
//             top: 45,
//             left: 15,
//             child: IconButton(
//               icon:
//                   const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';
import 'role_selector.dart';
import '../services/auth_service.dart';
import '../services/auth_gate.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final adminCodeController = TextEditingController();

  String selectedRole = 'Couple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_page_bg.jpg'),
                fit: BoxFit.cover,
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

          Center(
            child: SingleChildScrollView(
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
                    const Text(
                      'Create Account 💍',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join SmartWed and start planning today',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    CustomTextField(
                      label: 'Full Name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: 'Password',
                      controller: passwordController,
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    RoleSelector(
                      selectedRole: selectedRole,
                      onChanged: (role) {
                        setState(() {
                          selectedRole = role;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    PrimaryButton(
                      text: 'Create Account',
                      onPressed: () async {
                        final authService = AuthService();

                        final error = await authService.signUp(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          role: selectedRole,
                        );

                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AuthGate()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 45,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

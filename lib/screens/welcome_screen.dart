// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import '../auth/login_screen.dart';

// class AnimatedWelcomeScreen extends StatefulWidget {
//   const AnimatedWelcomeScreen({super.key});

//   @override
//   State<AnimatedWelcomeScreen> createState() =>
//       _AnimatedWelcomeScreenState();
// }

// class _AnimatedWelcomeScreenState extends State<AnimatedWelcomeScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _textController;
//   late Animation<double> _textAnimation;

//   late AnimationController _buttonController;
//   late Animation<Offset> _buttonAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     _textAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: Curves.easeIn,
//       ),
//     );

//     _buttonController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     _buttonAnimation = Tween<Offset>(
//       begin: const Offset(0, 1.5),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _buttonController,
//         curve: Curves.easeOut,
//       ),
//     );

//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await _textController.forward();
//       await _buttonController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     _buttonController.dispose();
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
//                 image: AssetImage('assets/images/wedding_bg.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.65),
//                   Colors.black.withOpacity(0.25),
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//             ),
//           ),
//           const Positioned(
//             top: 60,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 '✨',
//                 style: TextStyle(fontSize: 48),
//               ),
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   FadeTransition(
//                     opacity: _textAnimation,
//                     child: const Text(
//                       'Welcome to SmartWed',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   FadeTransition(
//                     opacity: _textAnimation,
//                     child: const Text(
//                       'Plan your dream wedding effortlessly\n'
//                       'with our all-in-one wedding app!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 45),

//                   SlideTransition(
//                     position: _buttonAnimation,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pinkAccent,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 50,
//                           vertical: 16,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 6,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => LoginScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Get Started',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../services/auth_gate.dart';

class AnimatedWelcomeScreen extends StatefulWidget {
  const AnimatedWelcomeScreen({super.key});

  @override
  State<AnimatedWelcomeScreen> createState() =>
      _AnimatedWelcomeScreenState();
}

class _AnimatedWelcomeScreenState extends State<AnimatedWelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  late AnimationController _buttonController;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _buttonAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOut,
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _textController.forward();
      await _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wedding_bg.jpg'),
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
                  Colors.black.withOpacity(0.25),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // ✨ Decorative Icon
          const Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '✨',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),

          // 🔹 Main Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _textAnimation,
                    child: const Text(
                      'Welcome to SmartWed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _textAnimation,
                    child: const Text(
                      'Plan your dream wedding effortlessly\n'
                      'with our all-in-one wedding app!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 45),

                  // 🔘 GET STARTED BUTTON (LOGIC UPDATED)
                  SlideTransition(
                    position: _buttonAnimation,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        // ✅ Move to AuthGate (decides login or dashboard)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AuthGate(),
                          ),
                        );
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

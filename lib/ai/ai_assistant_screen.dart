import 'package:flutter/material.dart';
import 'dialogflow_service.dart'; // ✅ Dialogflow service
import 'openrouter_service.dart';


class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false; // 🔒 unchanged

 Future<void> _sendMessage(String text) async {
  if (text.trim().isEmpty || isLoading) return;

  setState(() {
    messages.add({'role': 'user', 'text': text});
    isLoading = true;
  });

  controller.clear();

  final reply = await OpenRouterService.sendMessage(text);

  setState(() {
    messages.add({'role': 'ai', 'text': reply});
    isLoading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartWed AI Assistant'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.pinkAccent
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          // 🔹 Quick Prompts (UNCHANGED)
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _promptButton('Budget'),
                _promptButton('Timeline'),
                _promptButton('Checklist'),
                _promptButton('Vendor'),
              ],
            ),
          ),

          // 🔹 Input (UNCHANGED)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask SmartWed...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _promptButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: OutlinedButton(
        onPressed: () => _sendMessage(text),
        child: Text(text),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'ai_engine.dart';
// import 'dialogflow_service.dart';


// class AIAssistantScreen extends StatefulWidget {
//   const AIAssistantScreen({super.key});

//   @override
//   State<AIAssistantScreen> createState() => _AIAssistantScreenState();
// }

// class _AIAssistantScreenState extends State<AIAssistantScreen> {
//   final TextEditingController controller = TextEditingController();
//   final List<Map<String, String>> messages = [];
//   bool isLoading = false; // 🔒 added

//   // ✅ UPDATED METHOD (Cloud AI + limits safe)
//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty || isLoading) return;

//     setState(() {
//       messages.add({'role': 'user', 'text': text});
//       isLoading = true;
//     });

//     controller.clear();

//     final reply = await AICloudService.askAI(text);

//     setState(() {
//       messages.add({'role': 'ai', 'text': reply});
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SmartWed AI Assistant'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 final isUser = msg['role'] == 'user';

//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 6),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isUser
//                           ? Colors.pinkAccent
//                           : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(
//                       msg['text']!,
//                       style: TextStyle(
//                         color: isUser ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           if (isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8),
//               child: CircularProgressIndicator(),
//             ),

//           // 🔹 Quick Prompts (UNCHANGED)
//           SizedBox(
//             height: 50,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 _promptButton('Budget'),
//                 _promptButton('Timeline'),
//                 _promptButton('Checklist'),
//                 _promptButton('Vendor'),
//               ],
//             ),
//           ),

//           // 🔹 Input (UNCHANGED)
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Ask SmartWed...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _sendMessage(controller.text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _promptButton(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: OutlinedButton(
//         onPressed: () => _sendMessage(text),
//         child: Text(text),
//       ),
//     );
//   }
// }


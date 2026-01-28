import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class CreateInvitationScreen extends StatefulWidget {
  const CreateInvitationScreen({super.key});

  @override
  State<CreateInvitationScreen> createState() =>
      _CreateInvitationScreenState();
}

class _CreateInvitationScreenState extends State<CreateInvitationScreen> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  final List<String> numbers = [];
  File? weddingCardImage; // ✅ IMAGE ADDED

  static const int maxGuests = 20;

  // 🖼️ PICK IMAGE
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (picked != null) {
      setState(() {
        weddingCardImage = File(picked.path);
      });
    }
  }

  // 📞 ADD NUMBER
  void _addNumber() {
    final text = numberController.text.trim();
    if (text.isEmpty) return;

    final isValid = RegExp(r'^\+?[0-9]{10,15}$').hasMatch(text);
    if (!isValid) {
      _showSnack('Invalid phone number format');
      return;
    }

    if (numbers.length >= maxGuests) {
      _showSnack('Maximum $maxGuests guests allowed');
      return;
    }

    if (!numbers.contains(text)) {
      setState(() => numbers.add(text));
    }

    numberController.clear();
  }

  // ❌ REMOVE NUMBER
  void _removeNumber(String number) {
    setState(() => numbers.remove(number));
  }

  // 💾 SAVE TO FIRESTORE
  Future<void> _saveInvitation(String platform) async {
    await FirebaseFirestore.instance.collection('invitations').add({
      'coupleId': FirebaseAuth.instance.currentUser!.uid,
      'messageText': messageController.text.trim(),
      'guestNumbers': numbers,
      'sentVia': platform,
      'hasImage': weddingCardImage != null,
      'createdAt': Timestamp.now(),
    });
  }

Future<void> _sendViaWhatsApp() async {
  final messageText = messageController.text.trim();

  if (messageText.isEmpty) {
    _showSnack('Message is required');
    return;
  }

  await _saveInvitation('whatsapp');

  final uri = Uri.parse(
    'https://api.whatsapp.com/send?text=${Uri.encodeComponent(messageText)}',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    _showSnack('Unable to open WhatsApp');
  }
}


  // ✅ WHATSAPP (TEXT ONLY — ORIGINAL WORKING LOGIC)
  // Future<void> _sendViaWhatsApp() async {
  //   final message = Uri.encodeComponent(messageController.text.trim());

  //   if (message.isEmpty || numbers.isEmpty) {
  //     _showSnack('Message and guests required');
  //     return;
  //   }

  //   await _saveInvitation('whatsapp');

  //   for (final number in numbers) {
  //     final uri = Uri.parse(
  //       'https://wa.me/${number.replaceAll('+', '')}?text=$message',
  //     );

  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.externalApplication);
  //     }
  //   }
  // }

  // ✅ SHARE VIA APPS (IMAGE + TEXT)
  Future<void> _sendViaShare() async {
    final message = messageController.text.trim();

    if (message.isEmpty || numbers.isEmpty) {
      _showSnack('Message and guests required');
      return;
    }

    await _saveInvitation('share');

    if (weddingCardImage != null) {
      await Share.shareXFiles(
        [XFile(weddingCardImage!.path)],
        text: message,
      );
    } else {
      await Share.share(message);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wedding Invitation'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 MESSAGE
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Invitation Message',
                hintText: 'You are invited to our wedding...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 🖼️ IMAGE PICKER
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pinkAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: weddingCardImage == null
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo, size: 40),
                            Text('Tap to select wedding card'),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          weddingCardImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // 📞 ADD NUMBER
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Add Guest Number',
                      hintText: '+923001234567',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.pinkAccent),
                  onPressed: _addNumber,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 👥 NUMBER CHIPS
            Wrap(
              spacing: 8,
              children: numbers
                  .map(
                    (n) => Chip(
                      label: Text(n),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => _removeNumber(n),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 30),

            // 🚀 WHATSAPP BUTTON (UNCHANGED BEHAVIOR)
            ElevatedButton.icon(
              icon: const Icon(Icons.chat),
              label: const Text('Send via WhatsApp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: _sendViaWhatsApp,
            ),

            const SizedBox(height: 12),

            // 📤 SHARE BUTTON (IMAGE + TEXT)
            OutlinedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share via Apps'),
              onPressed: _sendViaShare,
            ),
          ],
        ),
      ),
    );
  }
}

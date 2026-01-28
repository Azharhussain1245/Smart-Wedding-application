// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AddSongScreen extends StatelessWidget {
//   final String playlistId;

//   const AddSongScreen({super.key, required this.playlistId});

//   @override
//   Widget build(BuildContext context) {
//     final titleController = TextEditingController();
//     final artistController = TextEditingController();
//     final userId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Song'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration:
//                   const InputDecoration(labelText: 'Song Title'),
//             ),
//             TextField(
//               controller: artistController,
//               decoration:
//                   const InputDecoration(labelText: 'Artist'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (titleController.text.isEmpty ||
//                     artistController.text.isEmpty) return;

//                 await FirebaseFirestore.instance
//                     .collection('playlists')
//                     .doc(userId)
//                     .collection('lists')
//                     .doc(playlistId)
//                     .collection('songs')
//                     .add({
//                   'title': titleController.text.trim(),
//                   'artist': artistController.text.trim(),
//                   'createdAt': Timestamp.now(),
//                 });

//                 Navigator.pop(context);
//               },
//               child: const Text('Add Song'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSongScreen extends StatefulWidget {
  final String playlistId;
  final DocumentSnapshot? songDoc; // NULL = ADD, NOT NULL = EDIT

  const AddSongScreen({
    super.key,
    required this.playlistId,
    this.songDoc,
  });

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.songDoc != null) {
      final data = widget.songDoc!.data() as Map<String, dynamic>;
      _titleController.text = data['title'] ?? '';
      _artistController.text = data['artist'] ?? '';
      _urlController.text = data['url'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.songDoc == null ? 'Add Song' : 'Edit Song'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Song Title'),
            ),
            TextField(
              controller: _artistController,
              decoration: const InputDecoration(labelText: 'Artist'),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'YouTube / URL (optional)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _artistController.text.isEmpty) return;

                final songData = {
                  'title': _titleController.text.trim(),
                  'artist': _artistController.text.trim(),
                  'url': _urlController.text.trim(),
                  'createdAt': Timestamp.now(),
                };

                final songsRef = FirebaseFirestore.instance
                    .collection('playlists')
                    .doc(userId)
                    .collection('lists')
                    .doc(widget.playlistId)
                    .collection('songs');

                if (widget.songDoc == null) {
                  await songsRef.add(songData);
                } else {
                  await widget.songDoc!.reference.update(songData);
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

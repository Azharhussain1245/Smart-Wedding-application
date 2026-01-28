import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'song_list_screen.dart';

class PlaylistListScreen extends StatelessWidget {
  const PlaylistListScreen({super.key});

  // 🔹 CREATE / RENAME PLAYLIST DIALOG
  Future<void> _showPlaylistDialog(
    BuildContext context,
    String userId, {
    String? playlistId,
    String? currentName,
  }) async {
    final controller = TextEditingController(text: currentName ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(playlistId == null ? 'Create Playlist' : 'Rename Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Playlist name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              final ref = FirebaseFirestore.instance
                  .collection('playlists')
                  .doc(userId)
                  .collection('lists');

              if (playlistId == null) {
                // ✅ CREATE
                await ref.add({'name': name});
              } else {
                // ✅ UPDATE
                await ref.doc(playlistId).update({'name': name});
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // 🔹 DELETE PLAYLIST
  Future<void> _deletePlaylist(
      BuildContext context, String userId, String playlistId) async {
    await FirebaseFirestore.instance
        .collection('playlists')
        .doc(userId)
        .collection('lists')
        .doc(playlistId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedding Playlists'),
        backgroundColor: Colors.pinkAccent,
      ),

      // ➕ CREATE PLAYLIST
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed: () => _showPlaylistDialog(context, userId),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('playlists')
            .doc(userId)
            .collection('lists')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final playlists = snapshot.data!.docs;

          if (playlists.isEmpty) {
            return const Center(child: Text('No playlists created'));
          }

          return ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];

              return ListTile(
                leading: const Icon(Icons.queue_music),
                title: Text(playlist['name']),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showPlaylistDialog(
                        context,
                        userId,
                        playlistId: playlist.id,
                        currentName: playlist['name'],
                      );
                    } else if (value == 'delete') {
                      _deletePlaylist(context, userId, playlist.id);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Rename')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongListScreen(
                        playlistId: playlist.id,
                        playlistName: playlist['name'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'song_list_screen.dart';

// class PlaylistListScreen extends StatelessWidget {
//   const PlaylistListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wedding Playlists'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.pinkAccent,
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await FirebaseFirestore.instance
//               .collection('playlists')
//               .doc(userId)
//               .collection('lists')
//               .add({'name': 'New Playlist'});
//         },
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('playlists')
//             .doc(userId)
//             .collection('lists')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final playlists = snapshot.data!.docs;

//           if (playlists.isEmpty) {
//             return const Center(child: Text('No playlists created'));
//           }

//           return ListView.builder(
//             itemCount: playlists.length,
//             itemBuilder: (context, index) {
//               final playlist = playlists[index];

//               return ListTile(
//                 leading: const Icon(Icons.queue_music),
//                 title: Text(playlist['name']),
//                 trailing: const Icon(Icons.arrow_forward_ios),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => SongListScreen(
//                         playlistId: playlist.id,
//                         playlistName: playlist['name'],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

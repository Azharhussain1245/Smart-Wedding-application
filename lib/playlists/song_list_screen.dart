// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'add_song_screen.dart';

// class SongListScreen extends StatelessWidget {
//   final String playlistId;
//   final String playlistName;

//   const SongListScreen({
//     super.key,
//     required this.playlistId,
//     required this.playlistName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(playlistName),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.pinkAccent,
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AddSongScreen(
//                 playlistId: playlistId,
//               ),
//             ),
//           );
//         },
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('playlists')
//             .doc(userId)
//             .collection('lists')
//             .doc(playlistId)
//             .collection('songs')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final songs = snapshot.data!.docs;

//           if (songs.isEmpty) {
//             return const Center(child: Text('No songs added yet'));
//           }

//           return ListView.builder(
//             itemCount: songs.length,
//             itemBuilder: (context, index) {
//               final song = songs[index];
//               final data = song.data() as Map<String, dynamic>;
//               final url = data['url'];

//               return ListTile(
//                 leading: const Icon(Icons.music_note),
//                 title: Text(data['title']),
//                 subtitle: Text(data['artist']),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (url != null && url.toString().isNotEmpty)
//                       IconButton(
//                         icon: const Icon(Icons.play_circle_fill),
//                         onPressed: () async {
//                           final uri = Uri.parse(url);
//                           if (await canLaunchUrl(uri)) {
//                             await launchUrl(uri);
//                           }
//                         },
//                       ),
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => AddSongScreen(
//                               playlistId: playlistId,
//                               songDoc: song,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon:
//                           const Icon(Icons.delete, color: Colors.redAccent),
//                       onPressed: () async {
//                         await song.reference.delete();
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'add_song_screen.dart';
import 'youtube_player_screen.dart';

class SongListScreen extends StatelessWidget {
  final String playlistId;
  final String playlistName;

  const SongListScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
        backgroundColor: Colors.pinkAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSongScreen(
                playlistId: playlistId,
              ),
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('playlists')
            .doc(userId)
            .collection('lists')
            .doc(playlistId)
            .collection('songs')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final songs = snapshot.data!.docs;

          if (songs.isEmpty) {
            return const Center(child: Text('No songs added yet'));
          }

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              final data = song.data() as Map<String, dynamic>;
              final url = data['url'] ?? '';

              final isYoutube =
                  YoutubePlayer.convertUrlToId(url) != null;

              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(data['title']),
                subtitle: Text(data['artist']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isYoutube)
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YoutubePlayerScreen(
                                youtubeUrl: url,
                              ),
                            ),
                          );
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddSongScreen(
                              playlistId: playlistId,
                              songDoc: song,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.redAccent),
                      onPressed: () async {
                        await song.reference.delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

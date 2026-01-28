// import 'package:flutter/material.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListView(
//         children: const [
//           ListTile(
//             leading: Icon(Icons.lock),
//             title: Text('Change Admin Password'),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.warning),
//             title: Text('Maintenance Mode'),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.info),
//             title: Text('App Version'),
//             subtitle: Text('SmartWed v1.0.0'),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _maintenanceMode = false;
  bool _loading = true;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // 🔹 Load settings from Firestore
  Future<void> _loadSettings() async {
    final doc =
        await _firestore.collection('app_config').doc('global').get();

    if (doc.exists) {
      _maintenanceMode = doc['maintenanceMode'] ?? false;
    }

    setState(() => _loading = false);
  }

  // 🔹 Toggle maintenance mode
  Future<void> _toggleMaintenance(bool value) async {
    setState(() => _maintenanceMode = value);

    await _firestore.collection('app_config').doc('global').set(
      {'maintenanceMode': value},
      SetOptions(merge: true),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Maintenance mode enabled'
              : 'Maintenance mode disabled',
        ),
      ),
    );
  }

  // 🔹 Change admin password
  Future<void> _changePassword() async {
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Admin Password'),
        content: TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New Password',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _auth.currentUser!
                    .updatePassword(newPasswordController.text);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password updated successfully'),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // 🔹 Logout
  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // 🔹 ADMIN SECTION
          _sectionHeader('Admin'),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Admin Password'),
            onTap: _changePassword,
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _logout,
          ),

          // 🔹 SYSTEM SECTION
          _sectionHeader('System'),

          SwitchListTile(
            secondary: const Icon(Icons.warning_amber),
            title: const Text('Maintenance Mode'),
            subtitle: const Text(
              'Disable app access for users & vendors',
            ),
            value: _maintenanceMode,
            onChanged: _toggleMaintenance,
          ),

          // 🔹 APP INFO
          _sectionHeader('App Information'),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text('App Version'),
            subtitle: Text('SmartWed v1.0.0'),
          ),

          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Environment'),
            subtitle: Text('Production'),
          ),
        ],
      ),
    );
  }

  // 🔹 Section Header Widget
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

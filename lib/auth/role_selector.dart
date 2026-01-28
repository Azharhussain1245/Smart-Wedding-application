import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final Function(String) onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ['Couple', 'Vendor', 'Admin'].map((role) {
        return RadioListTile(
          title: Text(role),
          value: role,
          groupValue: selectedRole,
          onChanged: (value) => onChanged(value!),
        );
      }).toList(),
    );
  }
}

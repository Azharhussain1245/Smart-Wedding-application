import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendor_profile_screen.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  String selectedCity = 'All';
  String selectedCategory = 'All';

  final cities = ['All', 'Karachi', 'Lahore', 'Islamabad'];
  final categories = [
    'All',
    'Photographer',
    'Catering',
    'Decoration',
    'DJ',
    'Event Planner'
  ];

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('vendors')
        .where('status', isEqualTo: 'approved');

    if (selectedCity != 'All') {
      query = query.where('location.city', isEqualTo: selectedCity);
    }

    if (selectedCategory != 'All') {
      query =
          query.where('categories', arrayContains: selectedCategory);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Vendors'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          _FilterBar(
            cities: cities,
            categories: categories,
            selectedCity: selectedCity,
            selectedCategory: selectedCategory,
            onCityChanged: (v) => setState(() => selectedCity = v),
            onCategoryChanged: (v) =>
                setState(() => selectedCategory = v),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final vendors = snapshot.data!.docs;

                if (vendors.isEmpty) {
                  return const Center(
                      child: Text('No vendors found'));
                }

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    final vendor =
                        vendors[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(vendor['companyName']),
                        subtitle: Text(
                          vendor['categories'].join(', '),
                        ),
                        trailing: const Icon(
                            Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VendorProfileScreen(
                                vendorId: vendors[index].id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final List<String> cities;
  final List<String> categories;
  final String selectedCity;
  final String selectedCategory;
  final Function(String) onCityChanged;
  final Function(String) onCategoryChanged;

  const _FilterBar({
    required this.cities,
    required this.categories,
    required this.selectedCity,
    required this.selectedCategory,
    required this.onCityChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: selectedCity,
              isExpanded: true,
              items: cities
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (v) => onCityChanged(v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (v) => onCategoryChanged(v!),
            ),
          ),
        ],
      ),
    );
  }
}

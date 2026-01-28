// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'add_category_screen.dart';
// import 'add_expense_screen.dart';

// class BudgetScreen extends StatelessWidget {
//   const BudgetScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//     final budgetDoc =
//         FirebaseFirestore.instance.collection('budgets').doc(userId);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Budget Tracker'),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.pinkAccent,
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddCategoryScreen()),
//           );
//         },
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: budgetDoc.snapshots(),
//         builder: (context, budgetSnapshot) {
//           if (!budgetSnapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final budgetData =
//               budgetSnapshot.data!.data() as Map<String, dynamic>? ?? {};

//           final num weddingTotalBudget =
//               budgetData['weddingTotalBudget'] ?? 0;

//           return StreamBuilder<QuerySnapshot>(
//             stream: budgetDoc.collection('categories').snapshots(),
//             builder: (context, categorySnapshot) {
//               if (!categorySnapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final categories = categorySnapshot.data!.docs;

//               num spendingBudget = 0;
//               for (final doc in categories) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 spendingBudget += (data['amountSpent'] ?? 0);
//               }

//               final num remainingBudget =
//                   (weddingTotalBudget - spendingBudget)
//                       .clamp(0, double.infinity);

//               return Column(
//                 children: [
//                   _BudgetHeader(
//                     weddingTotalBudget: weddingTotalBudget,
//                     spendingBudget: spendingBudget,
//                     remainingBudget: remainingBudget,
//                     onUpdateWeddingBudget: (value) {
//                       budgetDoc.update({'weddingTotalBudget': value});
//                     },
//                   ),
//                   Expanded(
//                     child: categories.isEmpty
//                         ? const Center(
//                             child: Text('No budget categories added'),
//                           )
//                         : ListView(
//                             children: categories.map((doc) {
//                               return _CategoryTile(
//                                 userId: userId,
//                                 categoryDoc: doc,
//                               );
//                             }).toList(),
//                           ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// ////////////////////////////////////////////////////////////
// /// HEADER
// ////////////////////////////////////////////////////////////
// class _BudgetHeader extends StatelessWidget {
//   final num weddingTotalBudget;
//   final num spendingBudget;
//   final num remainingBudget;
//   final Function(num) onUpdateWeddingBudget;

//   const _BudgetHeader({
//     required this.weddingTotalBudget,
//     required this.spendingBudget,
//     required this.remainingBudget,
//     required this.onUpdateWeddingBudget,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller =
//         TextEditingController(text: weddingTotalBudget.toString());

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Text(
//                 'Total Wedding Budget: ',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter total budget',
//                   ),
//                   onSubmitted: (value) {
//                     final num newValue = num.tryParse(value) ?? 0;
//                     onUpdateWeddingBudget(newValue);
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'Spending Budget: Rs. $spendingBudget',
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             'Remaining Budget: Rs. $remainingBudget',
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.red,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Expenses by Category',
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ////////////////////////////////////////////////////////////
// /// CATEGORY TILE (UNCHANGED LOGIC)
// ////////////////////////////////////////////////////////////
// class _CategoryTile extends StatefulWidget {
//   final String userId;
//   final QueryDocumentSnapshot categoryDoc;

//   const _CategoryTile({
//     required this.userId,
//     required this.categoryDoc,
//   });

//   @override
//   State<_CategoryTile> createState() => _CategoryTileState();
// }

// class _CategoryTileState extends State<_CategoryTile> {
//   bool expanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final data = widget.categoryDoc.data() as Map<String, dynamic>;
//     final categoryId = widget.categoryDoc.id;
//     final name = data['name'];
//     final amountSpent = data['amountSpent'] ?? 0;
//     final done = data['done'] ?? false;

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Column(
//         children: [
//           ListTile(
//             leading: Checkbox(
//               value: done,
//               onChanged: (v) {
//                 widget.categoryDoc.reference.update({'done': v});
//               },
//             ),
//             title: Text(
//               name,
//               style: TextStyle(
//                 decoration:
//                     done ? TextDecoration.lineThrough : TextDecoration.none,
//               ),
//             ),
//             subtitle: Text('Spent: Rs. $amountSpent'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(expanded
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down),
//                   onPressed: () {
//                     setState(() => expanded = !expanded);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     final expenses = await widget.categoryDoc.reference
//                         .collection('expenses')
//                         .get();

//                     for (final e in expenses.docs) {
//                       await e.reference.delete();
//                     }

//                     await widget.categoryDoc.reference.delete();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           if (expanded)
//             StreamBuilder<QuerySnapshot>(
//               stream: widget.categoryDoc.reference
//                   .collection('expenses')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const SizedBox();

//                 final expenses = snapshot.data!.docs;

//                 return Column(
//                   children: [
//                     ...expenses.map((e) {
//                       final eData = e.data() as Map<String, dynamic>;
//                       final eDone = eData['done'] ?? false;
//                       final eAmount = eData['amount'] ?? 0;

//                       return ListTile(
//                         contentPadding:
//                             const EdgeInsets.only(left: 60, right: 16),
//                         leading: Checkbox(
//                           value: eDone,
//                           onChanged: (v) {
//                             e.reference.update({'done': v});
//                           },
//                         ),
//                         title: Text(
//                           eData['title'],
//                           style: TextStyle(
//                             decoration: eDone
//                                 ? TextDecoration.lineThrough
//                                 : TextDecoration.none,
//                           ),
//                         ),
//                         subtitle: Text('Rs. $eAmount'),
//                         trailing: IconButton(
//                           icon:
//                               const Icon(Icons.delete, color: Colors.redAccent),
//                           onPressed: () async {
//                             await e.reference.delete();
//                             await widget.categoryDoc.reference.update({
//                               'amountSpent':
//                                   FieldValue.increment(-eAmount),
//                             });
//                           },
//                         ),
//                       );
//                     }),
//                     TextButton.icon(
//                       icon: const Icon(Icons.add),
//                       label: const Text('Add Expense'),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 AddExpenseScreen(categoryId: categoryId),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_category_screen.dart';
import 'add_expense_screen.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        backgroundColor: Colors.pinkAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddCategoryScreen(),
            ),
          );
        },
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('budgets')
            .doc(userId)
            .snapshots(),
        builder: (context, budgetSnapshot) {
          if (!budgetSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final budgetData =
              budgetSnapshot.data!.data() as Map<String, dynamic>? ?? {};

          final weddingTotalBudget =
              budgetData['weddingTotalBudget'] ?? 0;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('budgets')
                .doc(userId)
                .collection('categories')
                .snapshots(),
            builder: (context, categorySnapshot) {
              if (!categorySnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final categories = categorySnapshot.data!.docs;

              /// ✅ SPENDING BUDGET (AUTO)
              num spendingBudget = 0;
              for (final doc in categories) {
                final data = doc.data() as Map<String, dynamic>;
                spendingBudget += (data['amountSpent'] ?? 0);
              }

              /// ✅ REMAINING BUDGET (FINAL FIX)
              final remainingBudget =
                  weddingTotalBudget - spendingBudget;

              return Column(
                children: [
                  _BudgetHeader(
                    weddingTotalBudget: weddingTotalBudget,
                    spendingBudget: spendingBudget,
                    remainingBudget: remainingBudget,
                    userId: userId,
                  ),
                  Expanded(
                    child: categories.isEmpty
                        ? const Center(
                            child: Text('No budget categories added'),
                          )
                        : ListView(
                            children: categories.map((doc) {
                              return _CategoryTile(
                                userId: userId,
                                categoryDoc: doc,
                              );
                            }).toList(),
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HEADER
////////////////////////////////////////////////////////////
class _BudgetHeader extends StatelessWidget {
  final num weddingTotalBudget;
  final num spendingBudget;
  final num remainingBudget;
  final String userId;

  const _BudgetHeader({
    required this.weddingTotalBudget,
    required this.spendingBudget,
    required this.remainingBudget,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        TextEditingController(text: weddingTotalBudget.toString());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOTAL WEDDING BUDGET (USER INPUT)
          Row(
            children: [
              const Text(
                'Total Wedding Budget: ',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                  ),
                  onSubmitted: (value) {
                    final num newValue =
                        num.tryParse(value) ?? 0;

                    FirebaseFirestore.instance
                        .collection('budgets')
                        .doc(userId)
                        .set(
                      {'weddingTotalBudget': newValue},
                      SetOptions(merge: true),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// SPENDING
          Text(
            'Spending Budget: Rs. $spendingBudget',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          /// REMAINING (FIXED)
          Text(
            'Remaining Budget: Rs. $remainingBudget',
            style: TextStyle(
              fontSize: 16,
              color:
                  remainingBudget < 0 ? Colors.red : Colors.green,
            ),
          ),

          const SizedBox(height: 14),
          const Text(
            'Expenses by Category',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// CATEGORY TILE (UNCHANGED)
////////////////////////////////////////////////////////////
class _CategoryTile extends StatefulWidget {
  final String userId;
  final QueryDocumentSnapshot categoryDoc;

  const _CategoryTile({
    required this.userId,
    required this.categoryDoc,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.categoryDoc.data() as Map<String, dynamic>;
    final categoryId = widget.categoryDoc.id;
    final name = data['name'];
    final amountSpent = data['amountSpent'] ?? 0;
    final done = data['done'] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: done,
              onChanged: (v) {
                widget.categoryDoc.reference.update({'done': v});
              },
            ),
            title: Text(
              name,
              style: TextStyle(
                decoration:
                    done ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text('Spent: Rs. $amountSpent'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onPressed: () {
                    setState(() => expanded = !expanded);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final expenses = await widget.categoryDoc
                        .reference
                        .collection('expenses')
                        .get();

                    for (final e in expenses.docs) {
                      await e.reference.delete();
                    }

                    await widget.categoryDoc.reference.delete();
                  },
                ),
              ],
            ),
          ),

          if (expanded)
            StreamBuilder<QuerySnapshot>(
              stream: widget.categoryDoc.reference
                  .collection('expenses')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final expenses = snapshot.data!.docs;

                return Column(
                  children: [
                    ...expenses.map((e) {
                      final eData =
                          e.data() as Map<String, dynamic>;
                      final eDone = eData['done'] ?? false;
                      final eAmount = eData['amount'] ?? 0;

                      return ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 60),
                        leading: Checkbox(
                          value: eDone,
                          onChanged: (v) {
                            e.reference.update({'done': v});
                          },
                        ),
                        title: Text(
                          eData['title'],
                          style: TextStyle(
                            decoration: eDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text('Rs. $eAmount'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () async {
                            await e.reference.delete();

                            await widget.categoryDoc.reference
                                .update({
                              'amountSpent':
                                  FieldValue.increment(-eAmount),
                            });
                          },
                        ),
                      );
                    }),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Expense'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddExpenseScreen(
                                  categoryId: categoryId,
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

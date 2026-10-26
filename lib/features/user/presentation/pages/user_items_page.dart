import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/features/item/presentation/pages/item_page.dart';
import 'package:lost_and_found/features/item/presentation/pages/insert_item_page.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('My posts')),
      body: userId == null
          ? const Center(child: Text('Sign in to view your posts.'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('ownerId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Could not load your posts.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final posts = snapshot.data?.docs.toList() ?? [];
                posts.sort((a, b) => _dateValue(b.data()['createdAt'])
                    .compareTo(_dateValue(a.data()['createdAt'])));
                if (posts.isEmpty) {
                  return const Center(
                      child: Text('You have not posted any items yet.'));
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return _UserItemTile.fromData(
                      itemId: post.id,
                      data: post.data(),
                    );
                  },
                );
              },
            ),
    );
  }
}

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved items')),
      body: userId == null
          ? const Center(child: Text('Sign in to view saved items.'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('savedItems')
                  .snapshots(),
              builder: (context, savedSnapshot) {
                if (savedSnapshot.hasError) {
                  return const Center(
                      child: Text('Could not load your saved items.'));
                }
                if (savedSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final savedItems = savedSnapshot.data?.docs.toList() ?? [];
                savedItems.sort((a, b) => _dateValue(b.data()['savedAt'])
                    .compareTo(_dateValue(a.data()['savedAt'])));
                if (savedItems.isEmpty) {
                  return const Center(
                      child: Text('You have no bookmarked items yet.'));
                }
                return ListView(
                  children: [
                    for (final savedItem in savedItems)
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('items')
                            .doc(savedItem.id)
                            .get(),
                        builder: (context, itemSnapshot) {
                          if (itemSnapshot.hasError) {
                            return const ListTile(
                              leading: Icon(Icons.error_outline),
                              title: Text('Could not load this saved item.'),
                            );
                          }
                          if (itemSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ListTile(
                              leading: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              title: Text('Loading saved item...'),
                            );
                          }
                          final data = itemSnapshot.data?.data();
                          if (data == null) {
                            return const ListTile(
                              leading: Icon(Icons.inventory_2_outlined),
                              title: Text(
                                  'This saved item is no longer available.'),
                            );
                          }
                          return _UserItemTile.fromData(
                            itemId: savedItem.id,
                            data: data,
                          );
                        },
                      ),
                  ],
                );
              },
            ),
    );
  }
}

class DraftsScreen extends StatelessWidget {
  const DraftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Drafts')),
      body: userId == null
          ? const Center(child: Text('Sign in to view your drafts.'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('drafts')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Could not load your drafts.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final drafts = snapshot.data?.docs.toList() ?? [];
                drafts.sort((a, b) => _dateValue(b.data()['savedAt'])
                    .compareTo(_dateValue(a.data()['savedAt'])));
                if (drafts.isEmpty) {
                  return const Center(child: Text('You have no drafts yet.'));
                }
                return ListView.builder(
                  itemCount: drafts.length,
                  itemBuilder: (context, index) {
                    final draft = drafts[index];
                    return _DraftTile(
                      draftId: draft.id,
                      data: draft.data(),
                      userId: userId,
                    );
                  },
                );
              },
            ),
    );
  }
}

class _DraftTile extends StatelessWidget {
  final String draftId;
  final String userId;
  final Map<String, dynamic> data;

  const _DraftTile({
    required this.draftId,
    required this.userId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final title = (data['title'] as String? ?? '').trim();
    final status = data['status'] as String? ?? 'lost';
    final category = data['category'] as String? ?? 'Other';
    final draftImagePath = data['imagePath'] as String?;
    return ListTile(
      leading: SizedBox(
        width: 56,
        height: 56,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: draftImagePath != null && File(draftImagePath).existsSync()
              ? Image.file(File(draftImagePath), fit: BoxFit.cover)
              : const Icon(Icons.edit_note_outlined),
        ),
      ),
      title: Text(title.isEmpty ? 'Untitled draft' : title),
      subtitle: Text(
        'Draft · ${status[0].toUpperCase()}${status.substring(1)} · $category',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/insert',
          arguments: InsertItemScreenArguments(
            isNewItemLost: status != 'found',
            draftId: draftId,
            draftData: data,
          ),
        );
      },
      trailing: IconButton(
        tooltip: 'Delete draft',
        icon: const Icon(Icons.delete_outline),
        onPressed: () async {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('drafts')
                .doc(draftId)
                .delete();
          } on FirebaseException catch (error) {
            debugPrint('Could not delete draft $draftId: $error');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not delete this draft.')),
              );
            }
          }
        },
      ),
    );
  }
}

class _UserItemTile extends StatelessWidget {
  final String itemId;
  final Map<String, dynamic> data;

  const _UserItemTile({required this.itemId, required this.data});

  factory _UserItemTile.fromData({
    required String itemId,
    required Map<String, dynamic> data,
  }) =>
      _UserItemTile(itemId: itemId, data: data);

  @override
  Widget build(BuildContext context) {
    final imageUrl = data['imageUrl'] as String?;
    final location = data['location'] as Map<String, dynamic>?;
    final title = data['title'] as String? ?? 'Untitled item';
    final status = data['status'] as String? ?? 'unknown';
    final categoryId = data['categoryId'];
    return ListTile(
      leading: SizedBox(
        width: 56,
        height: 56,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.inventory_2_outlined),
                )
              : const Icon(Icons.inventory_2_outlined),
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          '${status[0].toUpperCase()}${status.substring(1)}',
          _categoryName(categoryId),
          if ((location?['label'] as String? ?? '').isNotEmpty)
            location!['label'] as String,
        ].join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        final numericId = int.tryParse(itemId);
        if (numericId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This item cannot be opened.')),
          );
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ItemScreen(itemId: numericId)),
        );
      },
    );
  }
}

DateTime _dateValue(dynamic value) {
  return value is Timestamp
      ? value.toDate()
      : DateTime.fromMillisecondsSinceEpoch(0);
}

String _categoryName(dynamic categoryId) {
  const names = {
    1: 'Wallets & Purses',
    2: 'Electronics & Gadgets',
    3: 'Keys & Access Cards',
    4: 'Bags & Backpacks',
    5: 'Clothing & Accessories',
    6: 'Documents & IDs',
    7: 'Other Valuables',
  };
  final id =
      categoryId is num ? categoryId.toInt() : int.tryParse('$categoryId');
  return names[id] ?? 'Other';
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/features/chat/presentation/pages/chat_page.dart';
import 'package:lost_and_found/features/item/presentation/pages/item_page.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';

class NotificationsScreen extends StatelessWidget {
  final int? newNewsId;

  const NotificationsScreen({super.key, this.newNewsId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).extension<CustomColors>()?.background2,
        elevation: 0,
        title: const Text('Notifications'),
      ),
      body: uid == null
          ? const Center(child: Text('Sign in to view notifications.'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('recipientId', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint(
                    'Failed to load notifications for $uid: ${snapshot.error}',
                  );
                  return const Center(
                    child:
                        Text('Could not load notifications. Please try again.'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notifications = snapshot.data?.docs.toList() ?? [];
                notifications.sort((a, b) {
                  final aCreatedAt = a.data()['createdAt'];
                  final bCreatedAt = b.data()['createdAt'];
                  final aDate =
                      aCreatedAt is Timestamp ? aCreatedAt : Timestamp(0, 0);
                  final bDate =
                      bCreatedAt is Timestamp ? bCreatedAt : Timestamp(0, 0);
                  return bDate.compareTo(aDate);
                });
                if (notifications.isEmpty) {
                  return const Center(
                      child: Text('You have no notifications yet.'));
                }

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final data = notification.data();
                    final isRead = data['read'] == true;
                    final createdAt = data['createdAt'];
                    final dateLabel = createdAt is Timestamp
                        ? _formatDate(createdAt.toDate())
                        : '';

                    return ListTile(
                      leading: Icon(
                        _iconFor(data['type'] as String?),
                        color: isRead
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        data['title'] as String? ?? 'Notification',
                        style: TextStyle(
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        [
                          if ((data['body'] as String? ?? '').isNotEmpty)
                            data['body'] as String,
                          if (dateLabel.isNotEmpty) dateLabel,
                        ].join('\n'),
                      ),
                      isThreeLine: (data['body'] as String? ?? '').isNotEmpty,
                      tileColor: isRead
                          ? null
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.06),
                      onTap: () => _openNotification(context, notification),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _openNotification(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> notification,
  ) async {
    final data = notification.data();
    if (data['read'] != true) {
      try {
        await notification.reference.update({
          'read': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      } on FirebaseException {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Could not mark this notification as read.')),
          );
        }
        return;
      }
    }
    if (!context.mounted) return;

    final itemValue = data['itemId'];
    final itemId =
        itemValue is num ? itemValue.toInt() : int.tryParse('$itemValue');
    final roomId = data['roomId'] as String?;
    if (data['type'] == 'message' && roomId != null && itemId != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(roomId: roomId, itemId: itemId),
        ),
      );
    } else if (itemId != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ItemScreen(itemId: itemId)),
      );
    }
  }

  IconData _iconFor(String? type) {
    switch (type) {
      case 'message':
        return Icons.chat_bubble_outline_rounded;
      case 'new_claim':
      case 'claim_update':
        return Icons.fact_check_outlined;
      case 'item_match':
        return Icons.devices_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final hour = localDate.hour % 12 == 0 ? 12 : localDate.hour % 12;
    final minute = localDate.minute.toString().padLeft(2, '0');
    final period = localDate.hour < 12 ? 'AM' : 'PM';
    return '${localDate.month}/${localDate.day} $hour:$minute $period';
  }
}

class NotificationsScreenArguments {
  final int newNewsId;

  const NotificationsScreenArguments({required this.newNewsId});
}

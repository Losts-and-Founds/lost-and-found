import '../../../../core/domain/entities/claim_status.dart';

class ClaimReceived {
  final int id;
  final ReceivedItem item;
  final ReceivedUser user;
  final ClaimStatus status;
  bool opened;

  ClaimReceived({
    required this.id,
    required this.item,
    required this.user,
    required this.opened,
    required this.status,
  });
}

class ReceivedItem {
  final int id;
  final String title;

  ReceivedItem({required this.id, required this.title});
}

class ReceivedUser {
  final int id;
  final String username;
  final String? uid;

  ReceivedUser({required this.id, required this.username, this.uid});
}

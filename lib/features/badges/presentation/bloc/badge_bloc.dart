import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_bloc.freezed.dart';

part 'badge_event.dart';

part 'badge_state.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _notificationSubscription;
  String? _activeUid;
  bool _hasInitialized = false;
  int _observedUnreadNews = 0;
  int _observedUnreadClaims = 0;
  bool _observedUnreadSentClaim = false;

  BadgeBloc() : super(BadgeState.initial()) {
    on<BadgeEvent>(
      (event, emit) async {
        await event.when<FutureOr<void>>(
            badgeCreated: () => _onBadgeCreated(emit),
            newsRead: () => _onNewsRead(emit),
            receivedClaimRead: () => _onReceivedClaimRead(emit),
            newNews: () => _onNewNews(emit),
            newReceivedClaim: () => _onNewReceivedClaim(emit),
            sentClaimUpdate: () => _onSentClaimUpdate(emit),
            sentClaimRead: () => _onSentClaimRead(emit),
            chatUpdate: (hasUnreadChats) => _onChatUpdate(emit, hasUnreadChats),
            restoreInitial: () => _onRestoreInitial(emit));
      },
    );
  }

  void _onChatUpdate(Emitter<BadgeState> emit, bool hasChatUpdates) {
    emit(state.copyWith(hasUnreadChats: hasChatUpdates));
  }

  void _onSentClaimRead(Emitter<BadgeState> emit) {
    emit(state.copyWith(hasUnreadSentClaims: false));
  }

  void _onSentClaimUpdate(Emitter<BadgeState> emit) {
    emit(state.copyWith(hasUnreadSentClaims: true));
  }

  void _onNewNews(Emitter<BadgeState> emit) {
    emit(state.copyWith(unreadNews: state.unreadNews + 1));
  }

  void _onNewReceivedClaim(Emitter<BadgeState> emit) {
    emit(state.copyWith(unreadReceivedClaims: state.unreadReceivedClaims + 1));
  }

  void _onNewsRead(Emitter<BadgeState> emit) {
    emit(state.copyWith(unreadNews: state.unreadNews - 1));
  }

  void _onReceivedClaimRead(Emitter<BadgeState> emit) {
    emit(state.copyWith(unreadReceivedClaims: state.unreadReceivedClaims - 1));
  }

  Future<void> _onBadgeCreated(Emitter<BadgeState> emit) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (_hasInitialized && uid == _activeUid) return;
    _hasInitialized = true;
    _activeUid = uid;
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;

    if (uid == null) {
      _observedUnreadNews = 0;
      _observedUnreadClaims = 0;
      _observedUnreadSentClaim = false;
      emit(BadgeState.initial());
      return;
    }

    emit(BadgeState.initial());
    _observedUnreadNews = 0;
    _observedUnreadClaims = 0;
    _observedUnreadSentClaim = false;
    _notificationSubscription = FirebaseFirestore.instance
        .collection('notifications')
        .where('recipientId', isEqualTo: uid)
        .where('read', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      final unreadClaims = snapshot.docs
          .where((doc) => doc.data()['type'] == 'new_claim')
          .length;
      final otherUnread = snapshot.docs.length - unreadClaims;
      final unreadSentClaim =
          snapshot.docs.any((doc) => doc.data()['type'] == 'claim_update');
      while (_observedUnreadNews < otherUnread) {
        _observedUnreadNews++;
        add(const BadgeEvent.newNews());
      }
      while (_observedUnreadNews > otherUnread) {
        _observedUnreadNews--;
        add(const BadgeEvent.newsRead());
      }
      while (_observedUnreadClaims < unreadClaims) {
        _observedUnreadClaims++;
        add(const BadgeEvent.newReceivedClaim());
      }
      while (_observedUnreadClaims > unreadClaims) {
        _observedUnreadClaims--;
        add(const BadgeEvent.receivedClaimRead());
      }
      if (_observedUnreadSentClaim != unreadSentClaim) {
        _observedUnreadSentClaim = unreadSentClaim;
        add(unreadSentClaim
            ? const BadgeEvent.sentClaimUpdate()
            : const BadgeEvent.sentClaimRead());
      }
    }, onError: (Object error, StackTrace stackTrace) {
      debugPrint('Failed to listen for unread notifications: $error');
    });
  }

  Future<void> _onRestoreInitial(Emitter<BadgeState> emit) async {
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    _observedUnreadNews = 0;
    _observedUnreadClaims = 0;
    _observedUnreadSentClaim = false;
    _activeUid = null;
    _hasInitialized = false;
    emit(BadgeState.initial());
  }

  @override
  Future<void> close() async {
    await _notificationSubscription?.cancel();
    await super.close();
  }
}

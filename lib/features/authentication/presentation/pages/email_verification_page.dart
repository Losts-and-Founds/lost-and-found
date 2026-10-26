import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/features/authentication/domain/usecases/login_usecase.dart';
import 'package:lost_and_found/injection_container.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  Timer? _verificationTimer;
  bool _isChecking = false;
  bool _isSending = false;
  String? _message;
  String? _error;

  String get _email =>
      FirebaseAuth.instance.currentUser?.email ?? 'your email address';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkVerification(),
    );
    _checkVerification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVerification();
    }
  }

  Future<void> _checkVerification() async {
    if (_isChecking || !mounted) return;
    _isChecking = true;
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _verificationTimer?.cancel();
        setState(() {
          _error =
              'Your sign-up session has ended. Please sign in to continue.';
        });
        return;
      }

      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified != true) return;

      _verificationTimer?.cancel();
      final result = await sl<LoginUseCase>().completeCurrentUserLogin();
      if (!mounted) return;
      result.fold(
        (_) => setState(() {
          _error =
              'Your email is verified, but we could not finish signing you in. Check your connection and try again.';
        }),
        (_) => Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (route) => false),
      );
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message ?? 'Could not check your verification status.';
        });
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() {
          _error = 'Could not check your verification status: $error';
        });
      }
    } finally {
      _isChecking = false;
    }
  }

  Future<void> _resendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = 'Your sign-up session has ended. Please sign in to continue.';
      });
      return;
    }

    setState(() {
      _isSending = true;
      _message = null;
      _error = null;
    });
    try {
      await user.sendEmailVerification();
      if (mounted) {
        setState(() {
          _message = 'A new verification email has been sent.';
        });
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message ?? 'Could not resend the verification email.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _useAnotherAccount() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/tutorial',
      (route) => false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _verificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mark_email_unread_outlined, size: 64),
                const SizedBox(height: 20),
                Text(
                  'Waiting for verification',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We sent a verification link to $_email. Open that email and verify your account. This screen will sign you in automatically once verification is complete.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_isChecking)
                  const CircularProgressIndicator()
                else
                  FilledButton(
                    onPressed: _checkVerification,
                    child: const Text("I've verified my email"),
                  ),
                TextButton(
                  onPressed: _isSending ? null : _resendVerificationEmail,
                  child: Text(
                    _isSending ? 'Sending…' : 'Resend verification email',
                  ),
                ),
                if (_message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  TextButton(
                    onPressed: _checkVerification,
                    child: const Text('Try again'),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _useAnotherAccount,
                  child: const Text('Use another account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

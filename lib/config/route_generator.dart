import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/features/authentication/domain/usecases/login_usecase.dart';
import 'package:lost_and_found/features/authentication/presentation/pages/email_verification_page.dart';
import 'package:lost_and_found/injection_container.dart';
import 'package:lost_and_found/core/presentation/splash/pages/splash_screen.dart';
import 'package:lost_and_found/core/presentation/tutorial/pages/tutorial_page.dart';
import 'package:lost_and_found/features/authentication/presentation/pages/login_page.dart';
import 'package:lost_and_found/features/authentication/presentation/pages/registration_page.dart';
import 'package:lost_and_found/features/item/presentation/pages/notifications_page.dart';
import 'package:lost_and_found/features/claim/presentation/pages/claims_screen.dart';
import 'package:lost_and_found/features/item/presentation/pages/insert_item_page.dart';
import 'package:lost_and_found/features/user/presentation/pages/tutorial_page.dart';
import 'package:lost_and_found/features/user/presentation/pages/user_items_page.dart';

import '../core/presentation/home_controller/pages/home_controller_page.dart';
import '../features/user/presentation/pages/change_password_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/tutorial':
        return MaterialPageRoute(builder: (_) => const InfoScreen());
      case '/':
        return MaterialPageRoute(builder: (_) => const _VerifiedHomeGate());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/verify-email':
        return MaterialPageRoute(
            builder: (_) => const EmailVerificationScreen());
      case '/my-posts':
        return MaterialPageRoute(builder: (_) => const MyPostsScreen());
      case '/saved-items':
        return MaterialPageRoute(builder: (_) => const SavedItemsScreen());
      case '/drafts':
        return MaterialPageRoute(builder: (_) => const DraftsScreen());
      case '/insert':
        return MaterialPageRoute(builder: (_) {
          bool isNewItemLost = true;
          String? draftId;
          Map<String, dynamic>? draftData;

          if (settings.arguments != null &&
              settings.arguments is InsertItemScreenArguments) {
            final arguments = settings.arguments as InsertItemScreenArguments;
            isNewItemLost = arguments.isNewItemLost;
            draftId = arguments.draftId;
            draftData = arguments.draftData;
          }

          return InsertItemScreen(
            isNewItemLost: isNewItemLost,
            draftId: draftId,
            draftData: draftData,
          );
        });
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) {
            int? newNewsId;

            if (settings.arguments != null) {
              newNewsId = (settings.arguments as NotificationsScreenArguments)
                  .newNewsId;
            }

            return NotificationsScreen(newNewsId: newNewsId);
          },
        );
      case '/claims':
        return MaterialPageRoute(
          builder: (_) {
            int? tab;
            int? newClaimId;

            if (settings.arguments != null) {
              tab = (settings.arguments as ClaimsScreenArguments).tab;
              newClaimId =
                  (settings.arguments as ClaimsScreenArguments).claimId;
            }

            return ClaimsScreen(newClaimId: newClaimId, tab: tab);
          },
        );
      case '/options/changePassword':
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case '/options/tutorial':
        return MaterialPageRoute(builder: (_) {
          int? tab;

          if (settings.arguments != null) {
            tab = (settings.arguments as TutorialScreenArguments).tab;
          }

          return TutorialScreen(tab: tab);
        });
      default:
        // If there is no such named route in the switch statement
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class _VerifiedHomeGate extends StatefulWidget {
  const _VerifiedHomeGate();

  @override
  State<_VerifiedHomeGate> createState() => _VerifiedHomeGateState();
}

class _VerifiedHomeGateState extends State<_VerifiedHomeGate> {
  bool _isAuthorizing = true;
  bool _isAuthorized = false;
  bool _isRedirecting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _authorize();
  }

  Future<void> _authorize() async {
    if (!mounted || _isRedirecting) return;
    setState(() {
      _isAuthorizing = true;
      _error = null;
    });

    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _redirectTo('/tutorial');
        return;
      }

      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _redirectTo('/tutorial');
        return;
      }
      if (!user.emailVerified) {
        _redirectTo('/verify-email');
        return;
      }

      final result = await sl<LoginUseCase>().completeCurrentUserLogin();
      if (!mounted) return;
      result.fold(
        (_) => setState(() {
          _isAuthorizing = false;
          _error = 'Could not verify your sign-in. Check your connection.';
        }),
        (_) => setState(() {
          _isAuthorizing = false;
          _isAuthorized = true;
        }),
      );
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(() {
          _isAuthorizing = false;
          _error = error.message ?? 'Could not verify your sign-in.';
        });
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() {
          _isAuthorizing = false;
          _error = 'Could not verify your sign-in: $error';
        });
      }
    }
  }

  void _redirectTo(String route) {
    if (_isRedirecting) return;
    _isRedirecting = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        route,
        (entry) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthorized) return HomeControllerScreen();
    return Scaffold(
      body: Center(
        child: _isAuthorizing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error ?? 'Sign-in could not be verified.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _authorize,
                    child: const Text('Try again'),
                  ),
                ],
              ),
      ),
    );
  }
}

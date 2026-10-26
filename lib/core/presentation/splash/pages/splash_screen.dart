import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';
import 'package:lost_and_found/core/presentation/widgets/brand_logo.dart';
import 'package:lost_and_found/features/authentication/domain/usecases/login_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/login_chat_usecase.dart';
import 'package:lost_and_found/injection_container.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;

  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  Timer? _navigationTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    // Animate up to 30% filled progress as specified
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.30).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    _progressController.forward();

    _navigationTimer = Timer(widget.duration, _checkAuthAndNavigate);
  }

  Future<void> _checkAuthAndNavigate() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    try {
      final response = await sl<LoginUseCase>()(null);
      if (!mounted) return;
      if (response.isRight()) {
        await sl<LoginChatUseCase>()(NoParams());
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        Navigator.of(context).pushReplacementNamed('/tutorial');
      }
    } catch (_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/tutorial');
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _checkAuthAndNavigate,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),

              // Centered Layout: Circular pin icon inside mint ring, serif logo, subtitle
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BrandPinIcon(size: 80, ringPadding: 6),
                      const SizedBox(height: 24),
                      Text(
                        "Lost&Found",
                        style: AppTypography.serifTitle(
                          context,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          "Every lost thing has a way back home.",
                          textAlign: TextAlign.center,
                          style: AppTypography.sansSecondary(
                            context,
                            fontSize: 15,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Bar: Thin horizontal progress bar (30% filled) above uppercase tracking text
              Padding(
                padding: const EdgeInsets.only(bottom: 36, left: 48, right: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thin horizontal progress bar (30% filled)
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Container(
                          height: 3.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: secondaryTextColor.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mintColor,
                                  borderRadius: BorderRadius.circular(2.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: mintColor.withOpacity(0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    // Uppercase tracking text "COMMUNITY EDITION"
                    Text(
                      "COMMUNITY EDITION",
                      style: AppTypography.uppercaseLabel(
                        context,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                        color: secondaryTextColor.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lost_and_found/core/presentation/tutorial/widgets/onboarding_illustrations.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<OnboardingStepData> _steps = const [
    OnboardingStepData(
      counter: "01 / 03",
      title: "Report in seconds",
      description: "Quickly report lost valuables or items you've found with automated geo-tagging and quick photo uploads.",
    ),
    OnboardingStepData(
      counter: "02 / 03",
      title: "Search with precision",
      description: "Explore nearby reports with filters, interactive radius maps, and real-time neighbourhood alerts.",
    ),
    OnboardingStepData(
      counter: "03 / 03",
      title: "Talk, then reunite",
      description: "Connect safely through end-to-end encrypted chat to verify ownership and arrange a trusted reunion.",
    ),
  ];

  void _onSkip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _onNext() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final textPrimary = customColors.textPrimary ?? const Color(0xFF1E232A);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header: Counter on top-left, "Skip" action on top-right
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: customColors.containerSoft ?? const Color(0xFFF3EFEA),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      _steps[_currentPage].counter,
                      style: AppTypography.uppercaseLabel(
                        context,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: secondaryTextColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      "Skip",
                      style: AppTypography.sansBold(
                        context,
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Center Section: PageView with vector illustrations, serif titles, and descriptions
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage(
                    illustration: const ReportIllustration(size: 230),
                    step: _steps[0],
                  ),
                  _buildPage(
                    illustration: const SearchIllustration(size: 230),
                    step: _steps[1],
                  ),
                  _buildPage(
                    illustration: const TalkIllustration(size: 230),
                    step: _steps[2],
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar: Pagination dots and Solid Mint Green button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pagination dots (active step highlighted in Mint Green)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_numPages, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 6.0,
                        width: isActive ? 28.0 : 8.0,
                        decoration: BoxDecoration(
                          color: isActive ? mintColor : secondaryTextColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Solid Mint Green Button ("Next ->" / "Get started ->")
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mintColor,
                        foregroundColor: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF0B101D)
                            : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _numPages - 1 ? "Get started" : "Next",
                            style: AppTypography.sansBold(
                              context,
                              fontSize: 16,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF0B101D)
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF0B101D)
                                : Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Link to directly go to registration or login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member? ",
                        style: AppTypography.sansSecondary(context, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/login'),
                        child: Text(
                          "Sign in",
                          style: AppTypography.sansBold(
                            context,
                            fontSize: 13,
                            color: mintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required Widget illustration,
    required OnboardingStepData step,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          illustration,
          const SizedBox(height: 36),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: AppTypography.serifTitle(
              context,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              step.description,
              textAlign: TextAlign.center,
              style: AppTypography.sansSecondary(
                context,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingStepData {
  final String counter;
  final String title;
  final String description;

  const OnboardingStepData({
    required this.counter,
    required this.title,
    required this.description,
  });
}

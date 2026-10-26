import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found/core/presentation/widgets/brand_logo.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/features/authentication/presentation/bloc/registration/registration_bloc.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';
import 'package:lost_and_found/utils/utility.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String _currentPassword = "";

  int _calculateStrength(String password) {
    if (password.isEmpty) return 0;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[@$!%*?&#]')) || password.length >= 12)
      strength++;
    return strength;
  }

  void _showTermsDialog(BuildContext context) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            customColors.cardFill ?? Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card)),
        title: Text(
          "Terms and Privacy Policy",
          style: AppTypography.serifHeading(context, fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome to Lost&Found Community Edition.\n\n"
                "1. Mutual Trust & Integrity: Lost&Found is dedicated to safely reuniting individuals with misplaced property. Fraudulent claims or harassment are strictly prohibited.\n\n"
                "2. Privacy: We only share your public contact username and optional city radius to verify items. Your sensitive data is encrypted.\n\n"
                "3. Safety First: When reuniting with neighbours, always arrange meetings in well-lit public places and verify item details before completing handovers.",
                style:
                    AppTypography.sansBody(context, fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Understood",
              style: AppTypography.sansBold(context, color: mintColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor =
        customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final containerFill = customColors.cardFill ?? const Color(0xFF131A2B);
    final borderColor = customColors.cardBorderColor ?? const Color(0xFF1F2B45);
    final urgentColor = customColors.urgentAccent ?? const Color(0xFFA61C32);

    final strengthScore = _calculateStrength(_currentPassword);

    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (ctx, state) {
        final regFailureOrSuccess = state.registrationFailureOrSuccess;
        if (regFailureOrSuccess != null) {
          regFailureOrSuccess.fold(
            (failure) => showBasicErrorSnackbar(context, failure),
            (_) {
              Navigator.of(ctx).pushNamedAndRemoveUntil(
                '/verify-email',
                (route) => false,
              );
            },
          );
        }
      },
      builder: (ctx, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo pin + "Lost&Found"
              const Center(
                child: BrandLogo(
                  vertical: false,
                  iconSize: 42,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 24),

              // Serif title "Create account"
              Text(
                "Create account",
                textAlign: TextAlign.center,
                style: AppTypography.serifTitle(
                  context,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Join 12,400 neighbours helping things find their way home.",
                  textAlign: TextAlign.center,
                  style: AppTypography.sansSecondary(
                    context,
                    fontSize: 14,
                    color: secondaryTextColor,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Form Input 1: USERNAME
              _buildInputContainer(
                context: context,
                label: "USERNAME",
                icon: Icons.person_outline_rounded,
                fillColor: containerFill,
                borderColor: borderColor,
                child: TextFormField(
                  initialValue: state.username.value.getOrElse(() => ""),
                  style: AppTypography.sansBody(context),
                  decoration: const InputDecoration(
                    hintText: "e.g. alex_neighbour",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) => ctx
                      .read<RegistrationBloc>()
                      .add(RegistrationEvent.usernameFieldChanged(val)),
                ),
                errorText:
                    state.showErrorMessage && state.username.value.isLeft()
                        ? "Please enter a valid username"
                        : null,
              ),
              const SizedBox(height: 18),

              // Form Input 2: EMAIL
              _buildInputContainer(
                context: context,
                label: "EMAIL",
                icon: Icons.mail_outline_rounded,
                fillColor: containerFill,
                borderColor: borderColor,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: AppTypography.sansBody(context),
                  decoration: const InputDecoration(
                    hintText: "you@example.com",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) => ctx
                      .read<RegistrationBloc>()
                      .add(RegistrationEvent.emailFieldChanged(val)),
                ),
                errorText: state.showErrorMessage && state.email.value.isLeft()
                    ? "Please enter a valid email address"
                    : null,
              ),
              const SizedBox(height: 18),

              // Form Input 3: PASSWORD
              _buildInputContainer(
                context: context,
                label: "PASSWORD",
                icon: Icons.lock_outline_rounded,
                fillColor: containerFill,
                borderColor: borderColor,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: secondaryTextColor,
                  ),
                  onPressed: () => ctx
                      .read<RegistrationBloc>()
                      .add(const RegistrationEvent.obscurePasswordToggled()),
                ),
                child: TextFormField(
                  obscureText: state.obscurePassword,
                  style: AppTypography.sansBody(context),
                  decoration: const InputDecoration(
                    hintText: "Create a secure password",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _currentPassword = val;
                    });
                    ctx
                        .read<RegistrationBloc>()
                        .add(RegistrationEvent.passwordFieldChanged(val));
                  },
                ),
                errorText:
                    state.showErrorMessage && state.password.value.isLeft()
                        ? "Password must be at least 8 chars with 1 number"
                        : null,
              ),

              // Password Strength Bar: Multi-segment bar below password field
              const SizedBox(height: 10),
              _buildPasswordStrengthBar(context, strengthScore),
              const SizedBox(height: 18),

              // Form Input 4: CONFIRM PASSWORD
              _buildInputContainer(
                context: context,
                label: "CONFIRM PASSWORD",
                icon: Icons.lock_clock_outlined,
                fillColor: containerFill,
                borderColor: borderColor,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: secondaryTextColor,
                  ),
                  onPressed: () => ctx.read<RegistrationBloc>().add(
                      const RegistrationEvent.obscureConfirmPasswordToggled()),
                ),
                child: TextFormField(
                  obscureText: state.obscureConfirmPassword,
                  style: AppTypography.sansBody(context),
                  decoration: const InputDecoration(
                    hintText: "Repeat your password",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) => ctx
                      .read<RegistrationBloc>()
                      .add(RegistrationEvent.confirmPasswordFieldChanged(val)),
                ),
                errorText: state.showErrorMessage &&
                        state.confirmPassword.value.isLeft()
                    ? "Passwords must match"
                    : null,
              ),
              const SizedBox(height: 20),

              // Legal Text: Clickable terms link
              GestureDetector(
                onTap: () => _showTermsDialog(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTypography.sansSecondary(context,
                          fontSize: 13, height: 1.4),
                      children: [
                        const TextSpan(text: "By continuing you agree to our "),
                        TextSpan(
                          text: "Terms and Privacy Policy.",
                          style: TextStyle(
                            color: mintColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Primary full-width Mint Green button ("Create account")
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: state.isSubmitting
                      ? null
                      : () => ctx
                          .read<RegistrationBloc>()
                          .add(const RegistrationEvent.registrationSubmitted()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mintColor,
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF0B101D)
                            : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: state.isSubmitting
                      ? const CustomCircularProgress(
                          size: 22, color: Colors.white)
                      : Text(
                          "Create account",
                          style: AppTypography.sansBold(
                            context,
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF0B101D)
                                    : Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),

              // Subtext link: "Already a member? Sign in"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member? ",
                    style: AppTypography.sansSecondary(context, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: Text(
                      "Sign in",
                      style: AppTypography.sansBold(
                        context,
                        fontSize: 14,
                        color: mintColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputContainer({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Widget child,
    required Color fillColor,
    required Color borderColor,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Uppercase Label
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            label,
            style: AppTypography.uppercaseLabel(context, fontSize: 11),
          ),
        ),
        // Container with 12px rounded corners, left-aligned icon
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? const Color(0xFFA61C32) : borderColor,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context)
                        .extension<CustomColors>()
                        ?.secondaryTextColor ??
                    const Color(0xFF8F99A8),
              ),
              const SizedBox(width: 12),
              Expanded(child: child),
              if (suffixIcon != null) suffixIcon,
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Color(0xFFA61C32), fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordStrengthBar(BuildContext context, int strength) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor =
        customColors.secondaryTextColor ?? const Color(0xFF8F99A8);

    Color getBarColor(int index) {
      if (index >= strength) return secondaryTextColor.withOpacity(0.2);
      if (strength <= 1) return const Color(0xFFA61C32); // Weak Red
      if (strength == 2) return const Color(0xFFE67E22); // Fair Orange
      if (strength == 3) return const Color(0xFFF1C40F); // Good Yellow
      return mintColor; // Strong Mint Green
    }

    String getStrengthLabel() {
      if (strength == 0) return "Password strength";
      if (strength == 1) return "Weak";
      if (strength == 2) return "Fair";
      if (strength == 3) return "Good";
      return "Strong";
    }

    return Column(
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                decoration: BoxDecoration(
                  color: getBarColor(index),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Must be 8+ chars with numbers",
              style: AppTypography.sansSecondary(context, fontSize: 11),
            ),
            Text(
              getStrengthLabel(),
              style: AppTypography.sansBold(
                context,
                fontSize: 11,
                color: strength == 0
                    ? secondaryTextColor
                    : (strength <= 1
                        ? const Color(0xFFA61C32)
                        : (strength <= 3
                            ? const Color(0xFFE67E22)
                            : mintColor)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

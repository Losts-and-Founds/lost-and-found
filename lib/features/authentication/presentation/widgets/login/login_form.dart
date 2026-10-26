import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found/core/presentation/home_controller/bloc/home_controller_bloc.dart';
import 'package:lost_and_found/core/presentation/widgets/brand_logo.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/features/authentication/presentation/bloc/login/login_bloc.dart';
import 'package:lost_and_found/features/badges/presentation/bloc/badge_bloc.dart';
import 'package:lost_and_found/features/item/presentation/bloc/home/home_bloc.dart';
import 'package:lost_and_found/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';
import 'package:lost_and_found/utils/utility.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _rememberMe = true;

  void _showForgotPasswordDialog(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: customColors.cardFill ?? Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
        title: Text(
          "Reset Password",
          style: AppTypography.serifHeading(context, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your registered email address to receive password reset instructions.",
              style: AppTypography.sansBody(context, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "you@example.com",
                prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel", style: AppTypography.sansBody(context)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              showBasicSuccessSnackbar(context, "Password reset instructions sent if email exists.");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mintColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              "Send Link",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF0B101D)
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final containerFill = customColors.cardFill ?? const Color(0xFF131A2B);
    final borderColor = customColors.cardBorderColor ?? const Color(0xFF1F2B45);
    final textPrimary = customColors.textPrimary ?? const Color(0xFF1E232A);

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        final authFailureOrSuccess = state.authFailureOrSuccess;
        if (authFailureOrSuccess != null) {
          authFailureOrSuccess.fold(
            (failure) => showBasicErrorSnackbar(context, failure),
            (_) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.of(context).pushReplacementNamed('/');

              // Update home/user content
              context.read<HomeControllerBloc>().add(const HomeControllerEvent.tabChanged(0));
              context.read<HomeBloc>().add(const HomeEvent.homeCreated());
              context.read<UserBloc>().add(const UserEvent.contentCreated());
              context.read<BadgeBloc>().add(const BadgeEvent.badgeCreated());
            },
          );
        }
      },
      builder: (context, state) {
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
              const SizedBox(height: 28),

              // Serif title "Welcome back"
              Text(
                "Welcome back",
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
                  "Sign in to follow your reports and messages.",
                  textAlign: TextAlign.center,
                  style: AppTypography.sansSecondary(
                    context,
                    fontSize: 14,
                    color: secondaryTextColor,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Input 1: EMAIL OR USERNAME
              _buildInputContainer(
                context: context,
                label: "EMAIL OR USERNAME",
                icon: Icons.person_outline_rounded,
                fillColor: containerFill,
                borderColor: borderColor,
                child: TextFormField(
                  initialValue: state.user.value.getOrElse(() => ""),
                  style: AppTypography.sansBody(context),
                  decoration: const InputDecoration(
                    hintText: "Enter your username or email",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) => context.read<LoginBloc>().add(LoginEvent.userFieldChanged(val)),
                ),
                errorText: state.showErrorMessage && state.user.value.isLeft()
                    ? "Please enter a valid username or email"
                    : null,
              ),
              const SizedBox(height: 20),

              // Input 2: PASSWORD
              _buildInputContainer(
                context: context,
                label: "PASSWORD",
                icon: Icons.lock_outline_rounded,
                fillColor: containerFill,
                borderColor: borderColor,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20,
                    color: secondaryTextColor,
                  ),
                  onPressed: () => context.read<LoginBloc>().add(const LoginEvent.obscurePasswordToggled()),
                ),
                child: TextFormField(
                  obscureText: state.obscurePassword,
                  style: AppTypography.sansBody(context),
                  decoration: const InputDecoration(
                    hintText: "Enter your password",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) => context.read<LoginBloc>().add(LoginEvent.passwordFieldChanged(val)),
                ),
                errorText: state.showErrorMessage && state.password.value.isLeft()
                    ? "Please enter your password"
                    : null,
              ),
              const SizedBox(height: 14),

              // Options Row: Functional "Remember me" checkbox on the left; Mint Green "Forgot password?" link on the right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: mintColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) {
                            setState(() {
                              _rememberMe = val ?? true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _rememberMe = !_rememberMe;
                          });
                        },
                        child: Text(
                          "Remember me",
                          style: AppTypography.sansBody(context, fontSize: 13, color: textPrimary),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showForgotPasswordDialog(context),
                    child: Text(
                      "Forgot password?",
                      style: AppTypography.sansBold(
                        context,
                        fontSize: 13,
                        color: mintColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Primary solid Mint Green button ("Sign in")
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: state.isSubmitting
                      ? null
                      : () => context.read<LoginBloc>().add(const LoginEvent.loginSubmitted()),
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
                  child: state.isSubmitting
                      ? const CustomCircularProgress(size: 22, color: Colors.white)
                      : Text(
                          "Sign in",
                          style: AppTypography.sansBold(
                            context,
                            fontSize: 16,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF0B101D)
                                : Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),

              // Secondary outline button ("Create an account")
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/register'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1F2B45)
                          : const Color(0xFFEDE8E1),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: Text(
                    "Create an account",
                    style: AppTypography.sansBold(
                      context,
                      fontSize: 16,
                      color: textPrimary,
                    ),
                  ),
                ),
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
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            label,
            style: AppTypography.uppercaseLabel(context, fontSize: 11),
          ),
        ),
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
                color: Theme.of(context).extension<CustomColors>()?.secondaryTextColor ?? const Color(0xFF8F99A8),
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
}

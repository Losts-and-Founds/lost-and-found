import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found/features/authentication/presentation/bloc/login/login_bloc.dart';
import 'package:lost_and_found/features/authentication/presentation/widgets/login/login_form.dart';
import 'package:lost_and_found/injection_container.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final textPrimary = customColors.textPrimary ?? const Color(0xFF1E232A);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  // Back arrow circular button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: customColors.containerSoft ?? const Color(0xFFF3EFEA),
                      border: Border.all(
                        color: customColors.cardBorderColor ?? const Color(0xFFEDE8E1),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_rounded, size: 20, color: textPrimary),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacementNamed('/tutorial');
                        }
                      },
                      splashRadius: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocProvider(
            create: (_) => sl<LoginBloc>(),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}

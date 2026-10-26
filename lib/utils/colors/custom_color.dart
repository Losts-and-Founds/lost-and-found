import 'package:flutter/material.dart';

CustomColors lightCustomColors = const CustomColors(
  borderColorNotOpened: Color(0xFF52C46A),
  borderColorOpened: Color(0xFFE8E2D9),
  claimAcceptedStatusColor: Color(0xFF52C46A),
  claimWaitingStatusColor: Color(0xFFD97706),
  claimDeniedStatusColor: Color(0xFFA61C32),
  nClaimsColor: Color(0xFFD97706),
  notOpenedColor: Color(0x1F52C46A),
  openedColor: Color(0xFFF3EFEA),
  splashGreenColor: Color(0xFF52C46A),
  splashGreyColor: Color(0xFF9C8B7A),
  secondaryTextColor: Color(0xFF9C8B7A),
  background2: Color(0xFFFFFFFF),
  successSnackbar: Color(0xFF52C46A),
  urgentAccent: Color(0xFF1E232A),
  primaryAccent: Color(0xFF52C46A),
  textPrimary: Color(0xFF1E232A),
  mainBackground: Color(0xFFFBF9F6),
  cardFill: Color(0xFFFFFFFF),
  containerSoft: Color(0xFFF3EFEA),
  cardBorderColor: Color(0xFFEDE8E1),
  pillActiveBackground: Color(0xFF1E232A),
  pillActiveText: Color(0xFFFFFFFF),
);

CustomColors darkCustomColors = const CustomColors(
  borderColorNotOpened: Color(0xFF63D279),
  borderColorOpened: Color(0xFF1E283F),
  claimAcceptedStatusColor: Color(0xFF63D279),
  claimWaitingStatusColor: Color(0xFFF59E0B),
  claimDeniedStatusColor: Color(0xFFA61C32),
  nClaimsColor: Color(0xFFF59E0B),
  notOpenedColor: Color(0x3363D279),
  openedColor: Color(0xFF131A2B),
  splashGreenColor: Color(0xFF63D279),
  splashGreyColor: Color(0xFF8F99A8),
  secondaryTextColor: Color(0xFF8F99A8),
  background2: Color(0xFF131A2B),
  successSnackbar: Color(0xFF63D279),
  urgentAccent: Color(0xFFA61C32),
  primaryAccent: Color(0xFF63D279),
  textPrimary: Color(0xFFFFFFFF),
  mainBackground: Color(0xFF0B101D),
  cardFill: Color(0xFF131A2B),
  containerSoft: Color(0xFF192238),
  cardBorderColor: Color(0xFF1F2B45),
  pillActiveBackground: Color(0xFFFFFFFF),
  pillActiveText: Color(0xFF0B101D),
);

/// Custom color extension for Lost&Found theme tokens
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? nClaimsColor;
  final Color? claimWaitingStatusColor;
  final Color? claimAcceptedStatusColor;
  final Color? claimDeniedStatusColor;
  final Color? splashGreyColor;
  final Color? splashGreenColor;
  final Color? notOpenedColor;
  final Color? openedColor;
  final Color? borderColorOpened;
  final Color? secondaryTextColor;
  final Color? borderColorNotOpened;
  final Color? background2;
  final Color? successSnackbar;

  // Design system tokens
  final Color? urgentAccent;
  final Color? primaryAccent;
  final Color? textPrimary;
  final Color? mainBackground;
  final Color? cardFill;
  final Color? containerSoft;
  final Color? cardBorderColor;
  final Color? pillActiveBackground;
  final Color? pillActiveText;

  const CustomColors({
    required this.nClaimsColor,
    required this.claimWaitingStatusColor,
    required this.claimAcceptedStatusColor,
    required this.claimDeniedStatusColor,
    required this.splashGreyColor,
    required this.splashGreenColor,
    required this.notOpenedColor,
    required this.openedColor,
    required this.borderColorOpened,
    required this.secondaryTextColor,
    required this.borderColorNotOpened,
    required this.background2,
    required this.successSnackbar,
    this.urgentAccent,
    this.primaryAccent,
    this.textPrimary,
    this.mainBackground,
    this.cardFill,
    this.containerSoft,
    this.cardBorderColor,
    this.pillActiveBackground,
    this.pillActiveText,
  });

  @override
  CustomColors copyWith({
    Color? nClaimsColor,
    Color? claimWaitingStatusColor,
    Color? claimAcceptedStatusColor,
    Color? claimDeniedStatusColor,
    Color? splashGreyColor,
    Color? splashGreenColor,
    Color? notOpenedColor,
    Color? openedColor,
    Color? borderColorOpened,
    Color? secondaryTextColor,
    Color? borderColorNotOpened,
    Color? background2,
    Color? successSnackbar,
    Color? urgentAccent,
    Color? primaryAccent,
    Color? textPrimary,
    Color? mainBackground,
    Color? cardFill,
    Color? containerSoft,
    Color? cardBorderColor,
    Color? pillActiveBackground,
    Color? pillActiveText,
  }) {
    return CustomColors(
      nClaimsColor: nClaimsColor ?? this.nClaimsColor,
      claimWaitingStatusColor: claimWaitingStatusColor ?? this.claimWaitingStatusColor,
      claimAcceptedStatusColor: claimAcceptedStatusColor ?? this.claimAcceptedStatusColor,
      claimDeniedStatusColor: claimDeniedStatusColor ?? this.claimDeniedStatusColor,
      splashGreyColor: splashGreyColor ?? this.splashGreyColor,
      splashGreenColor: splashGreenColor ?? this.splashGreenColor,
      notOpenedColor: notOpenedColor ?? this.notOpenedColor,
      openedColor: openedColor ?? this.openedColor,
      borderColorOpened: borderColorOpened ?? this.borderColorOpened,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      borderColorNotOpened: borderColorNotOpened ?? this.borderColorNotOpened,
      background2: background2 ?? this.background2,
      successSnackbar: successSnackbar ?? this.successSnackbar,
      urgentAccent: urgentAccent ?? this.urgentAccent,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      mainBackground: mainBackground ?? this.mainBackground,
      cardFill: cardFill ?? this.cardFill,
      containerSoft: containerSoft ?? this.containerSoft,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      pillActiveBackground: pillActiveBackground ?? this.pillActiveBackground,
      pillActiveText: pillActiveText ?? this.pillActiveText,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      nClaimsColor: Color.lerp(nClaimsColor, other.nClaimsColor, t),
      claimWaitingStatusColor: Color.lerp(claimWaitingStatusColor, other.claimWaitingStatusColor, t),
      claimAcceptedStatusColor: Color.lerp(claimAcceptedStatusColor, other.claimAcceptedStatusColor, t),
      claimDeniedStatusColor: Color.lerp(claimDeniedStatusColor, other.claimDeniedStatusColor, t),
      splashGreyColor: Color.lerp(splashGreyColor, other.splashGreyColor, t),
      splashGreenColor: Color.lerp(splashGreenColor, other.splashGreenColor, t),
      notOpenedColor: Color.lerp(notOpenedColor, other.notOpenedColor, t),
      openedColor: Color.lerp(openedColor, other.openedColor, t),
      borderColorOpened: Color.lerp(borderColorOpened, other.borderColorOpened, t),
      secondaryTextColor: Color.lerp(secondaryTextColor, other.secondaryTextColor, t),
      borderColorNotOpened: Color.lerp(borderColorNotOpened, other.borderColorNotOpened, t),
      background2: Color.lerp(background2, other.background2, t),
      successSnackbar: Color.lerp(successSnackbar, other.successSnackbar, t),
      urgentAccent: Color.lerp(urgentAccent, other.urgentAccent, t),
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      mainBackground: Color.lerp(mainBackground, other.mainBackground, t),
      cardFill: Color.lerp(cardFill, other.cardFill, t),
      containerSoft: Color.lerp(containerSoft, other.containerSoft, t),
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t),
      pillActiveBackground: Color.lerp(pillActiveBackground, other.pillActiveBackground, t),
      pillActiveText: Color.lerp(pillActiveText, other.pillActiveText, t),
    );
  }
}

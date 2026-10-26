import 'package:flutter/material.dart';

// ====================================================================
// GLOBAL DESIGN SYSTEM & THEME TOKENS
// ====================================================================

// --- LIGHT MODE PALETTE ---
// • Main Background: #FBF9F6 (Warm Ivory / Sand)
// • Surface Cards / Container Fill: #FFFFFF (Clean White) or #F3EFEA (Soft Warm Grey Containers)
// • Primary Accent / Brand Color: #52C46A (Vibrant Mint Green - CTA buttons, active state highlights, center + action)
// • Secondary / Urgent Accent: #1E232A (Charcoal Dark - 'LOST' tags, active filter pills, search buttons)
// • Text Primary: #1E232A (Deep Slate / Charcoal)
// • Text Secondary: #9C8B7A (Warm Taupe / Muted Sand for subtitles, captions, borders)
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF52C46A), // Vibrant Mint Green
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD4F5DA),
  onPrimaryContainer: Color(0xFF0F3E18),
  secondary: Color(0xFF1E232A), // Charcoal Dark
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFF3EFEA), // Soft warm grey container
  onSecondaryContainer: Color(0xFF1E232A),
  tertiary: Color(0xFF52C46A),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE8F8EC),
  onTertiaryContainer: Color(0xFF13421C),
  error: Color(0xFFA61C32), // Crimson Red
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFFFFFF), // Clean White surface cards
  onSurface: Color(0xFF1E232A), // Deep Slate / Charcoal
  surfaceContainerHighest: Color(0xFFF3EFEA), // Soft Warm Grey Containers
  outline: Color(0xFF9C8B7A), // Warm Taupe
  outlineVariant: Color(0xFFE8E2D9),
  shadow: Color(0x1F1E232A),
  surfaceTint: Color(0xFF52C46A),
  scrim: Color(0xFF1E232A),
);

// --- DARK MODE PALETTE ---
// • Main Background: #0B101D (Deep Midnight/Navy)
// • Surface Cards / Container Fill: #131A2B (Elevated dark container color)
// • Primary Accent / Brand Color: #63D279 (Soft Mint Green - active states, CTA buttons, active tabs, center + action)
// • Secondary / Urgent Accent: #A61C32 (Crimson Red - 'LOST' tags, filter toggles, active badges)
// • Text Primary: #FFFFFF (Pure White)
// • Text Secondary: #8F99A8 (Muted Grey for subtitles, captions, input placeholders)
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF63D279), // Soft Mint Green
  onPrimary: Color(0xFF0B101D),
  primaryContainer: Color(0xFF183823),
  onPrimaryContainer: Color(0xFFB8F5C5),
  secondary: Color(0xFFA61C32), // Crimson Red
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF1E283E),
  onSecondaryContainer: Color(0xFFFFFFFF),
  tertiary: Color(0xFF63D279),
  onTertiary: Color(0xFF0B101D),
  tertiaryContainer: Color(0xFF1B3B26),
  onTertiaryContainer: Color(0xFFB8F5C5),
  error: Color(0xFFA61C32),
  errorContainer: Color(0xFF5A101C),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF131A2B), // Elevated dark container color
  onSurface: Color(0xFFFFFFFF), // Pure White
  surfaceContainerHighest: Color(0xFF1D263B),
  outline: Color(0xFF8F99A8), // Muted Grey
  outlineVariant: Color(0xFF26334D),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF63D279),
  scrim: Color(0xFF000000),
);

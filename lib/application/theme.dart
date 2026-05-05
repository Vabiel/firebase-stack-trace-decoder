import 'package:flutter/material.dart';

/// Design tokens carried via [ThemeExtension] so any widget can read them as
/// `Theme.of(context).extension<AppTokens>()` — or via the [AppTokensX]
/// extension below.
///
/// Mirrors the spec from the Claude Design handoff (light + dark, single
/// accent "ink", single 6px radius, desktop-dense typography & sizing).
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  // ── Surfaces ────────────────────────────────────────────────────────────
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color surface3;

  // ── Text ────────────────────────────────────────────────────────────────
  final Color text;
  final Color textMuted;
  final Color textDim;
  final Color textOnAccent;

  // ── Lines ───────────────────────────────────────────────────────────────
  final Color border;
  final Color borderStrong;
  final Color divider;

  // ── Accent (ink) ────────────────────────────────────────────────────────
  final Color accent;
  final Color accentHover;
  final Color accentSoft;

  // ── Semantic ────────────────────────────────────────────────────────────
  final Color danger;
  final Color dangerSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color focus;

  // ── Code block ──────────────────────────────────────────────────────────
  final Color codeBg;
  final Color codeText;
  final Color codeLine;

  // ── Elevation ───────────────────────────────────────────────────────────
  final List<BoxShadow> shadow1;
  final List<BoxShadow> shadow2;
  final List<BoxShadow> shadow3;
  final Color overlay;

  // ── Typography ──────────────────────────────────────────────────────────
  final String fontUi;
  final String fontMono;

  const AppTokens({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.text,
    required this.textMuted,
    required this.textDim,
    required this.textOnAccent,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.accent,
    required this.accentHover,
    required this.accentSoft,
    required this.danger,
    required this.dangerSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.focus,
    required this.codeBg,
    required this.codeText,
    required this.codeLine,
    required this.shadow1,
    required this.shadow2,
    required this.shadow3,
    required this.overlay,
    required this.fontUi,
    required this.fontMono,
  });

  // ── Spacing scale (px) ──────────────────────────────────────────────────
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s10 = 40;
  static const double s12 = 48;

  // ── Radii ───────────────────────────────────────────────────────────────
  static const double radius = 6;
  static const double radiusSm = 4;
  static const double radiusPill = 999;

  // ── Type sizes ──────────────────────────────────────────────────────────
  static const double t11 = 11;
  static const double t12 = 12;
  static const double t13 = 13;
  static const double t14 = 14;
  static const double t15 = 15;
  static const double t17 = 17;
  static const double t20 = 20;
  static const double t24 = 24;
  static const double t32 = 32;

  static const double lhTight = 1.2;
  static const double lhBody = 1.45;
  static const double lhCode = 1.55;

  // ── Density ─────────────────────────────────────────────────────────────
  static const double rowH = 32;
  static const double controlH = 30;
  static const double controlHSm = 26;
  static const double controlHLg = 36;

  // ── Motion ──────────────────────────────────────────────────────────────
  static const Duration motionFast = Duration(milliseconds: 120);
  static const Duration motionMed = Duration(milliseconds: 180);
  static const Curve motionCurve = Cubic(.2, .7, .3, 1);

  // ── Light & dark instances ──────────────────────────────────────────────
  static final AppTokens light = AppTokens(
    bg: const Color(0xFFF7F7F5),
    surface: const Color(0xFFFFFFFF),
    surface2: const Color(0xFFFAFAF9),
    surface3: const Color(0xFFF1F1EE),
    text: const Color(0xFF16181D),
    textMuted: const Color(0xFF5B6068),
    textDim: const Color(0xFF8A8F97),
    textOnAccent: const Color(0xFFFFFFFF),
    border: const Color(0xFFE3E3DF),
    borderStrong: const Color(0xFFCDCEC8),
    divider: const Color(0xFFECECEA),
    accent: const Color(0xFF16181D),
    accentHover: const Color(0xFF000000),
    accentSoft: const Color(0xFFECECEA),
    danger: const Color(0xFFB42318),
    dangerSoft: const Color(0xFFFDE8E6),
    success: const Color(0xFF067647),
    successSoft: const Color(0xFFE6F4EC),
    warning: const Color(0xFFB54708),
    focus: const Color(0xFF16181D),
    codeBg: const Color(0xFFFAFAF9),
    codeText: const Color(0xFF16181D),
    codeLine: const Color(0xFFECECEA),
    shadow1: const [
      BoxShadow(color: Color(0x0F0F1115), offset: Offset(0, 1), blurRadius: 2),
    ],
    shadow2: const [
      BoxShadow(color: Color(0x140F1115), offset: Offset(0, 4), blurRadius: 14),
      BoxShadow(color: Color(0x0A0F1115), offset: Offset(0, 1), blurRadius: 2),
    ],
    shadow3: const [
      BoxShadow(color: Color(0x2E0F1115), offset: Offset(0, 16), blurRadius: 40),
      BoxShadow(color: Color(0x140F1115), offset: Offset(0, 2), blurRadius: 6),
    ],
    overlay: const Color(0x520F1115),
    fontUi: _fontUi,
    fontMono: _fontMono,
  );

  static final AppTokens dark = AppTokens(
    bg: const Color(0xFF0E1014),
    surface: const Color(0xFF15181D),
    surface2: const Color(0xFF191C22),
    surface3: const Color(0xFF21252C),
    text: const Color(0xFFEEF0F3),
    textMuted: const Color(0xFF9AA0AA),
    textDim: const Color(0xFF6A707A),
    textOnAccent: const Color(0xFF0E1014),
    border: const Color(0xFF262A31),
    borderStrong: const Color(0xFF373C45),
    divider: const Color(0xFF1D2026),
    accent: const Color(0xFFEEF0F3),
    accentHover: const Color(0xFFFFFFFF),
    accentSoft: const Color(0xFF21252C),
    danger: const Color(0xFFF97066),
    dangerSoft: const Color(0xFF3A1A17),
    success: const Color(0xFF47CD89),
    successSoft: const Color(0xFF15291F),
    warning: const Color(0xFFFDB022),
    focus: const Color(0xFFEEF0F3),
    codeBg: const Color(0xFF0B0D10),
    codeText: const Color(0xFFDDE1E7),
    codeLine: const Color(0xFF1D2026),
    shadow1: const [
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 2),
    ],
    shadow2: const [
      BoxShadow(color: Color(0x80000000), offset: Offset(0, 4), blurRadius: 14),
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 2),
    ],
    shadow3: const [
      BoxShadow(color: Color(0x99000000), offset: Offset(0, 16), blurRadius: 40),
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 2), blurRadius: 6),
    ],
    overlay: const Color(0x8C000000),
    fontUi: _fontUi,
    fontMono: _fontMono,
  );

  // System fonts — Flutter falls back through the family list automatically.
  // Inter / JetBrains Mono are listed in case they're bundled later; until
  // then the platform default kicks in.
  static const String _fontUi = '.SF Pro Text';
  static const String _fontMono = 'SF Mono';

  @override
  AppTokens copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? text,
    Color? textMuted,
    Color? textDim,
    Color? textOnAccent,
    Color? border,
    Color? borderStrong,
    Color? divider,
    Color? accent,
    Color? accentHover,
    Color? accentSoft,
    Color? danger,
    Color? dangerSoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? focus,
    Color? codeBg,
    Color? codeText,
    Color? codeLine,
    List<BoxShadow>? shadow1,
    List<BoxShadow>? shadow2,
    List<BoxShadow>? shadow3,
    Color? overlay,
    String? fontUi,
    String? fontMono,
  }) {
    return AppTokens(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textDim: textDim ?? this.textDim,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentSoft: accentSoft ?? this.accentSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      focus: focus ?? this.focus,
      codeBg: codeBg ?? this.codeBg,
      codeText: codeText ?? this.codeText,
      codeLine: codeLine ?? this.codeLine,
      shadow1: shadow1 ?? this.shadow1,
      shadow2: shadow2 ?? this.shadow2,
      shadow3: shadow3 ?? this.shadow3,
      overlay: overlay ?? this.overlay,
      fontUi: fontUi ?? this.fontUi,
      fontMono: fontMono ?? this.fontMono,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      codeBg: Color.lerp(codeBg, other.codeBg, t)!,
      codeText: Color.lerp(codeText, other.codeText, t)!,
      codeLine: Color.lerp(codeLine, other.codeLine, t)!,
      shadow1: t < 0.5 ? shadow1 : other.shadow1,
      shadow2: t < 0.5 ? shadow2 : other.shadow2,
      shadow3: t < 0.5 ? shadow3 : other.shadow3,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      fontUi: t < 0.5 ? fontUi : other.fontUi,
      fontMono: t < 0.5 ? fontMono : other.fontMono,
    );
  }
}

/// Convenience accessor: `context.tokens.surface`.
extension AppTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(AppTokens.light, Brightness.light);
  static ThemeData dark() => _build(AppTokens.dark, Brightness.dark);

  static ThemeData _build(AppTokens t, Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light(useMaterial3: false)
        : ThemeData.dark(useMaterial3: false);

    final textTheme = _textTheme(t, base.textTheme);

    return base.copyWith(
      brightness: brightness,
      scaffoldBackgroundColor: t.bg,
      canvasColor: t.bg,
      cardColor: t.surface,
      dividerColor: t.divider,
      hoverColor: t.surface2,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: t.focus.withValues(alpha: 0.12),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: t.accent,
        onPrimary: t.textOnAccent,
        secondary: t.accent,
        onSecondary: t.textOnAccent,
        error: t.danger,
        onError: Colors.white,
        surface: t.surface,
        onSurface: t.text,
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: t.textMuted, size: 16),
      dividerTheme: DividerThemeData(
        color: t.divider,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: t.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          side: BorderSide(color: t.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          side: BorderSide(color: t.border),
        ),
        titleTextStyle: textTheme.titleMedium,
        contentTextStyle: textTheme.bodyMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          borderSide: BorderSide(color: t.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          borderSide: BorderSide(color: t.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          borderSide: BorderSide(color: t.focus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          borderSide: BorderSide(color: t.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          borderSide: BorderSide(color: t.danger, width: 1.5),
        ),
        labelStyle: TextStyle(color: t.textMuted, fontSize: AppTokens.t13),
        hintStyle: TextStyle(color: t.textDim, fontSize: AppTokens.t13),
        errorStyle: TextStyle(color: t.danger, fontSize: AppTokens.t12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.accent,
          foregroundColor: t.textOnAccent,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: AppTokens.t13,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.05,
          ),
          minimumSize: const Size(0, AppTokens.controlH),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: t.surface,
          foregroundColor: t.text,
          side: BorderSide(color: t.border),
          textStyle: const TextStyle(
            fontSize: AppTokens.t13,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.05,
          ),
          minimumSize: const Size(0, AppTokens.controlH),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.text,
          textStyle: const TextStyle(
            fontSize: AppTokens.t13,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.05,
          ),
          minimumSize: const Size(0, AppTokens.controlH),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: t.textMuted,
          minimumSize: const Size(28, 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.text,
          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          boxShadow: t.shadow2,
        ),
        textStyle: TextStyle(color: t.bg, fontSize: AppTokens.t11),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        waitDuration: const Duration(milliseconds: 400),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: t.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius),
          side: BorderSide(color: t.border),
        ),
        textStyle: TextStyle(color: t.text, fontSize: AppTokens.t13),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
        ),
        side: BorderSide(color: t.borderStrong, width: 1.5),
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? t.accent : t.surface),
        checkColor: WidgetStateProperty.all(t.textOnAccent),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? t.accent : t.borderStrong),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.accent,
        circularTrackColor: t.divider,
      ),
      extensions: [t],
    );
  }

  static TextTheme _textTheme(AppTokens t, TextTheme base) {
    TextStyle ui(double size,
            {FontWeight w = FontWeight.w400,
            Color? color,
            double? height,
            double? letter}) =>
        TextStyle(
          fontFamily: t.fontUi,
          fontSize: size,
          fontWeight: w,
          color: color ?? t.text,
          height: height,
          letterSpacing: letter,
        );

    return base.copyWith(
      // Display / headlines — used sparingly.
      headlineLarge: ui(AppTokens.t32,
          w: FontWeight.w600, height: AppTokens.lhTight, letter: -0.4),
      headlineMedium: ui(AppTokens.t24,
          w: FontWeight.w600, height: AppTokens.lhTight, letter: -0.3),
      headlineSmall: ui(AppTokens.t20,
          w: FontWeight.w600, height: AppTokens.lhTight, letter: -0.2),
      // Titles in dialogs / sections.
      titleLarge: ui(AppTokens.t17,
          w: FontWeight.w600, height: AppTokens.lhTight, letter: -0.2),
      titleMedium: ui(AppTokens.t14,
          w: FontWeight.w600, height: AppTokens.lhTight, letter: -0.1),
      titleSmall: ui(AppTokens.t13,
          w: FontWeight.w600, height: AppTokens.lhTight),
      // Body.
      bodyLarge: ui(AppTokens.t14, height: AppTokens.lhBody),
      bodyMedium: ui(AppTokens.t13, height: AppTokens.lhBody),
      bodySmall: ui(AppTokens.t12, height: AppTokens.lhBody, color: t.textMuted),
      // Labels (uppercase section labels use this with custom letterSpacing
      // applied at the call site).
      labelLarge: ui(AppTokens.t13, w: FontWeight.w500),
      labelMedium: ui(AppTokens.t12, w: FontWeight.w500, color: t.textMuted),
      labelSmall: ui(AppTokens.t11,
          w: FontWeight.w600, color: t.textDim, letter: 0.6),
    );
  }

  // Legacy helpers kept for the few existing call sites that haven't been
  // migrated to tokens yet. Prefer `context.tokens.*` going forward.
  static Color get borderColor => AppTokens.light.border;
  static BoxDecoration get boxBorder => BoxDecoration(
        borderRadius: BorderRadius.circular(AppTokens.radius),
        border: Border.all(color: AppTokens.light.border),
      );
}

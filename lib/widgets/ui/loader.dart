import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:flutter/material.dart';

/// Floating "doing something" card. Used as the [GlobalLoaderOverlay] body
/// instead of a fullscreen spinner. Shows a small surface card with a spinner
/// and an optional secondary line.
class LoadingCard extends StatelessWidget {
  final String title;
  final String? subtitle;

  const LoadingCard({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Center(
      child: Container(
        constraints: const BoxConstraints(minWidth: 240),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: t.surface,
          border: Border.all(color: t.border),
          borderRadius: BorderRadius.circular(AppTokens.radius),
          boxShadow: t.shadow3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(t.accent),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: t.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style:
                        TextStyle(color: t.textMuted, fontSize: 11.5),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

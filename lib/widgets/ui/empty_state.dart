import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/surfaces.dart';
import 'package:flutter/material.dart';

class KbdHint {
  final List<String> keys;
  final String text;
  const KbdHint({required this.keys, required this.text});
}

class EmptyState extends StatelessWidget {
  final String title;
  final String? body;
  final String? hint;
  final List<KbdHint>? shortcuts;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    this.body,
    this.hint,
    this.shortcuts,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: t.text,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          if (body != null) ...[
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                body!,
                textAlign: TextAlign.center,
                style: TextStyle(color: t.textMuted, fontSize: 13, height: 1.5),
              ),
            ),
          ],
          if (shortcuts != null && shortcuts!.isNotEmpty) ...[
            const SizedBox(height: 16),
            for (final s in shortcuts!) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < s.keys.length; i++) ...[
                    if (i > 0) const SizedBox(width: 3),
                    Kbd(s.keys[i]),
                  ],
                  const SizedBox(width: 8),
                  Text(s.text,
                      style: TextStyle(color: t.textMuted, fontSize: 12)),
                ],
              ),
            ],
          ],
          if (action != null) ...[
            const SizedBox(height: 14),
            action!,
          ],
          if (hint != null) ...[
            const SizedBox(height: 8),
            Text(hint!,
                style: TextStyle(color: t.textDim, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

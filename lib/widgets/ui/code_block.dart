import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:flutter/material.dart';

/// Read-only monospace code block with optional gutter line numbers.
class CodeBlock extends StatelessWidget {
  final String text;
  final double height;
  final bool lineNumbers;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  const CodeBlock({
    super.key,
    required this.text,
    this.height = 220,
    this.lineNumbers = true,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final lines = text.split('\n');
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: t.codeBg,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppTokens.radius),
        border: border ?? Border.all(color: t.border),
      ),
      child: ClipRRect(
        borderRadius: (borderRadius is BorderRadius
                ? borderRadius as BorderRadius
                : null) ??
            BorderRadius.circular(AppTokens.radius),
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (lineNumbers)
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: t.codeLine),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < lines.length; i++)
                              Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: t.textDim,
                                  fontFamily: t.fontMono,
                                  fontSize: 11.5,
                                  height: AppTokens.lhCode,
                                ),
                              ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: SelectableText(
                        text,
                        style: TextStyle(
                          color: t.codeText,
                          fontFamily: t.fontMono,
                          fontSize: 11.5,
                          height: AppTokens.lhCode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

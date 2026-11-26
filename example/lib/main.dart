import 'package:auto_size_text_community/auto_size_text_community.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const ExampleApp());

/// Shows the same sentence in boxes of different widths, and two labels that
/// share one size through an [AutoSizeGroup].
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  static final _labelGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFF007AFF),
      builder: (context, _) => DefaultTextStyle(
        style: const TextStyle(color: Color(0xFF000000)),
        child: ColoredBox(
          color: const Color(0xFFFFFFFF),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              for (final width in [320.0, 200.0, 120.0])
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: width,
                    child: const AutoSizeText(
                      'This text shrinks to fit on two lines.',
                      style: TextStyle(fontSize: 30),
                      maxLines: 2,
                    ),
                  ),
                ),
              for (final label in ['Short', 'A much longer label'])
                SizedBox(
                  width: 160,
                  child: AutoSizeText(
                    label,
                    group: _labelGroup,
                    style: const TextStyle(fontSize: 30),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

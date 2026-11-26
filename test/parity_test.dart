// ignore_for_file: deprecated_member_use
import 'package:auto_size_text/auto_size_text.dart' as original;
import 'package:auto_size_text_community/auto_size_text.dart' as community;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders the same configuration with `auto_size_text` 3.0.0 and this package
/// and checks they pick the same rendered font size and the same overflow
/// handling.
void main() {
  const replacementKey = Key('replacement');
  const texts = [
    'A',
    'AutoSizeText',
    'The quick brown fox jumps over the lazy dog',
    'Supercalifragilisticexpialidocious is long',
    '한국어 문장과 English words 섞인 텍스트입니다',
  ];

  Future<(double?, bool)> renderedFontSize(
    WidgetTester tester,
    Widget autoSizeText, {
    required double width,
    required double height,
    required double mediaTextScale,
  }) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(mediaTextScale)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(width: width, height: height, child: autoSizeText),
          ),
        ),
      ),
    );
    if (find.byKey(replacementKey).evaluate().isNotEmpty) {
      return (null, true);
    }
    final text = tester.widget<Text>(find.byType(Text));
    final scaler =
        text.textScaler ?? TextScaler.linear(text.textScaleFactor ?? 1);
    return (scaler.scale(text.style!.fontSize!), false);
  }

  testWidgets('matches auto_size_text 3.0.0 across configurations', (
    tester,
  ) async {
    var compared = 0;
    for (final text in texts) {
      for (final width in [20.0, 60.0, 150.0, 400.0]) {
        for (final maxLines in [1, 2, null]) {
          for (final mediaTextScale in [1.0, 1.5]) {
            for (final (minFontSize, step, presets) in [
              (12.0, 1.0, null),
              (4.0, 0.5, null),
              (12.0, 1.0, [40.0, 20.0, 14.0, 8.0]),
            ]) {
              for (final wrapWords in [true, false]) {
                for (final useRich in [false, true]) {
                  const style = TextStyle(fontSize: 30);
                  final replacement = const SizedBox(key: replacementKey);

                  final originalWidget = useRich
                      ? original.AutoSizeText.rich(
                          TextSpan(text: text),
                          style: style,
                          maxLines: maxLines,
                          minFontSize: minFontSize,
                          stepGranularity: step,
                          presetFontSizes: presets,
                          wrapWords: wrapWords,
                          overflowReplacement: replacement,
                        )
                      : original.AutoSizeText(
                          text,
                          style: style,
                          maxLines: maxLines,
                          minFontSize: minFontSize,
                          stepGranularity: step,
                          presetFontSizes: presets,
                          wrapWords: wrapWords,
                          overflowReplacement: replacement,
                        );
                  final communityWidget = useRich
                      ? community.AutoSizeText.rich(
                          TextSpan(text: text),
                          style: style,
                          maxLines: maxLines,
                          minFontSize: minFontSize,
                          stepGranularity: step,
                          presetFontSizes: presets,
                          wrapWords: wrapWords,
                          overflowReplacement: replacement,
                        )
                      : community.AutoSizeText(
                          text,
                          style: style,
                          maxLines: maxLines,
                          minFontSize: minFontSize,
                          stepGranularity: step,
                          presetFontSizes: presets,
                          wrapWords: wrapWords,
                          overflowReplacement: replacement,
                        );

                  final expected = await renderedFontSize(
                    tester,
                    originalWidget,
                    width: width,
                    height: 120,
                    mediaTextScale: mediaTextScale,
                  );
                  await tester.pumpWidget(const SizedBox());
                  final actual = await renderedFontSize(
                    tester,
                    communityWidget,
                    width: width,
                    height: 120,
                    mediaTextScale: mediaTextScale,
                  );
                  await tester.pumpWidget(const SizedBox());

                  expect(
                    actual,
                    expected,
                    reason: '"$text" width=$width maxLines=$maxLines '
                        'scale=$mediaTextScale min=$minFontSize step=$step '
                        'presets=$presets wrapWords=$wrapWords rich=$useRich',
                  );
                  compared++;
                }
              }
            }
          }
        }
      }
    }
    expect(compared, 1440);
  });

  testWidgets('the deprecated textScaleFactor still matches the original', (
    tester,
  ) async {
    for (final factor in [0.5, 1.0, 2.0, 4.0]) {
      final expected = await renderedFontSize(
        tester,
        original.AutoSizeText(
          'Some text that wraps',
          style: const TextStyle(fontSize: 20),
          textScaleFactor: factor,
        ),
        width: 120,
        height: 200,
        mediaTextScale: 1,
      );
      await tester.pumpWidget(const SizedBox());
      final actual = await renderedFontSize(
        tester,
        community.AutoSizeText(
          'Some text that wraps',
          style: const TextStyle(fontSize: 20),
          textScaleFactor: factor,
        ),
        width: 120,
        height: 200,
        mediaTextScale: 1,
      );
      await tester.pumpWidget(const SizedBox());
      expect(actual, expected, reason: 'textScaleFactor=$factor');
    }
  });
}

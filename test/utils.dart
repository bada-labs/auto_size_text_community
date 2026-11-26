import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double effectiveFontSize(Text text) =>
    (text.textScaler ?? TextScaler.noScaling).scale(text.style!.fontSize!);

bool doesTextFit(
  Text text, [
  double maxWidth = double.infinity,
  double maxHeight = double.infinity,
  bool wrapWords = true,
]) {
  final span = text.textSpan ?? TextSpan(text: text.data, style: text.style);
  var maxLines = text.maxLines;
  if (!wrapWords) {
    final wordCount = span.toPlainText().split(RegExp('\\s+')).length;
    maxLines = maxLines!.clamp(1, wordCount);
  }

  final textPainter = TextPainter(
    text: span,
    textAlign: text.textAlign ?? TextAlign.start,
    textDirection: text.textDirection,
    textScaler: text.textScaler ?? TextScaler.noScaling,
    maxLines: text.maxLines,
    locale: text.locale,
    strutStyle: text.strutStyle,
  );

  textPainter.layout(maxWidth: maxWidth);

  return !(textPainter.didExceedMaxLines ||
      textPainter.height > maxHeight ||
      textPainter.width > maxWidth);
}

Future pump({
  required WidgetTester tester,
  required Widget widget,
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: widget,
      ),
    ),
  );
}

Future<Text> pumpAndGetText({
  required WidgetTester tester,
  required Widget widget,
}) async {
  await pump(tester: tester, widget: widget);
  return tester.widget<Text>(find.byType(Text));
}

Future pumpAndExpectFontSize({
  required WidgetTester tester,
  required double expectedFontSize,
  required Widget widget,
}) async {
  final text = await pumpAndGetText(tester: tester, widget: widget);
  expect(effectiveFontSize(text), expectedFontSize);
}

RichText getRichText(WidgetTester tester) =>
    tester.widget(find.byType(RichText));

class OverflowNotifier extends StatelessWidget {
  final VoidCallback overflowCallback;

  const OverflowNotifier(this.overflowCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    overflowCallback();
    return Container();
  }
}

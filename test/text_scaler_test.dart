import 'package:auto_size_text_community/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

/// Grows small text more than large text, like Android 14 font scaling.
class _NonlinearTextScaler extends TextScaler {
  const _NonlinearTextScaler();

  @override
  double scale(double fontSize) => fontSize < 20 ? fontSize * 2 : fontSize + 20;

  @override
  double get textScaleFactor => 2;
}

void main() {
  testWidgets('applies a nonlinear MediaQuery text scaler like Text does', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: _NonlinearTextScaler()),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AutoSizeText('Text', style: TextStyle(fontSize: 30)),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(effectiveFontSize(text), 50);
  });

  testWidgets('shrinks against the nonlinear size that is actually drawn', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: _NonlinearTextScaler()),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 300,
              child: AutoSizeText(
                'Some longer text',
                style: TextStyle(fontSize: 30),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(effectiveFontSize(text), lessThan(50));
    expect(tester.getSize(find.byType(Text)).width, lessThanOrEqualTo(300));
  });

  testWidgets('textScaler overrides textScaleFactor and MediaQuery', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(3)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AutoSizeText(
              'Text',
              style: TextStyle(fontSize: 20),
              // ignore: deprecated_member_use_from_same_package
              textScaleFactor: 2,
              textScaler: TextScaler.linear(1.5),
            ),
          ),
        ),
      ),
    );

    expect(effectiveFontSize(tester.widget<Text>(find.byType(Text))), 30);
  });

  testWidgets('measures right-to-left text in an RTL context', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: SizedBox(
            width: 120,
            child: AutoSizeText(
              'مرحبا بالعالم الجميل',
              style: TextStyle(fontSize: 30),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(effectiveFontSize(text), lessThan(30));
    expect(tester.getSize(find.byType(Text)).width, lessThanOrEqualTo(120));
  });
}

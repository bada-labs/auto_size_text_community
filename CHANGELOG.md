# Changelog

## 3.1.0

First release of `auto_size_text_community`, a maintained successor of [`auto_size_text`](https://pub.dev/packages/auto_size_text) 3.0.0. With linear text scaling it renders the same font sizes as 3.0.0 (checked against 1,440 configurations in `test/parity_test.dart`), and the original test suite passes unchanged apart from reading font sizes through `textScaler`.

* Add `textScaler`, so nonlinear font scaling (Android 14 and later) sizes text the way `Text` does. `textScaleFactor` still works and is deprecated.
* Read the ambient `MediaQuery` text scaler instead of the deprecated `MediaQuery.textScaleFactorOf`, and render with `Text.textScaler` instead of the deprecated `Text.textScaleFactor`.
* Dispose the `TextPainter`s used to measure text.
* Measure text in the ambient text direction when `textDirection` is not set, as the documentation already stated. 3.0.0 always measured left-to-right.
* Require Dart 3.2 and Flutter 3.16, the first versions with `TextScaler`.
* `package:auto_size_text_community/auto_size_text.dart` mirrors the original import path, so migrating only needs the package name changed.

# Changelog of auto_size_text

- Upgraded to null safety

## 2.1.0
- Added `textKey` parameter

## 2.0.2+1
- Fixed screenshots

## 2.0.2
- Fixed bug where `textScaleFactor` was not taken into account (thanks @Kavantix)

## 2.0.1
- Allow fractional font sizes again
- Fixed bug with `wrapWords` not working

## 2.0.0+2
- Added logo

## 2.0.0
- Significant performance improvements
- Prevent word wrapping using `wordWrap: false`
- Replacement widget in case of text overflow: `overflowReplacement`
- Added `strutStyle` parameter from `Text`
- Fixed problem in case the `AutoSizeTextGroup` changes
- Improved documentation
- Added many more tests

## 1.1.2
- Fixed bug where system font scale was applied twice (thanks @jeffersonatsafe)

## 1.1.1
- Fixed bug where setting the style of a `TextSpan` to null in `AutoSizeText.rich` didn't work (thanks @Koridev)
- Allow `minFontSize = 0`

## 1.1.0
- Added `group` parameter and `AutoSizeGroup` to synchronize multiple `AutoSizeText`s
- Fixed bug where `minFontSize` was not used correctly
- Improved documentation

## 1.0.0
- Library is used in multiple projects in production and is considered stable now.
- Added more tests

## 0.3.0
- Added textScaleFactor property with fallback to `MediaQuery.textScaleFactorOf()` (thanks @jeroentrappers)

## 0.2.2
- Fixed tests
- Improved documentation

## 0.2.1
- Fixed problem with `minFontSize` and `maxFontSize` (thanks @apaatsio)

## 0.2.0
- Added support for Rich Text using `AutoSizeText.rich()` with one or multiple `TextSpan`s.
- Improved text size calculation (using `textScaleFactor`)

## 0.1.0
- Fixed documentation (thanks @g-balas)
- Added tests

## 0.0.2
- Fixed documentation
- Added example

## 0.0.1
- First Release

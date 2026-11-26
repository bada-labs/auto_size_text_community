# auto_size_text_community

> **Discontinued.** Use [`auto_size_text_ce`](https://pub.dev/packages/auto_size_text_ce), the maintained community edition of `auto_size_text`. It also supports `TextScaler`, and in our comparison it renders the same sizes as `auto_size_text` 3.0.0 for word-wrapping text. This package will not receive updates.

[![pub package](https://img.shields.io/pub/v/auto_size_text_community.svg)](https://pub.dev/packages/auto_size_text_community)
[![CI](https://github.com/bada-labs/auto_size_text_community/actions/workflows/ci.yaml/badge.svg)](https://github.com/bada-labs/auto_size_text_community/actions/workflows/ci.yaml)

Flutter widget that automatically resizes text to fit perfectly within its bounds.

This is a maintained, drop-in successor of [`auto_size_text`](https://pub.dev/packages/auto_size_text), which has not been updated since 3.0.0 (2021). The API is the same, and with linear text scaling it picks the same font sizes as 3.0.0. Bada Labs uses it in its production apps.

## What's different from `auto_size_text` 3.0.0

- **`textScaler` support.** Android 14 and later scale small and large text by different amounts. `auto_size_text` only knew a single scale factor, so its sizes could differ from a `Text` next to it. Pass `textScaler`, or let it follow the ambient `MediaQuery`.
- **No deprecated Flutter APIs.** 3.0.0 relies on `textScaleFactor` APIs that Flutter deprecated and will remove.
- **Right-to-left text** is measured in the ambient text direction, as the original documentation promised.
- **No leaked `TextPainter`s** while measuring.

Everything else, including `AutoSizeGroup`, `presetFontSizes`, `wrapWords` and `overflowReplacement`, behaves as before. The original test suite runs unchanged in this repository, alongside a parity test that compares both packages across 1,440 configurations.

## Migrating from `auto_size_text`

1. In `pubspec.yaml`, replace `auto_size_text` with `auto_size_text_community`.
2. Replace `package:auto_size_text/` with `package:auto_size_text_community/` in your imports.

If you passed `textScaleFactor`, it keeps working. You can switch to `textScaler: TextScaler.linear(factor)` when convenient.

## Usage

`AutoSizeText` behaves like `Text`. It shrinks the font until the text fits its constraints and `maxLines`:

```dart
const SizedBox(
  width: 200,
  height: 140,
  child: AutoSizeText(
    'The text to display',
    style: TextStyle(fontSize: 30),
    maxLines: 2,
  ),
)
```

### Font size limits

```dart
AutoSizeText(
  'A really long String',
  style: TextStyle(fontSize: 30),
  minFontSize: 18,
  maxLines: 4,
  overflow: TextOverflow.ellipsis,
)
```

`stepGranularity` sets how far the size moves per step, and `presetFontSizes` restricts it to a list in descending order:

```dart
AutoSizeText(
  'A String with preset sizes',
  presetFontSizes: [40, 20, 14],
  maxLines: 4,
)
```

### Same size for several texts

Give texts the same `AutoSizeGroup` and they all use the smallest size that fits every one of them:

```dart
final group = AutoSizeGroup();

AutoSizeText('Text 1', group: group, maxLines: 1);
AutoSizeText('Text 2', group: group, maxLines: 1);
```

### Rich text

```dart
AutoSizeText.rich(
  TextSpan(text: 'A really long String'),
  style: TextStyle(fontSize: 20),
  minFontSize: 5,
)
```

### Replacement when nothing fits

```dart
AutoSizeText(
  'A String that will not fit',
  maxLines: 1,
  minFontSize: 14,
  overflowReplacement: Text('Sorry, the text is too long'),
)
```

Set `wrapWords: false` to shrink long words onto one line instead of breaking them.

## Parameters

| Parameter | Description |
|---|---|
| `key`, `textKey` | Key for the widget and for the `Text` it builds. |
| `style`, `strutStyle`, `textAlign`, `textDirection`, `locale`, `softWrap`, `overflow`, `semanticsLabel` | Same as `Text`. |
| `minFontSize` | Smallest size to shrink to. Ignored when `presetFontSizes` is set. Default 12. |
| `maxFontSize` | Largest size to use. Ignored when `presetFontSizes` is set. |
| `stepGranularity` | Size of each shrinking step. Default 1. |
| `presetFontSizes` | Allowed sizes in descending order. |
| `group` | Synchronizes the size of several `AutoSizeText`s. |
| `maxLines` | Maximum number of lines. |
| `wrapWords` | Whether words that do not fit on one line may wrap. Default true. |
| `overflowReplacement` | Shown when the text does not fit even at the minimum size. |
| `textScaler` | How font sizes are scaled. Defaults to the ambient `MediaQuery`. |
| `textScaleFactor` | Deprecated. Use `textScaler`. |

## Scope

This package fixes bugs and keeps up with Flutter changes. New features are considered conservatively to keep it small and dependable.

## Credits

Based on [`auto_size_text`](https://pub.dev/packages/auto_size_text) by Simon Leier, under the MIT license. Maintained by [Bada Labs](https://badalabs.com).

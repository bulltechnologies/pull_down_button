import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/src/internals/blur.dart';

void main() {
  testWidgets('blur reuse preserves sigma and brightness', (tester) async {
    late BuildContext context;

    Future<void> setBrightness(Brightness brightness) => tester.pumpWidget(
      CupertinoApp(
        theme: CupertinoThemeData(brightness: brightness),
        home: Builder(
          builder: (current) {
            context = current;
            return const SizedBox();
          },
        ),
      ),
    );

    await setBrightness(Brightness.light);
    final ImageFilter light = BlurUtils.menuBlur(context);
    expect(identical(BlurUtils.menuBlur(context), light), isTrue);
    expect(BlurUtils.menuBlur(context, sigma: 12), isNot(light));

    await setBrightness(Brightness.dark);
    final ImageFilter dark = BlurUtils.menuBlur(context);
    expect(dark, isNot(light));
    expect(identical(BlurUtils.menuBlur(context), dark), isTrue);

    await setBrightness(Brightness.light);
    expect(identical(BlurUtils.menuBlur(context), light), isTrue);
  });

  testWidgets('changing sigma does not retain obsolete filters forever', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (current) {
            context = current;
            return const SizedBox();
          },
        ),
      ),
    );

    final ImageFilter first = BlurUtils.menuBlur(context, sigma: 100);
    for (var i = 101; i < 201; i++) {
      BlurUtils.menuBlur(context, sigma: i.toDouble());
    }
    final ImageFilter recreated = BlurUtils.menuBlur(context, sigma: 100);
    // Cache eviction changes allocation, never the resulting filter.
    expect(identical(first, recreated), isFalse);
    expect(recreated, first);
    expect(
      identical(BlurUtils.menuBlur(context, sigma: 100), recreated),
      isTrue,
    );
  });
}

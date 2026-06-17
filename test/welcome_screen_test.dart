import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/core/theme/app_colors.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/features/auth/screens/welcome_screen.dart';

void main() {
  testWidgets('welcome screen uses reference title, dots, and pill geometry',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const WelcomeScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    final title = tester.widget<Text>(
      find.text('The Trading Operating System'),
    );
    expect(title.style?.fontFamily, 'Orbitron');
    expect(title.style?.color, AppColors.primary);
    expect(title.style?.fontSize, closeTo(20, 0.1));

    final getStartedSize = tester.getSize(find.text('Get Started'));
    final loginSize = tester.getSize(find.text('Log in'));
    expect(getStartedSize.height, lessThanOrEqualTo(40));
    expect(loginSize.height, lessThanOrEqualTo(40));

    final dotDecorations = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .where((decoration) => decoration.shape == BoxShape.circle)
        .toList();
    expect(dotDecorations, hasLength(3));

    final dots = find.byWidgetPredicate(
      (widget) =>
          widget is AnimatedContainer &&
          widget.decoration is BoxDecoration &&
          (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
    );
    for (var index = 0; index < 3; index += 1) {
      expect(tester.getSize(dots.at(index)).width, closeTo(15, 0.1));
      expect(tester.getSize(dots.at(index)).height, closeTo(5, 0.1));
      expect(
        tester.widget<AnimatedContainer>(dots.at(index)).margin,
        const EdgeInsets.symmetric(horizontal: 5),
      );
    }

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/core/theme/app_colors.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/features/auth/screens/welcome_screen.dart';

void main() {
  testWidgets('welcome screen uses the Figma onboarding carousel',
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

    final title = tester.widget<Text>(find.text('The Trading Operating System'));
    expect(title.style?.fontFamily, 'Orbitron');
    expect(title.style?.color, AppColors.primary);
    expect(title.style?.fontSize, closeTo(20, 0.1));
    expect(find.text('poise'), findsNothing);
    expect(find.text('Automated Risk Guardrails'), findsNothing);
    expect(find.text('Real-Time AI Coaching'), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/onboarding_trading_os.png',
      ),
      findsOneWidget,
    );

    final getStartedButton = find.byType(FilledButton);
    final loginButton = find.byType(OutlinedButton);
    expect(tester.getTopLeft(getStartedButton), const Offset(24, 688));
    expect(tester.getSize(getStartedButton), const Size(342, 44));
    expect(tester.getTopLeft(loginButton), const Offset(24, 744));
    expect(tester.getSize(loginButton), const Size(342, 44));

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
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith('welcome-dot-'),
    );
    expect(tester.getSize(dots.at(0)).width, closeTo(25, 0.1));
    expect(tester.getSize(dots.at(0)).height, closeTo(9, 0.1));
    expect(tester.getSize(dots.at(1)).width, closeTo(23, 0.1));
    expect(tester.getSize(dots.at(1)).height, closeTo(7, 0.1));
    expect(tester.getSize(dots.at(2)).width, closeTo(21, 0.1));
    expect(tester.getSize(dots.at(2)).height, closeTo(5, 0.1));
    for (var index = 0; index < 3; index += 1) {
      expect(
        tester.widget<AnimatedContainer>(dots.at(index)).margin,
        const EdgeInsets.symmetric(horizontal: 8),
      );
    }

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Automated Risk Guardrails'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/onboarding_guardrails.png',
      ),
      findsOneWidget,
    );

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Real-Time AI Coaching'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/onboarding_ai_coaching.png',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('The Trading Operating System'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poise_ai/core/theme/app_colors.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/core/widgets/brand/poise_wordmark.dart';
import 'package:poise_ai/core/widgets/buttons/p_primary_button.dart';
import 'package:poise_ai/core/widgets/inputs/p_text_field.dart';
import 'package:poise_ai/features/auth/screens/register_screen.dart';

Widget _authHarness(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  testWidgets('register screen matches authoritative create-account shell',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_authHarness(const RegisterScreen()));

    expect(find.text('Sign up'), findsNothing);
    expect(find.text('Enter Details'), findsNothing);
    expect(find.byType(PoiseWordmark), findsOneWidget);
    expect(
      tester.getSize(find.byType(PoiseWordmark)),
      const Size(PoiseWordmark.width, PoiseWordmark.height),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('register-wordmark'))),
      const Offset(24, 82),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('register-content'))),
      const Offset(24, 156),
    );
    expect(find.text('Create your account'), findsOneWidget);
    expect(
      find.text('Start your 14-day free trial. No credit card required'),
      findsOneWidget,
    );
    expect(find.text('Your name'), findsWidgets);
    expect(find.text('Email address'), findsWidgets);
    expect(find.text('Create password'), findsWidgets);
    expect(find.text('Confirm password'), findsWidgets);
    expect(
      find.textContaining(
        'Already have an account? Log in',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(find.text('Requires at least:'), findsNothing);

    final firstEditable = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    expect(firstEditable.autofocus, isFalse);

    for (var index = 0; index < 4; index += 1) {
      expect(
        tester.getSize(find.byType(TextFormField).at(index)).height,
        inInclusiveRange(40, 48),
      );
    }

    final registerButton = find.byType(PPrimaryButton);
    final button = tester.widget<PPrimaryButton>(registerButton);
    expect(button.textStyle?.fontFamily, 'Inter');
    expect(button.textStyle?.fontSize, 16);
    expect(button.textStyle?.fontWeight, FontWeight.w600);
    expect(button.disabledLabelColor, AppColors.textSecondary);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('register-bottom-actions'))),
      const Offset(16, 724),
    );
    expect(tester.getTopLeft(registerButton), const Offset(24, 724));
    expect(tester.getSize(registerButton), const Size(342, 48));
    expect(
      tester.getSize(find.byKey(const ValueKey('register-auth-switch'))),
      const Size(358, 20),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('register-auth-switch'))),
      const Offset(16, 788),
    );
    expect(
      tester
          .getBottomLeft(find.byKey(const ValueKey('register-auth-switch')))
          .dy,
      lessThanOrEqualTo(
          tester.view.physicalSize.height / tester.view.devicePixelRatio),
    );

    expect(
      tester.widget<PPrimaryButton>(find.byType(PPrimaryButton)).onPressed,
      isNull,
    );
  });

  testWidgets('register continue enables only after all fields are valid',
      (tester) async {
    await tester.pumpWidget(_authHarness(const RegisterScreen()));

    await tester.enterText(find.byType(TextFormField).at(0), 'Olaide Gbeyide');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'olaide@poise.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'HD3sd83!');
    await tester.enterText(find.byType(TextFormField).at(3), '3KNBHJ88');
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(
      tester.widget<PPrimaryButton>(find.byType(PPrimaryButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextFormField).at(3), 'HD3sd83!');
    await tester.pump();

    expect(find.text('Passwords do not match'), findsNothing);
    expect(
      tester.widget<PPrimaryButton>(find.byType(PPrimaryButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('register email validates on blur without shrinking input',
      (tester) async {
    await tester.pumpWidget(_authHarness(const RegisterScreen()));

    await tester.enterText(find.byType(TextFormField).at(0), 'Blessing Umoh');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'blessingyopmail.com',
    );
    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(
      tester.getSize(find.byType(TextFormField).at(1)),
      const Size(342, 48),
    );
    expect(
      tester.getTopLeft(find.text('Enter a valid email address')).dy,
      greaterThan(tester.getBottomLeft(find.byType(TextFormField).at(1)).dy),
    );
  });

  testWidgets('register password field waits before showing error while typing',
      (tester) async {
    await tester.pumpWidget(_authHarness(const RegisterScreen()));

    await tester.tap(find.byType(TextFormField).at(2));
    await tester.enterText(find.byType(TextFormField).at(2), 'B');
    await tester.pump();

    expect(find.text('Password does not meet all requirements'), findsNothing);
    expect(find.byIcon(Icons.error_outline_rounded), findsNothing);

    await tester.pump(const Duration(seconds: 2));

    expect(
        find.text('Password does not meet all requirements'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(
      tester.getSize(find.byType(TextFormField).at(2)),
      const Size(342, 48),
    );
  });

  testWidgets('register password requirements state keeps auth switch visible',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_authHarness(const RegisterScreen()));

    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pump();

    expect(find.text('Requires at least:'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Requires at least:')).dy, 514);
    expect(
      tester.getTopLeft(find.text('Confirm password')),
      const Offset(24, 606),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('register-bottom-actions'))),
      const Offset(16, 724),
    );
    expect(
      tester
          .getBottomLeft(find.byKey(const ValueKey('register-auth-switch')))
          .dy,
      lessThanOrEqualTo(
          tester.view.physicalSize.height / tester.view.devicePixelRatio),
    );
  });

  testWidgets('disabled primary button uses muted label and pale fill',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PPrimaryButton(label: 'Continue'),
        ),
      ),
    );

    final container =
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    final label = tester.widget<Text>(find.text('Continue'));

    expect(decoration.color, AppColors.bgCardElevated);
    expect(label.style?.color, AppColors.textDisabled);
  });

  testWidgets('obscure text field shows error suffix instead of eye on error',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: PTextField(
            label: 'Create password',
            obscureText: true,
            fieldState: PFieldState.error,
            errorText: 'Password does not meet all requirements',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(find.byTooltip('Show value'), findsNothing);
  });
}

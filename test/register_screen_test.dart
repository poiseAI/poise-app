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
    await tester.pumpWidget(_authHarness(const RegisterScreen()));

    expect(find.text('Sign up'), findsNothing);
    expect(find.text('Enter Details'), findsNothing);
    expect(find.byType(PoiseWordmark), findsOneWidget);
    expect(
      tester.getSize(find.byType(PoiseWordmark)),
      const Size(PoiseWordmark.width, PoiseWordmark.height),
    );
    expect(find.text('Create your account'), findsOneWidget);
    expect(
      find.text('Start your 14-day free trial. No credit card required'),
      findsOneWidget,
    );
    expect(find.text('Your name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Create password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

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

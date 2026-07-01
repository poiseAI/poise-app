import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/network/api_client.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/core/widgets/brand/poise_wordmark.dart';
import 'package:poise_ai/core/widgets/buttons/p_primary_button.dart';
import 'package:poise_ai/core/widgets/inputs/p_text_field.dart';
import 'package:poise_ai/features/auth/screens/login_screen.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  testWidgets('login screen matches the Welcome back reference design',
      (tester) async {
    final dio = _MockDio();
    when(
      () => dio.post<Map<String, dynamic>>(
        any(),
        data: any<dynamic>(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response<void>(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
        ),
      ),
    );

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      ),
    );

    // Reference copy
    expect(find.text('Welcome back'), findsOneWidget);
    expect(
      find.textContaining(
          'Log into your Poise account to access your dashboard'),
      findsOneWidget,
    );
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.textContaining("Don't have an account?"), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    // Figma wordmark frame: 98.583 x 28 at x=24, y=82.
    expect(find.byType(PoiseWordmark), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('login-wordmark'))),
      const Offset(24, 82),
    );
    expect(
      tester.getSize(find.byType(PoiseWordmark)),
      const Size(PoiseWordmark.width, PoiseWordmark.height),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('login-content'))),
      const Offset(24, 162),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('login-bottom-actions'))),
      const Offset(24, 728),
    );

    // Eye toggle present on password field
    expect(find.byIcon(Icons.shield_rounded), findsNothing);

    // Heading left-aligned
    final heading = tester.getTopLeft(find.text('Welcome back'));
    expect(heading.dx, closeTo(24, 0.5));

    // Login button is 48dp in the updated Figma screen.
    final loginButton = find.byType(PPrimaryButton);
    expect(tester.getTopLeft(loginButton), const Offset(24, 728));
    expect(tester.getSize(loginButton), const Size(342, 48));

    // Forgot password left-aligned
    final forgotPassword = tester.getTopLeft(find.text('Forgot password?'));
    final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(forgotPassword.dx, lessThan(screenSize.width / 2));

    // Button disabled until both fields filled
    expect(
      tester.widget<PPrimaryButton>(find.byType(PPrimaryButton)).onPressed,
      isNull,
    );

    await tester.enterText(
        find.byType(TextFormField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.pump();

    expect(
      tester.widget<PPrimaryButton>(find.byType(PPrimaryButton)).onPressed,
      isNotNull,
    );

    await tester.tap(find.byType(PPrimaryButton));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('login-error-alert')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('login-error-alert'))),
      const Offset(24, 262),
    );
    expect(find.text('Invalid login credentials'), findsOneWidget);

    final alertContainer = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const ValueKey('login-error-alert')),
            matching: find.byType(Container),
          )
          .first,
    );
    final alertDecoration = alertContainer.decoration! as BoxDecoration;
    expect(alertDecoration.color, const Color(0xFFFEF3F2));
    expect(
      (alertDecoration.borderRadius! as BorderRadius).topLeft.x,
      8,
    );
    expect(
      (alertDecoration.border! as Border).top.color,
      const Color(0xFFFEE4E2),
    );

    final alertText =
        tester.widget<Text>(find.text('Invalid login credentials'));
    expect(alertText.style?.fontSize, 14);
    expect(alertText.style?.fontWeight, FontWeight.w600);
    expect(alertText.style?.color, const Color(0xFFD92D20));

    final emailField = tester.widget<PTextField>(find.byType(PTextField).at(0));
    final passwordField =
        tester.widget<PTextField>(find.byType(PTextField).at(1));
    expect(emailField.fieldState, PFieldState.error);
    expect(passwordField.fieldState, PFieldState.error);
    expect(emailField.errorText, isNull);
    expect(passwordField.errorText, isNull);
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);

    await tester.pump(const Duration(seconds: 4));
  });
}

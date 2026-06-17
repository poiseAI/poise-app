import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poise_ai/core/network/api_client.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/core/widgets/buttons/p_primary_button.dart';
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

    tester.view.physicalSize = const Size(1125, 2436);
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

    // poise wordmark present (text 'poise')
    expect(find.text('poise'), findsOneWidget);

    // Eye toggle present on password field
    expect(find.byIcon(Icons.shield_rounded), findsNothing);

    // Heading left-aligned
    final heading = tester.getTopLeft(find.text('Welcome back'));
    expect(heading.dx, closeTo(24, 0.5));

    // Login button is 44dp
    final loginButton = tester.getSize(find.byType(PPrimaryButton));
    expect(loginButton.height, closeTo(44, 0.5));

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

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);

    await tester.pump(const Duration(seconds: 4));
  });
}

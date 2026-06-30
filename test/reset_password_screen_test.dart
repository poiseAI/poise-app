import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/core/errors/app_error.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/core/utils/result.dart';
import 'package:poise_ai/core/widgets/buttons/p_primary_button.dart';
import 'package:poise_ai/core/widgets/inputs/p_otp_field.dart';
import 'package:poise_ai/features/auth/data/auth_api.dart';
import 'package:poise_ai/features/auth/screens/reset_password_screen.dart';

class _ResetPasswordApi extends AuthApi {
  _ResetPasswordApi() : super(Dio());

  bool resetCalled = false;

  @override
  Future<Result<void, AppError>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    resetCalled = true;
    return const Ok(null);
  }
}

Widget _authHarness(Widget child, {AuthApi? authApi}) {
  return ProviderScope(
    overrides: [
      if (authApi != null) authApiProvider.overrideWithValue(authApi),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

Future<void> _advanceToPasswordStep(WidgetTester tester) async {
  await tester.enterText(find.byType(POtpField), '123456');
  await tester.pump();
  await tester.tap(find.text('Continue'));
  await tester.pump();
}

void main() {
  testWidgets('reset password OTP step matches Figma geometry', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _authHarness(const ResetPasswordScreen(email: 'user@example.com')),
    );

    expect(find.text('Forgot password'), findsNothing);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('reset-back-button'))),
      const Offset(22, 74),
    );
    expect(find.text('Enter OTP'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('reset-otp-content'))),
      const Offset(24, 130),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('reset-otp-content'))),
      const Size(342, 220),
    );
    expect(tester.getTopLeft(find.byType(POtpField)), const Offset(24, 250));
    expect(tester.getSize(find.byType(POtpField)), const Size(342, 64));
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('reset-otp-request'))),
      const Offset(24, 330),
    );
    expect(
      tester.getTopLeft(find.byType(PPrimaryButton)),
      const Offset(24, 724),
    );
    expect(tester.getSize(find.byType(PPrimaryButton)), const Size(342, 48));
  });

  testWidgets(
      'reset password password step matches reference copy and controls',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _authHarness(const ResetPasswordScreen(email: 'user@example.com')),
    );

    await _advanceToPasswordStep(tester);

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Create a new password'), findsOneWidget);
    expect(
      find.text('Enter a new secure password for your account'),
      findsOneWidget,
    );
    expect(find.text('Create New Password'), findsNothing);
    expect(find.text('Forgot Password'), findsNothing);
    expect(find.text('Save'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('reset-password-content'))),
      const Offset(24, 134),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('reset-password-content'))),
      const Size(342, 356),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    for (var index = 0; index < 2; index += 1) {
      expect(
        tester.getSize(find.byType(TextFormField).at(index)).height,
        inInclusiveRange(40, 48),
      );
    }

    final button = tester.widget<PPrimaryButton>(find.byType(PPrimaryButton));
    expect(button.label, 'Save');
    expect(
      tester.getTopLeft(find.byType(PPrimaryButton)),
      const Offset(24, 724),
    );
    expect(tester.getSize(find.byType(PPrimaryButton)), const Size(342, 48));
  });

  testWidgets('reset password success screen matches reference',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final authApi = _ResetPasswordApi();
    await tester.pumpWidget(
      _authHarness(
        const ResetPasswordScreen(email: 'user@example.com'),
        authApi: authApi,
      ),
    );

    await _advanceToPasswordStep(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'HD3sd83!');
    await tester.enterText(find.byType(TextFormField).at(1), 'HD3sd83!');
    await tester.pump();
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(authApi.resetCalled, isTrue);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('reset-success-seal'))),
      const Offset(95, 166),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('reset-success-seal'))),
      const Size(200, 200),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('reset-success-copy'))),
      const Offset(24, 458),
    );
    expect(find.text('Your password has been updated'), findsOneWidget);
    expect(
      find.text(
        'Your password has been reset successfully, you can now proceed to log in.',
      ),
      findsOneWidget,
    );
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Login'), findsNothing);
    expect(
      tester.getTopLeft(find.byType(PPrimaryButton)),
      const Offset(23, 724),
    );
    expect(tester.getSize(find.byType(PPrimaryButton)), const Size(342, 48));
  });
}

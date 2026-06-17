import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poise_ai/core/theme/app_theme.dart';
import 'package:poise_ai/features/ai_chat/screens/ai_chat_screen.dart';
import 'package:poise_ai/features/ai_chat/data/models/chat_message.dart';
import 'package:poise_ai/features/ai_chat/providers/ai_chat_provider.dart';
import 'package:poise_ai/features/auth/providers/auth_provider.dart';
import 'package:poise_ai/features/auth/providers/auth_state.dart';
import 'package:poise_ai/features/billing/data/billing_api.dart';

void main() {
  testWidgets('Ask Poise blocks non-Core users with upgrade CTA',
      (tester) async {
    await tester.pumpWidget(_chatHarness(BillingSubscription.none));
    await tester.pumpAndSettle();

    expect(find.text('Ask Poise AI\nabout your\ntrading'), findsOneWidget);
    expect(
      find.text(
          'Start your 14-day Poise Core trial to chat with Poise AI about your trading.'),
      findsOneWidget,
    );
    expect(find.text('Start trial'), findsOneWidget);
    expect(find.text('Type a message'), findsNothing);
  });

  testWidgets('Ask Poise does not send initial prompt for non-Core users',
      (tester) async {
    final chat = _TestAiChat();
    await tester.pumpWidget(_chatHarness(
      BillingSubscription.none,
      chat: chat,
      initialPrompt: 'Explain this trade insight',
    ));
    await tester.pumpAndSettle();

    expect(chat.sendCalls, 0);
    expect(find.text('Start trial'), findsOneWidget);
  });

  testWidgets('Ask Poise allows active Core users to type', (tester) async {
    await tester.pumpWidget(_chatHarness(
        const BillingSubscription(
          plan: BillingPlan.core,
          status: BillingStatus.active,
          entitled: true,
        ),
        messages: [
          ChatMessage.ai(text: 'Welcome back.', at: DateTime(2026, 6, 17)),
        ]));
    await tester.pumpAndSettle();

    expect(find.text('Type a message'), findsOneWidget);
    expect(find.text('Start trial'), findsNothing);
  });
}

Widget _chatHarness(
  BillingSubscription subscription, {
  List<ChatMessage> messages = const [],
  _TestAiChat? chat,
  String? initialPrompt,
}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _TestAuth(subscription)),
      aiChatProvider.overrideWith(() => chat ?? _TestAiChat(messages)),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: AiChatScreen(initialPrompt: initialPrompt),
    ),
  );
}

class _TestAiChat extends AiChat {
  _TestAiChat([this.messages = const []]);
  final List<ChatMessage> messages;
  int sendCalls = 0;

  @override
  List<ChatMessage> build() => messages;

  @override
  Future<void> send(String text) async {
    sendCalls++;
  }
}

class _TestAuth extends Auth {
  _TestAuth(this.subscription);
  final BillingSubscription subscription;

  @override
  Future<AuthState> build() async => AuthState.authenticated(
        userId: 'user-1',
        email: 'trader@example.com',
        token: 'token',
        fullName: 'Test Trader',
        emailVerified: true,
        hasActiveStrategy: true,
        subscription: subscription,
      );
}

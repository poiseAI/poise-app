import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';
import '../../billing/data/billing_api.dart';
import '../../billing/providers/billing_provider.dart';
import '../data/ai_chat_api.dart';
import '../data/models/chat_message.dart';
import '../providers/ai_chat_provider.dart';
import 'widgets/chat_bubbles.dart';
import 'widgets/confirmation_card.dart';
import 'widgets/tool_call_card.dart';

const _suggestedPrompts = [
  'How did I perform this week?',
  'What should I improve first?',
  'Where am I exceeding my limits?',
  'What patterns do you see in my trading?',
];

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key, this.initialPrompt});

  final String? initialPrompt;

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _inputCtrl = TextEditingController();
  final _inputFocus = FocusNode();
  final _scrollCtrl = ScrollController();
  bool _isMultiline = false;
  bool _sentInitialPrompt = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _inputFocus.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    ref.read(aiChatProvider.notifier).send(text);
    _inputCtrl.clear();
    setState(() => _isMultiline = false);
    _scrollToBottom();
  }

  void _stop() => ref.read(aiChatProvider.notifier).stopStreaming();

  Future<void> _showHistory() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChatHistorySheet(
        onSessionTap: (session) async {
          Navigator.pop(context);
          await ref.read(aiChatProvider.notifier).loadSession(session.id);
          _scrollToBottom();
        },
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiChatProvider);
    final notifier = ref.read(aiChatProvider.notifier);
    final subscription = ref.watch(authProvider).valueOrNull?.subscription ??
        BillingSubscription.none;
    final hasCore = subscription.entitled;
    final isStreaming =
        messages.whereType<AiMessage>().any((msg) => msg.isStreaming);

    _maybeSendInitialPrompt(hasCore);
    ref.listen(aiChatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          tooltip: messages.isEmpty ? 'Back home' : 'Back to new chat',
          onPressed: () {
            if (messages.isEmpty) {
              context.go(Routes.home);
            } else {
              ref.invalidate(aiChatProvider);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Poise AI'),
        actions: [
          IconButton(
            tooltip: 'Chat history',
            onPressed: _showHistory,
            icon: const Icon(Icons.history_rounded),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Messages
            Expanded(
              child: !hasCore
                  ? _CoreLockedState(
                      onStartTrial: () async {
                        final result = await ref
                            .read(billingControllerProvider)
                            .startCheckout();
                        if (result.isErr && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.error.userMessage)),
                          );
                        }
                      },
                    )
                  : messages.isEmpty
                      ? _EmptyState(
                          onStartTap: () => _inputFocus.requestFocus(),
                          onPromptTap: (p) {
                            _inputCtrl.text = p;
                            _send();
                          },
                        )
                      : ListView.separated(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: messages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (ctx, i) =>
                              _buildMessage(messages[i], notifier),
                        ),
            ),

            // Input bar
            if (hasCore)
              _InputBar(
                controller: _inputCtrl,
                focusNode: _inputFocus,
                isStreaming: isStreaming,
                onSend: _send,
                onStop: _stop,
                onChanged: (val) {
                  final isMulti = val.contains('\n') || val.length > 60;
                  if (isMulti != _isMultiline) {
                    setState(() => _isMultiline = isMulti);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _maybeSendInitialPrompt(bool hasCore) {
    final prompt = widget.initialPrompt?.trim();
    if (!hasCore || _sentInitialPrompt || prompt == null || prompt.isEmpty) {
      return;
    }
    _sentInitialPrompt = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(aiChatProvider.notifier).send(prompt);
      _scrollToBottom();
    });
  }

  Widget _buildMessage(ChatMessage msg, AiChat notifier) {
    return switch (msg) {
      UserMessage() => UserBubble(text: msg.text),
      AiMessage() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AiBubble(text: msg.text, isStreaming: msg.isStreaming),
            if (msg.toolCalls.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: msg.toolCalls
                      .map((t) => ToolCallCard(toolCall: t))
                      .toList(),
                ),
              ),
          ],
        ),
      ConfirmationMessage() => ConfirmationCard(
          message: msg,
          onConfirm: () => notifier.confirm(msg.toolCallId, true),
          onCancel: () => notifier.confirm(msg.toolCallId, false),
        ),
      ToolResultMessage() => const SizedBox.shrink(),
    };
  }
}

class _CoreLockedState extends StatelessWidget {
  const _CoreLockedState({required this.onStartTrial});

  final VoidCallback onStartTrial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 46),
          Text(
            'Ask Poise AI\nabout your\ntrading',
            style: AppTypography.display1.copyWith(
              color: AppColors.brand100,
              fontSize: 38,
              height: 1.16,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          Text(
            'Start your 14-day Poise Core trial to chat with Poise AI about your trading.',
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PPrimaryButton(
            label: 'Start trial',
            height: 48,
            onPressed: onStartTrial,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onStartTap, required this.onPromptTap});
  final VoidCallback onStartTap;
  final ValueChanged<String> onPromptTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 46),
          Text(
            'Ask Poise AI\nabout your\ntrading',
            style: AppTypography.display1.copyWith(
              color: AppColors.brand100,
              fontSize: 38,
              height: 1.16,
              letterSpacing: 0,
            ),
          ).animate().fadeIn(duration: 260.ms).slideY(
                begin: 0.025,
                end: 0,
                curve: Curves.easeOutCubic,
              ),
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onStartTap,
            child: const SizedBox(height: 12, width: double.infinity),
          ),
          Text(
            'Popular ways to get started',
            style: AppTypography.h4.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _suggestedPrompts.asMap().entries.map(
              (e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onPromptTap(e.value);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.04),
                        borderRadius: AppRadius.pillRadius,
                        border: Border.all(color: AppColors.brand50),
                      ),
                      child: Text(
                        e.value,
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ).animate(delay: (260 + e.key * 40).ms).fadeIn(
                        duration: 220.ms,
                      ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.isStreaming,
    required this.onSend,
    required this.onStop,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isStreaming;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: AppRadius.chipRadius,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: 5,
                minLines: 1,
                style: AppTypography.body,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: AppTypography.body
                      .copyWith(color: AppColors.textDisabled),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          // Send/Stop morph (#65)
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              isStreaming ? onStop() : onSend();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isStreaming
                    ? AppColors.lossRed.withValues(alpha: 0.12)
                    : AppColors.bgCardElevated,
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isStreaming ? Icons.stop_rounded : Icons.arrow_upward_rounded,
                  key: ValueKey(isStreaming),
                  size: 28,
                  color:
                      isStreaming ? AppColors.lossRed : AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatHistorySheet extends ConsumerStatefulWidget {
  const _ChatHistorySheet({required this.onSessionTap});

  final ValueChanged<AiSession> onSessionTap;

  @override
  ConsumerState<_ChatHistorySheet> createState() => _ChatHistorySheetState();
}

class _ChatHistorySheetState extends ConsumerState<_ChatHistorySheet> {
  late Future<List<AiSession>> _future;
  String? _error;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<AiSession>> _load() async {
    final result = await ref.read(aiChatApiProvider).getSessions();
    return result.fold(
      onOk: (sessions) {
        _error = null;
        sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return sessions;
      },
      onErr: (err) {
        _error = err.userMessage;
        return const [];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.72,
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Chat history', style: AppTypography.h2),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                child: FutureBuilder<List<AiSession>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (_error != null) {
                      return _HistoryEmpty(
                        icon: Icons.error_outline_rounded,
                        title: 'Unable to load history',
                        body: _error!,
                      );
                    }
                    final sessions = snapshot.data ?? const [];
                    if (sessions.isEmpty) {
                      return const _HistoryEmpty(
                        icon: Icons.forum_outlined,
                        title: 'No previous chats',
                        body: 'Your Poise AI conversations will appear here.',
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: sessions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return _HistoryTile(
                          session: session,
                          onTap: () => widget.onSessionTap(session),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.session, required this.onTap});

  final AiSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title =
        session.title.trim().isEmpty ? 'Untitled conversation' : session.title;
    return Material(
      color: AppColors.bgSurface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _sessionTimeLabel(session.updatedAt),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: AppColors.textDisabled),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: AppTypography.h4, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

String _sessionTimeLabel(DateTime updatedAt) {
  final diff = DateTime.now().difference(updatedAt);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${updatedAt.year}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}';
}

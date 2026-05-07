import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/models/chat_message.dart';
import '../providers/ai_chat_provider.dart';
import 'widgets/chat_bubbles.dart';
import 'widgets/confirmation_card.dart';
import 'widgets/tool_call_card.dart';

const _suggestedPrompts = [
  "What's my P&L today?",
  'Show open positions',
  "What's the risk on BTC?",
  'Set TP for my biggest position',
];

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isMultiline = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
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
    final isStreaming =
        messages.whereType<AiMessage>().any((msg) => msg.isStreaming);

    ref.listen(aiChatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withValues(alpha: 0.12),
                      borderRadius: AppRadius.chipRadius,
                    ),
                    child: const Icon(Icons.auto_awesome_rounded,
                        size: 18, color: AppColors.accentPurple),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Text('Poise AI', style: AppTypography.h3),
                  const Spacer(),
                  if (messages.isNotEmpty)
                    TextButton(
                      onPressed: () => ref.invalidate(aiChatProvider),
                      child: Text('Clear',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textSecondary)),
                    ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: messages.isEmpty
                  ? _EmptyState(
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
            _InputBar(
              controller: _inputCtrl,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPromptTap});
  final ValueChanged<String> onPromptTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.accentPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                size: 36, color: AppColors.accentPurple),
          )
              .animate()
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
          const SizedBox(height: AppSpacing.lg),
          const Text('Ask Poise AI anything', style: AppTypography.h3)
              .animate(delay: 100.ms)
              .fadeIn(),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'I can check your positions, risk scores, and execute trades with your confirmation.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: AppSpacing.xl),
          // Suggested prompts (#54)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.center,
            children: _suggestedPrompts.asMap().entries.map((e) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onPromptTap(e.value);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: AppRadius.chipRadius,
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(e.value,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary)),
                ),
              )
                  .animate(delay: (300 + e.key * 50).ms)
                  .fadeIn(duration: 250.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.isStreaming,
    required this.onSend,
    required this.onStop,
    required this.onChanged,
  });

  final TextEditingController controller;
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
                maxLines: 5,
                minLines: 1,
                style: AppTypography.body,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Ask Poise AI...',
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
                    : AppColors.accentPurple,
                borderRadius: AppRadius.chipRadius,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isStreaming ? Icons.stop_rounded : Icons.arrow_upward_rounded,
                  key: ValueKey(isStreaming),
                  size: 20,
                  color: isStreaming ? AppColors.lossRed : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

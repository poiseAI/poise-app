import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/feedback/p_toast.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prompt = widget.initialPrompt?.trim();
      if (_sentInitialPrompt || prompt == null || prompt.isEmpty) return;
      _sentInitialPrompt = true;
      ref.read(aiChatProvider.notifier).send(prompt);
      _scrollToBottom();
    });
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
      appBar: AppBar(
        leading: messages.isEmpty
            ? null
            : IconButton(
                tooltip: 'Back to chats',
                onPressed: () => ref.invalidate(aiChatProvider),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
        title: const Text('Poise AI'),
        actions: [
          if (messages.isNotEmpty)
            IconButton(
              tooltip: 'About Poise AI',
              onPressed: () => PToast.info(
                context,
                'Poise AI helps you review trade habits and risk decisions.',
              ),
              icon: const Icon(Icons.info_outline_rounded),
            )
          else
            IconButton(
              tooltip: 'About Poise AI',
              onPressed: () => PToast.info(
                context,
                'Poise AI helps you review trade habits and risk decisions.',
              ),
              icon: const Icon(Icons.info_outline_rounded),
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
              child: messages.isEmpty
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
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Start a chat with Poise AI to get insight about your trades and your habits',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: onStartTap,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Start new chat'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        textStyle: AppTypography.button,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 260.ms).slideY(
                    begin: 0.04,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  ),
            ),
          ),
          Text(
            'Popular ways to get started',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            alignment: WrapAlignment.start,
            children: _suggestedPrompts.take(3).toList().asMap().entries.map(
              (e) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onPromptTap(e.value);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      borderRadius: AppRadius.pillRadius,
                      border: Border.all(color: AppColors.brand100),
                    ),
                    child: Text(
                      e.value,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ).animate(delay: (260 + e.key * 40).ms).fadeIn(
                      duration: 220.ms,
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

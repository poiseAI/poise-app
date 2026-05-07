import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/p_primary_button.dart';
import '../../../features/positions/data/models/position.dart';
import '../data/models/tpsl_config.dart';
import '../data/tpsl_api.dart';

class TpSlScreen extends ConsumerStatefulWidget {
  const TpSlScreen({super.key, required this.positionId});
  final String positionId;

  @override
  ConsumerState<TpSlScreen> createState() => _TpSlScreenState();
}

class _TpSlScreenState extends ConsumerState<TpSlScreen> {
  Position? _position;
  bool _loading = true;
  String? _loadError;

  // SL form state
  bool _slEnabled = false;
  final _slPriceCtrl = TextEditingController();

  // TP levels form state (up to 3)
  final _tpControllers = <({
    TextEditingController price,
    TextEditingController closePercent,
  })>[];

  // Save state
  PButtonState _saveState = PButtonState.idle;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _addTpLevel(); // start with one empty TP level
    _init();
  }

  @override
  void dispose() {
    _slPriceCtrl.dispose();
    for (final c in _tpControllers) {
      c.price.dispose();
      c.closePercent.dispose();
    }
    super.dispose();
  }

  void _addTpLevel() {
    if (_tpControllers.length >= 3) return;
    setState(() {
      _tpControllers.add((
        price: TextEditingController(),
        closePercent: TextEditingController(text: '100'),
      ));
    });
  }

  void _removeTpLevel(int index) {
    _tpControllers[index].price.dispose();
    _tpControllers[index].closePercent.dispose();
    setState(() => _tpControllers.removeAt(index));
    _rebalanceClosePercents();
  }

  /// Rebalance close % evenly across remaining levels.
  void _rebalanceClosePercents() {
    if (_tpControllers.isEmpty) return;
    final equal = (100 / _tpControllers.length).toStringAsFixed(0);
    for (final c in _tpControllers) {
      c.closePercent.text = equal;
    }
  }

  Future<void> _init() async {
    final dio = ref.read(dioProvider);
    try {
      // Load position details
      final positionResp = await dio
          .get<Map<String, dynamic>>('/positions/${widget.positionId}');
      if (!mounted) return;
      _position = Position.fromJson(positionResp.data!);

      // Load existing TP/SL config (404 = none yet, that's fine)
      final configResult =
          await ref.read(tpSlApiProvider).get(widget.positionId);
      if (!mounted) return;

      configResult.fold(
        onOk: _applyExistingConfig,
        onErr: (_) {}, // no existing config — keep defaults
      );
    } catch (_) {
      if (mounted) setState(() => _loadError = 'Failed to load position details.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyExistingConfig(TpSlConfig config) {
    // Populate SL
    if (config.slConfig != null && config.slConfig!.price > 0) {
      _slEnabled = true;
      _slPriceCtrl.text = config.slConfig!.price.toStringAsFixed(2);
    }

    // Populate TP levels
    if (config.tpLevels.isNotEmpty) {
      // Dispose default empty controller
      for (final c in _tpControllers) {
        c.price.dispose();
        c.closePercent.dispose();
      }
      _tpControllers.clear();

      for (final level in config.tpLevels) {
        _tpControllers.add((
          price: TextEditingController(
              text: level.targetValue.toStringAsFixed(2)),
          closePercent: TextEditingController(
              text: level.closePercent.toStringAsFixed(0)),
        ));
      }
    }
  }

  Future<void> _save() async {
    setState(() {
      _saveState = PButtonState.loading;
      _saveError = null;
    });

    // Build TP levels
    final tpLevels = <TpLevel>[];
    for (var i = 0; i < _tpControllers.length; i++) {
      final priceText = _tpControllers[i].price.text.trim();
      final closeText = _tpControllers[i].closePercent.text.trim();
      if (priceText.isEmpty) continue;

      final price = double.tryParse(priceText);
      final close = double.tryParse(closeText) ?? 100.0;
      if (price == null || price <= 0) continue;

      tpLevels.add(TpLevel(
        positionId: widget.positionId,
        level: i + 1,
        targetType: 'price',
        targetValue: price,
        closePercent: close.clamp(1.0, 100.0),
      ));
    }

    // Build SL config
    SlConfig? slConfig;
    if (_slEnabled) {
      final priceText = _slPriceCtrl.text.trim();
      final price = double.tryParse(priceText);
      if (price != null && price > 0) {
        slConfig = SlConfig(
          positionId: widget.positionId,
          type: 'price',
          value: price,
          price: price,
        );
      }
    }

    final config = TpSlConfig(tpLevels: tpLevels, slConfig: slConfig);
    final result = await ref.read(tpSlApiProvider).save(widget.positionId, config);

    if (!mounted) return;

    result.fold(
      onOk: (_) {
        setState(() => _saveState = PButtonState.success);
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) context.pop();
        });
      },
      onErr: (err) {
        setState(() {
          _saveState = PButtonState.idle;
          _saveError = err.userMessage;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('TP / SL', style: AppTypography.h4),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : _loadError != null
              ? _ErrorBody(message: _loadError!, onRetry: _init)
              : _Form(
                  position: _position,
                  slEnabled: _slEnabled,
                  slPriceCtrl: _slPriceCtrl,
                  tpControllers: _tpControllers,
                  saveState: _saveState,
                  saveError: _saveError,
                  onSlToggle: (v) => setState(() => _slEnabled = v),
                  onAddTp: _tpControllers.length < 3 ? _addTpLevel : null,
                  onRemoveTp: _removeTpLevel,
                  onSave: _save,
                ),
    );
  }
}

// ── Form body ────────────────────────────────────────────────────────────────

class _Form extends StatelessWidget {
  const _Form({
    required this.position,
    required this.slEnabled,
    required this.slPriceCtrl,
    required this.tpControllers,
    required this.saveState,
    required this.saveError,
    required this.onSlToggle,
    required this.onAddTp,
    required this.onRemoveTp,
    required this.onSave,
  });

  final Position? position;
  final bool slEnabled;
  final TextEditingController slPriceCtrl;
  final List<({TextEditingController price, TextEditingController closePercent})>
      tpControllers;
  final PButtonState saveState;
  final String? saveError;
  final ValueChanged<bool> onSlToggle;
  final VoidCallback? onAddTp;
  final ValueChanged<int> onRemoveTp;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Position summary
          if (position != null) ...[
            _PositionSummary(position: position!),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Stop Loss
          _SectionHeader(
            icon: Icons.trending_down_rounded,
            label: 'Stop Loss',
            color: AppColors.lossRed,
            trailing: Switch.adaptive(
              value: slEnabled,
              activeTrackColor: AppColors.accent,
              onChanged: onSlToggle,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: slEnabled
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: _PriceField(
                controller: slPriceCtrl,
                label: 'SL price (USDT)',
                hint: 'e.g. 43500.00',
              ),
            ),
            secondChild: const SizedBox(height: AppSpacing.xs),
          ),

          const SizedBox(height: AppSpacing.xl),
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: AppSpacing.xl),

          // Take Profit
          const _SectionHeader(
            icon: Icons.trending_up_rounded,
            label: 'Take Profit',
            color: AppColors.profitGreen,
          ),
          const SizedBox(height: AppSpacing.sm),

          ...tpControllers.asMap().entries.map((e) {
            final i = e.key;
            final c = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _TpLevelRow(
                index: i,
                priceCtrl: c.price,
                closeCtrl: c.closePercent,
                onRemove: tpControllers.length > 1 ? () => onRemoveTp(i) : null,
              ),
            )
                .animate(delay: (i * 40).ms)
                .fadeIn(duration: 200.ms)
                .slideY(begin: 0.1, end: 0);
          }),

          if (onAddTp != null)
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onAddTp?.call();
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.borderLight,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_rounded,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('Add level',
                        style: AppTypography.body
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.xl),

          if (saveError != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.lossRed.withValues(alpha: 0.08),
                borderRadius: AppRadius.chipRadius,
                border: Border.all(
                    color: AppColors.lossRed.withValues(alpha: 0.3)),
              ),
              child: Text(
                saveError!,
                style: AppTypography.caption
                    .copyWith(color: AppColors.lossRed),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          PPrimaryButton(
            label: 'Save configuration',
            state: saveState,
            onPressed: onSave,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _PositionSummary extends StatelessWidget {
  const _PositionSummary({required this.position});
  final Position position;

  @override
  Widget build(BuildContext context) {
    final isLong = position.side.toLowerCase() == 'long';
    final sideColor =
        isLong ? AppColors.profitGreen : AppColors.lossRed;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(position.symbol, style: AppTypography.h4),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: sideColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isLong ? 'LONG' : 'SHORT',
                        style: AppTypography.caption
                            .copyWith(color: sideColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Entry: \$${position.entryPrice.toStringAsFixed(2)}',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${position.currentPrice.toStringAsFixed(2)}',
                style: AppTypography.h4,
              ),
              Text('Current',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTypography.h4),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            AppTypography.caption.copyWith(color: AppColors.textSecondary),
        hintText: hint,
        hintStyle:
            AppTypography.body.copyWith(color: AppColors.textDisabled),
        filled: true,
        fillColor: AppColors.bgCard,
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.chipRadius,
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.chipRadius,
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}

class _TpLevelRow extends StatelessWidget {
  const _TpLevelRow({
    required this.index,
    required this.priceCtrl,
    required this.closeCtrl,
    required this.onRemove,
  });

  final int index;
  final TextEditingController priceCtrl;
  final TextEditingController closeCtrl;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _PriceField(
            controller: priceCtrl,
            label: 'TP ${index + 1} price',
            hint: 'e.g. 48000.00',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 2,
          child: TextField(
            controller: closeCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTypography.body,
            decoration: InputDecoration(
              labelText: 'Close %',
              labelStyle:
                  AppTypography.caption.copyWith(color: AppColors.textSecondary),
              suffixText: '%',
              suffixStyle:
                  AppTypography.body.copyWith(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.bgCard,
              enabledBorder: const OutlineInputBorder(
                borderRadius: AppRadius.chipRadius,
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: AppRadius.chipRadius,
                borderSide:
                    BorderSide(color: AppColors.accent, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
        ),
        if (onRemove != null) ...[
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              onRemove?.call();
            },
            icon: const Icon(Icons.remove_circle_outline_rounded,
                color: AppColors.lossRed, size: 20),
          ),
        ] else
          const SizedBox(width: 40),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.textDisabled),
            const SizedBox(height: AppSpacing.md),
            Text(message,
                style: AppTypography.body
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

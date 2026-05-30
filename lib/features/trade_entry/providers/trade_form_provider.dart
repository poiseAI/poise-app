import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../orders/data/models/order.dart';
import '../../risk/data/models/risk_score.dart';
import '../../risk/data/risk_api.dart';
import '../data/models/symbol.dart';
import '../data/signal_parser.dart';
import '../data/symbols_api.dart';
import '../data/trade_api.dart';

part 'trade_form_provider.freezed.dart';
part 'trade_form_provider.g.dart';

enum OrderType { market, limit, stop }

enum OrderSide { long, short }

enum MarginMode { percentage, fixed }

enum AmountInputMode { margin, quantity }

enum CollateralMode { isolated, cross }

final selectedTradeExchangeProvider = StateProvider<String>((ref) => 'bybit');

@freezed
abstract class TradeFormState with _$TradeFormState {
  const factory TradeFormState({
    TradingSymbol? symbol,
    @Default(OrderType.market) OrderType orderType,
    @Default(OrderSide.long) OrderSide side,
    @Default(CollateralMode.isolated) CollateralMode collateralMode,
    @Default(AmountInputMode.margin) AmountInputMode amountInputMode,
    @Default(1.0) double quantity,
    double? limitPrice,
    @Default(MarginMode.fixed) MarginMode marginMode,
    @Default(0.0) double marginValue,
    @Default(0.0) double availableBalance,
    @Default('USD') String balanceCurrency,
    @Default(5.0) double leverage,
    double? takeProfit1,
    double? takeProfit2,
    double? takeProfit3,
    double? slPrice,
    @Default(false) bool autoStopLossProgression,
    RiskScore? riskScore,
    TradePreflight? preflight,
    TradeValidationResult? validation,
    @Default(false) bool isLoadingPreflight,
    @Default(false) bool isValidating,
    @Default(false) bool isSubmitting,
    String? preflightError,
    String? validationError,
    String? submitError,
    Order? lastOrder,
    @Default(false) bool symbolTouched,
    @Default(false) bool orderTypeTouched,
    @Default(false) bool amountTouched,
    @Default(false) bool collateralModeTouched,
    @Default(false) bool leverageTouched,
    @Default(false) bool directionTouched,
    @Default(false) bool exitPlanTouched,
    @Default('') String signalText,
    TradeSignalParse? parsedSignal,
    @Default(false) bool isApplyingSignal,
    String? signalError,
  }) = _TradeFormState;
}

@riverpod
class TradeForm extends _$TradeForm {
  @override
  TradeFormState build() {
    final exchange = ref.watch(selectedTradeExchangeProvider);
    Future.microtask(() => loadPreflight(exchange: exchange));
    return const TradeFormState();
  }

  Future<void> loadPreflight({String? exchange}) async {
    final requestedExchange = _normalizeExchange(
      exchange ?? ref.read(selectedTradeExchangeProvider),
    );
    state = state.copyWith(isLoadingPreflight: true, preflightError: null);
    final api = ref.read(tradeApiProvider);
    final preflightResult = await api.preflight(exchange: requestedExchange);
    if (preflightResult.isErr) {
      state = state.copyWith(
        isLoadingPreflight: false,
        preflightError: preflightResult.error.userMessage,
      );
      return;
    }

    final preflight = preflightResult.value;
    final needsExchangeConnection = _requiresExchangeConnection(preflight);
    final balance = needsExchangeConnection
        ? const ExchangeBalance(available: 0, currency: 'USD')
        : (await api.balance(preflight.exchange)).valueOrNull ??
            const ExchangeBalance(available: 0, currency: 'USD');
    state = state.copyWith(
      isLoadingPreflight: false,
      preflight: preflight,
      availableBalance: balance.available,
      balanceCurrency: balance.currency,
      leverage: state.leverage.clamp(
        1.0,
        _maxAllowedLeverage(state.symbol, preflight),
      ),
      marginMode: needsExchangeConnection ? MarginMode.fixed : state.marginMode,
    );
  }

  void setSymbol(TradingSymbol symbol) {
    state = state.copyWith(
      symbol: symbol,
      riskScore: null,
      leverage: state.leverage.clamp(
        1.0,
        _maxAllowedLeverage(symbol, state.preflight),
      ),
      symbolTouched: true,
      validation: null,
      validationError: null,
    );
    _fetchRisk(symbol.symbol);
  }

  void setOrderType(OrderType type) {
    state = state.copyWith(
      orderType: type,
      limitPrice: type == OrderType.market
          ? null
          : state.limitPrice ?? state.symbol?.lastPrice,
      orderTypeTouched: true,
      validation: null,
    );
  }

  void setSide(OrderSide side) {
    state = state.copyWith(
      side: side,
      directionTouched: true,
      exitPlanTouched: false,
      validation: null,
    );
  }

  void setQuantity(double qty) => state =
      state.copyWith(quantity: qty, amountTouched: true, validation: null);

  void setLimitPrice(double? price) => state = state.copyWith(
        limitPrice: price,
        orderTypeTouched: true,
        validation: null,
      );

  void setMarginMode(MarginMode mode) => state = state.copyWith(
        marginMode: mode,
        amountInputMode: AmountInputMode.margin,
        amountTouched: true,
        validation: null,
      );

  void setAmountInputMode(AmountInputMode mode) => state = state.copyWith(
        amountInputMode: mode,
        amountTouched: true,
        validation: null,
      );

  void setCollateralMode(CollateralMode mode) => state = state.copyWith(
        collateralMode: mode,
        collateralModeTouched: true,
        validation: null,
      );

  void setMarginValue(double value) {
    final clamped = state.marginMode == MarginMode.percentage
        ? value.clamp(1.0, 100.0).toDouble()
        : state.availableBalance > 0
            ? value.clamp(0.0, state.availableBalance).toDouble()
            : value.clamp(0.0, double.infinity).toDouble();
    state = state.copyWith(
      marginValue: clamped,
      amountTouched: true,
      validation: null,
    );
  }

  void setLeverage(double lev) {
    state = state.copyWith(
      leverage:
          lev.clamp(1.0, _maxAllowedLeverage(state.symbol, state.preflight)),
      leverageTouched: true,
      validation: null,
    );
  }

  void setTakeProfit1(double? price) => state = state.copyWith(
        takeProfit1: price,
        exitPlanTouched: true,
        validation: null,
      );

  void setTakeProfit2(double? price) => state = state.copyWith(
        takeProfit2: price ?? (state.takeProfit2 == null ? null : 0),
        exitPlanTouched: true,
        validation: null,
      );

  void setTakeProfit3(double? price) => state = state.copyWith(
        takeProfit3: price ?? (state.takeProfit3 == null ? null : 0),
        exitPlanTouched: true,
        validation: null,
      );

  void setSlPrice(double? price) => state = state.copyWith(
        slPrice: price,
        exitPlanTouched: true,
        validation: null,
      );

  void setAutoStopLossProgression(bool value) => state = state.copyWith(
        autoStopLossProgression: value,
        exitPlanTouched: true,
      );

  void clearLastOrder() =>
      state = state.copyWith(lastOrder: null, submitError: null);

  void resetDraft() {
    final preflight = state.preflight;
    state = TradeFormState(
      preflight: preflight,
      availableBalance: state.availableBalance,
      balanceCurrency: state.balanceCurrency,
      leverage: preflight == null
          ? _defaultLeverage
          : _defaultLeverage.clamp(
              1.0,
              _maxAllowedLeverage(state.symbol, preflight),
            ),
    );
    if (preflight == null) {
      Future.microtask(loadPreflight);
    }
  }

  void setSignalText(String value) {
    final parsed = parseTradeSignal(value);
    state = state.copyWith(
      signalText: value,
      parsedSignal: parsed.hasContent ? parsed : null,
      signalError: null,
    );
  }

  void parseSignal() {
    final parsed = parseTradeSignal(state.signalText);
    state = state.copyWith(
      parsedSignal: parsed.hasContent ? parsed : null,
      signalError: parsed.hasContent
          ? null
          : 'Paste a signal with a trading pair, direction, entry, stop loss or target.',
    );
  }

  void clearSignal() {
    state = state.copyWith(
      signalText: '',
      parsedSignal: null,
      signalError: null,
    );
  }

  void setSignalError(String? message) {
    state = state.copyWith(signalError: message);
  }

  Future<void> applyParsedSignal() async {
    final parsed = state.parsedSignal ?? parseTradeSignal(state.signalText);
    if (!parsed.hasContent || state.isApplyingSignal) return;

    state = state.copyWith(isApplyingSignal: true, signalError: null);

    final resolvedSymbol = await _resolveSignalSymbol(parsed);
    final signalSide = switch (parsed.side) {
      'short' => OrderSide.short,
      'long' => OrderSide.long,
      _ => state.side,
    };
    final signalCollateral = switch (parsed.collateralMode) {
      'cross' => CollateralMode.cross,
      'isolated' => CollateralMode.isolated,
      _ => state.collateralMode,
    };
    final firstTp = parsed.takeProfits.isNotEmpty
        ? parsed.takeProfits.first
        : state.takeProfit1;
    final secondTp = parsed.takeProfits.length > 1
        ? parsed.takeProfits[1]
        : state.takeProfit2;
    final thirdTp = parsed.takeProfits.length > 2
        ? parsed.takeProfits[2]
        : state.takeProfit3;
    final maxLev =
        _maxAllowedLeverage(resolvedSymbol ?? state.symbol, state.preflight);
    final nextLeverage = parsed.leverage == null
        ? state.leverage
        : parsed.leverage!.clamp(1.0, maxLev).toDouble();
    final hasMargin = parsed.marginAmount != null && parsed.marginAmount! > 0;
    final symbolError = parsed.symbol != null && resolvedSymbol == null
        ? 'I found ${parsed.symbol}, but could not resolve live market data. Select the trading pair manually before reviewing.'
        : null;

    state = state.copyWith(
      symbol: resolvedSymbol ?? state.symbol,
      side: signalSide,
      collateralMode: signalCollateral,
      orderType: parsed.entryPrice == null ? state.orderType : OrderType.limit,
      limitPrice: parsed.entryPrice ?? state.limitPrice,
      leverage: nextLeverage,
      slPrice: parsed.stopLoss ?? state.slPrice,
      takeProfit1: firstTp,
      takeProfit2: secondTp,
      takeProfit3: thirdTp,
      marginMode: hasMargin ? MarginMode.fixed : state.marginMode,
      amountInputMode:
          hasMargin ? AmountInputMode.margin : state.amountInputMode,
      marginValue: hasMargin ? parsed.marginAmount! : state.marginValue,
      symbolTouched: resolvedSymbol != null || state.symbolTouched,
      orderTypeTouched: parsed.entryPrice != null || state.orderTypeTouched,
      amountTouched: true,
      collateralModeTouched:
          parsed.collateralMode != null || state.collateralModeTouched,
      leverageTouched: parsed.leverage != null || state.leverageTouched,
      directionTouched: parsed.side != null || state.directionTouched,
      exitPlanTouched: parsed.stopLoss != null ||
          parsed.takeProfits.isNotEmpty ||
          state.exitPlanTouched,
      parsedSignal: parsed,
      isApplyingSignal: false,
      signalError: symbolError,
      validation: null,
      validationError: null,
    );

    final symbol = resolvedSymbol;
    if (symbol != null) {
      unawaited(_fetchRisk(symbol.symbol));
    }
  }

  Future<void> _fetchRisk(String symbol) async {
    final result = await ref.read(riskApiProvider).getTokenRisk(symbol);
    result.fold(
      onOk: (score) => state = state.copyWith(riskScore: score),
      onErr: (_) {},
    );
  }

  Future<void> refreshSelectedPrice() async {
    final current = state.symbol;
    if (current == null) return;
    final result = await ref.read(symbolsApiProvider).search(
          current.symbol,
          limit: 6,
          exchange: current.exchange,
          quote: current.quoteAsset,
        );
    if (result.isErr) return;
    final matches = result.value
        .where((item) => item.symbol == current.symbol)
        .toList(growable: false);
    if (matches.isEmpty) return;
    final fresh = matches.first;
    state = state.copyWith(symbol: fresh);
  }

  bool get isValid {
    final pf = state.preflight;
    if (pf == null) return false;
    if (state.symbol == null) return false;
    if (!state.collateralModeTouched) return false;
    if (!state.leverageTouched) return false;
    if (!state.orderTypeTouched) return false;
    if (!state.directionTouched) return false;
    if (marginAmount <= 0) return false;
    if (state.orderType != OrderType.market && state.limitPrice == null) {
      return false;
    }
    if (entryPrice <= 0) return false;
    if (state.slPrice == null || state.slPrice! <= 0) return false;
    return localValidationError == null;
  }

  double get marginAmount {
    if (state.amountInputMode == AmountInputMode.quantity) {
      final price = entryPrice;
      if (price <= 0 || state.leverage <= 0) return 0;
      return (state.quantity * price) / state.leverage;
    }
    if (state.marginMode == MarginMode.fixed) return state.marginValue;
    return state.availableBalance * (state.marginValue / 100);
  }

  double get entryPrice {
    if (state.orderType == OrderType.market) {
      return state.symbol?.lastPrice ?? 0;
    }
    return state.limitPrice ?? 0;
  }

  double get quantity {
    if (state.amountInputMode == AmountInputMode.quantity) {
      return state.quantity;
    }
    final price = entryPrice;
    final raw =
        price > 0 ? (marginAmount * state.leverage) / price : state.quantity;
    final step = state.symbol?.qtyStep ?? 0;
    return step > 0 ? (raw / step).floor() * step : raw;
  }

  String? get localValidationError {
    final sym = state.symbol;
    if (state.preflight == null) {
      return 'Checking exchange connection and live prices...';
    }
    final pf = state.preflight;
    if (sym == null) return 'Choose a trading pair to continue.';
    if (!state.collateralModeTouched) {
      return 'Select a margin type to continue.';
    }
    if (!state.leverageTouched) return 'Choose leverage to continue.';
    if (!state.orderTypeTouched) return 'Choose an entry type to continue.';
    if (!state.amountTouched) return 'Enter trade size to continue.';
    if (!state.directionTouched) return 'Select a direction to continue.';
    if (!state.exitPlanTouched) {
      return 'Confirm a take profit and stop loss to continue.';
    }
    if (state.availableBalance <= 0 &&
        !requiresExchangeForExecution &&
        state.marginMode == MarginMode.percentage) {
      return 'Available balance is unavailable for ${pf?.exchange ?? sym.exchange}.';
    }
    if (state.availableBalance <= 0 &&
        requiresExchangeForExecution &&
        state.marginMode == MarginMode.percentage) {
      return 'Use a margin amount or exact quantity until your exchange balance is connected.';
    }
    if (marginAmount <= 0) return 'Enter a positive margin amount.';
    if (state.availableBalance > 0 && marginAmount > state.availableBalance) {
      return 'Margin cannot exceed your available balance.';
    }
    if (entryPrice <= 0) return 'Entry price is unavailable for ${sym.symbol}.';
    final qty = quantity;
    if (sym.minQty > 0 && qty < sym.minQty) {
      return 'Quantity must be at least ${sym.minQty.toStringAsFixed(6)} ${sym.baseAsset}. Increase margin or leverage.';
    }
    final notional = qty * entryPrice;
    if (sym.minNotional > 0 && notional < sym.minNotional) {
      return 'Position notional must be at least ${sym.minNotional.toStringAsFixed(2)} ${state.balanceCurrency}.';
    }
    final sl = state.slPrice;
    if (sl == null || sl <= 0) return 'Stop loss is required.';
    final tp1 = state.takeProfit1;
    final tp2 = _positiveOrNull(state.takeProfit2);
    final tp3 = _positiveOrNull(state.takeProfit3);
    if (state.side == OrderSide.long) {
      if (sl >= entryPrice) {
        return 'For a long trade, stop loss must be below entry.';
      }
      if (tp1 != null && tp1 <= entryPrice) {
        return 'For a long trade, take profit must be above entry.';
      }
      if (tp2 != null && tp2 <= entryPrice) {
        return 'For a long trade, take profit 2 must be above entry.';
      }
      if (tp3 != null && tp3 <= entryPrice) {
        return 'For a long trade, take profit 3 must be above entry.';
      }
    } else {
      if (sl <= entryPrice) {
        return 'For a short trade, stop loss must be above entry.';
      }
      if (tp1 != null && tp1 >= entryPrice) {
        return 'For a short trade, take profit must be below entry.';
      }
      if (tp2 != null && tp2 >= entryPrice) {
        return 'For a short trade, take profit 2 must be below entry.';
      }
      if (tp3 != null && tp3 >= entryPrice) {
        return 'For a short trade, take profit 3 must be below entry.';
      }
    }
    return null;
  }

  bool get requiresExchangeForExecution {
    return _requiresExchangeConnection(state.preflight);
  }

  Map<String, dynamic> get draftJson {
    final sym = state.symbol;
    return {
      'exchange': sym?.exchange ?? state.preflight?.exchange ?? 'bybit',
      'symbol': sym?.symbol,
      'side': state.side.name,
      'collateral_mode': state.collateralMode.name,
      'execution_mode': state.orderType == OrderType.limit ? 'limit' : 'market',
      'entry_price': entryPrice,
      'limit_price':
          state.orderType == OrderType.limit ? state.limitPrice : null,
      'margin_mode': state.marginMode.name,
      'amount_input_mode': state.amountInputMode.name,
      'margin_value': state.marginValue,
      'margin_amount': marginAmount,
      'available_balance': state.availableBalance,
      'leverage': state.leverage,
      'quantity': quantity,
      'stop_loss': state.slPrice,
      'take_profit_1': state.takeProfit1,
      'take_profit_2': _positiveOrNull(state.takeProfit2),
      'take_profit_3': _positiveOrNull(state.takeProfit3),
      'auto_stop_loss_progression': state.autoStopLossProgression,
    };
  }

  Future<bool> validateTrade() async {
    if (!isValid || state.isValidating) return false;
    state = state.copyWith(isValidating: true, validationError: null);
    if (requiresExchangeForExecution) {
      state = state.copyWith(
        isValidating: false,
        validation: _localSetupValidation(),
      );
      return true;
    }
    final result = await ref.read(tradeApiProvider).validate(draftJson);
    return result.fold(
      onOk: (validation) {
        state = state.copyWith(isValidating: false, validation: validation);
        return true;
      },
      onErr: (err) {
        state = state.copyWith(
          isValidating: false,
          validationError: err.userMessage,
        );
        return false;
      },
    );
  }

  Future<void> submit({bool bypassWarnings = false}) async {
    if (!isValid || state.isSubmitting) return;
    final validation = state.validation;
    if (validation == null || validation.isBlocked) return;
    if (requiresExchangeForExecution) {
      state = state.copyWith(
        submitError: 'Connect an active exchange API key before executing.',
      );
      return;
    }
    final requiresAcknowledgement = validation.hasWarnings ||
        validation.dailyLimitAcknowledgementRequired ||
        validation.requiresExternalRiskReview;
    if (requiresAcknowledgement && !bypassWarnings) return;
    state = state.copyWith(isSubmitting: true, submitError: null);

    final clientOrderId =
        'poise-${DateTime.now().microsecondsSinceEpoch}-${state.symbol?.symbol ?? 'order'}';
    final result = await ref.read(tradeApiProvider).submit(
          draft: draftJson,
          submitToken: validation.submitToken,
          proceedAfterWarnings: bypassWarnings,
          clientOrderId: clientOrderId,
        );
    result.fold(
      onOk: (order) => state = state.copyWith(
        isSubmitting: false,
        lastOrder: order,
        validation: null,
      ),
      onErr: (err) => state = state.copyWith(
        isSubmitting: false,
        submitError: err.userMessage,
      ),
    );
  }

  TradeValidationResult _localSetupValidation() {
    final margin = marginAmount;
    final entry = entryPrice;
    final tps = [
      state.takeProfit1,
      _positiveOrNull(state.takeProfit2),
      _positiveOrNull(state.takeProfit3),
    ].whereType<double>();
    final sl = state.slPrice;
    final possibleLoss =
        sl == null ? 0.0 : _pnlAt(price: sl, entry: entry).abs();
    final possibleProfit = tps.fold<double>(
      0,
      (total, tp) => total + _pnlAt(price: tp, entry: entry).abs(),
    );
    final rr = possibleLoss > 0
        ? '1 : ${(possibleProfit / possibleLoss).toStringAsFixed(2)}'
        : '-';
    final pf = state.preflight;

    return TradeValidationResult(
      submitToken: '',
      riskPct: margin > 0 ? (possibleLoss / margin) * 100 : 0,
      margin: margin,
      positionSize: quantity * entry,
      riskRewardRatio: rr,
      possibleLoss: possibleLoss,
      possibleProfit: possibleProfit,
      dailyBaselineBalanceUsd: pf?.dailyBaselineBalanceUsd ?? 0,
      dailyAvailableBalanceUsd: pf?.dailyAvailableBalanceUsd ?? 0,
      dailyLossLimitType: pf?.dailyLossLimitType ?? 'fixed_usd',
      dailyLossLimitUsd: pf?.dailyLossLimitUsd ?? 0,
      realizedDailyLossUsd: 0,
      openPositionReservedLossUsd: 0,
      externalUnrealizedLossUsd: 0,
      currentDailyRiskUsedUsd: 0,
      projectedDailyLossUsd: possibleLoss,
      remainingDailyLossBudgetUsd: 0,
      balanceSnapshotComplete: pf?.balanceSnapshotComplete ?? false,
      balanceSnapshotExpectedConnections:
          pf?.balanceSnapshotExpectedConnections ?? 0,
      balanceSnapshotCapturedConnections:
          pf?.balanceSnapshotCapturedConnections ?? 0,
      externalOpenPositions: pf?.externalOpenPositions ?? 0,
      unknownRiskPositions: pf?.unknownRiskPositions ?? 0,
      requiresExternalRiskReview: false,
      dailyLimitAcknowledgementRequired: false,
      blockingGuardrails: const [
        GuardrailResult(
          title: 'Exchange connection required',
          message: 'Connect an exchange before execution.',
          severity: 'blocked',
        ),
      ],
      warningGuardrails: const [],
    );
  }

  double _pnlAt({required double price, required double entry}) {
    if (entry <= 0 || marginAmount <= 0) return 0;
    final move = state.side == OrderSide.long
        ? (price - entry) / entry
        : (entry - price) / entry;
    return marginAmount * move * state.leverage;
  }

  Future<TradingSymbol?> _resolveSignalSymbol(TradeSignalParse parsed) async {
    final symbol = parsed.symbol;
    if (symbol == null) return null;
    final exchange =
        state.preflight?.exchange ?? state.symbol?.exchange ?? 'bybit';
    final result = await ref.read(symbolsApiProvider).search(
          parsed.baseAsset ?? symbol,
          limit: 10,
          exchange: exchange,
          quote: parsed.quoteAsset ?? 'USDT',
        );
    if (result.isOk) {
      final symbols = result.value;
      final exact = symbols.where((item) => item.symbol == symbol).toList();
      if (exact.isNotEmpty) return exact.first;
      if (symbols.isNotEmpty) return symbols.first;
    }

    final entry = parsed.entryPrice;
    if (entry == null ||
        parsed.baseAsset == null ||
        parsed.quoteAsset == null) {
      return null;
    }

    return TradingSymbol(
      symbol: symbol,
      baseAsset: parsed.baseAsset!,
      quoteAsset: parsed.quoteAsset!,
      exchange: exchange,
      status: 'Signal',
      lastPrice: entry,
      maxLeverage: 100,
    );
  }
}

String _normalizeExchange(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized == 'binance') return 'binance';
  return 'bybit';
}

const double _defaultLeverage = 5.0;

double _maxSymbolLeverage(TradingSymbol? symbol) =>
    (symbol?.maxLeverage ?? 100).toDouble();

double _maxAllowedLeverage(TradingSymbol? symbol, TradePreflight? preflight) {
  final symbolMax = _maxSymbolLeverage(symbol);
  final ruleMax = preflight?.maxLeverage;
  if (ruleMax == null || ruleMax <= 0) return symbolMax;
  return symbolMax < ruleMax ? symbolMax : ruleMax;
}

double? _positiveOrNull(double? value) {
  if (value == null || value <= 0) return null;
  return value;
}

bool _requiresExchangeConnection(TradePreflight? preflight) {
  if (preflight == null || preflight.allowed) return false;
  final reason = (preflight.blockingReason ?? '').toLowerCase();
  return reason.contains('exchange') ||
      reason.contains('api key') ||
      reason.contains('connection');
}

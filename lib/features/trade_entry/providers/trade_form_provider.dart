import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../orders/data/models/order.dart';
import '../../risk/data/models/risk_score.dart';
import '../../risk/data/risk_api.dart';
import '../data/models/symbol.dart';
import '../data/trade_api.dart';

part 'trade_form_provider.freezed.dart';
part 'trade_form_provider.g.dart';

enum OrderType { market, limit, stop }

enum OrderSide { long, short }

enum MarginMode { percentage, fixed }

@freezed
abstract class TradeFormState with _$TradeFormState {
  const factory TradeFormState({
    TradingSymbol? symbol,
    @Default(OrderType.market) OrderType orderType,
    @Default(OrderSide.long) OrderSide side,
    @Default(1.0) double quantity,
    double? limitPrice,
    @Default(MarginMode.percentage) MarginMode marginMode,
    @Default(20.0) double marginValue,
    @Default(0.0) double availableBalance,
    @Default('USD') String balanceCurrency,
    @Default(1.0) double leverage,
    double? takeProfit1,
    double? takeProfit2,
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
  }) = _TradeFormState;
}

@riverpod
class TradeForm extends _$TradeForm {
  @override
  TradeFormState build() {
    Future.microtask(loadPreflight);
    return const TradeFormState();
  }

  Future<void> loadPreflight() async {
    state = state.copyWith(isLoadingPreflight: true, preflightError: null);
    final api = ref.read(tradeApiProvider);
    final preflightResult = await api.preflight();
    if (preflightResult.isErr) {
      state = state.copyWith(
        isLoadingPreflight: false,
        preflightError: preflightResult.error.userMessage,
      );
      return;
    }

    final preflight = preflightResult.value;
    final balanceResult = await api.balance(preflight.exchange);
    final balance = balanceResult.valueOrNull ??
        ExchangeBalance(available: state.availableBalance, currency: 'USD');
    state = state.copyWith(
      isLoadingPreflight: false,
      preflight: preflight,
      availableBalance: balance.available,
      balanceCurrency: balance.currency,
      leverage: state.leverage.clamp(1.0, preflight.maxLeverage),
    );
  }

  void setSymbol(TradingSymbol symbol) {
    final maxRule =
        state.preflight?.maxLeverage ?? symbol.maxLeverage.toDouble();
    final entry = _entryFor(symbol);
    final defaults = _defaultTpSl(entry, state.side);
    state = state.copyWith(
      symbol: symbol,
      riskScore: null,
      leverage: state.leverage
          .clamp(1.0, _min(maxRule, symbol.maxLeverage.toDouble())),
      slPrice: state.slPrice ?? defaults.stopLoss,
      takeProfit1: state.takeProfit1 ?? defaults.takeProfit,
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
      validation: null,
    );
  }

  void setSide(OrderSide side) {
    final entry = entryPrice > 0 ? entryPrice : _entryFor(state.symbol);
    final defaults = _defaultTpSl(entry, side);
    state = state.copyWith(
      side: side,
      slPrice: defaults.stopLoss,
      takeProfit1: defaults.takeProfit,
      takeProfit2: null,
      validation: null,
    );
  }

  void setQuantity(double qty) =>
      state = state.copyWith(quantity: qty, validation: null);

  void setLimitPrice(double? price) =>
      state = state.copyWith(limitPrice: price, validation: null);

  void setMarginMode(MarginMode mode) =>
      state = state.copyWith(marginMode: mode, validation: null);

  void setMarginValue(double value) {
    final clamped = state.marginMode == MarginMode.percentage
        ? value.clamp(1.0, 100.0).toDouble()
        : value.clamp(0.0, state.availableBalance).toDouble();
    state = state.copyWith(marginValue: clamped, validation: null);
  }

  void setLeverage(double lev) {
    final maxRule = state.preflight?.maxLeverage ?? double.infinity;
    final maxSymbol = (state.symbol?.maxLeverage ?? maxRule).toDouble();
    state = state.copyWith(
      leverage: lev.clamp(1.0, _min(maxRule, maxSymbol)),
      validation: null,
    );
  }

  void setTakeProfit1(double? price) =>
      state = state.copyWith(takeProfit1: price, validation: null);

  void setTakeProfit2(double? price) =>
      state = state.copyWith(takeProfit2: price, validation: null);

  void setSlPrice(double? price) =>
      state = state.copyWith(slPrice: price, validation: null);

  void setAutoStopLossProgression(bool value) =>
      state = state.copyWith(autoStopLossProgression: value);

  void clearLastOrder() =>
      state = state.copyWith(lastOrder: null, submitError: null);

  Future<void> _fetchRisk(String symbol) async {
    final result = await ref.read(riskApiProvider).getTokenRisk(symbol);
    result.fold(
      onOk: (score) => state = state.copyWith(riskScore: score),
      onErr: (_) {},
    );
  }

  bool get isValid {
    final pf = state.preflight;
    if (pf == null) return false;
    if (!pf.allowed) return false;
    if (state.symbol == null) return false;
    if (marginAmount <= 0) return false;
    if (state.availableBalance <= 0) return false;
    if (marginAmount > state.availableBalance) return false;
    if (state.orderType != OrderType.market && state.limitPrice == null) {
      return false;
    }
    if (entryPrice <= 0) return false;
    if (state.slPrice == null || state.slPrice! <= 0) return false;
    return localValidationError == null;
  }

  double get marginAmount {
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
    final price = entryPrice;
    final raw =
        price > 0 ? (marginAmount * state.leverage) / price : state.quantity;
    final step = state.symbol?.qtyStep ?? 0;
    return step > 0 ? (raw / step).floor() * step : raw;
  }

  String? get localValidationError {
    final sym = state.symbol;
    if (state.preflight == null) {
      return 'Checking exchange connection and guardrails...';
    }
    final pf = state.preflight;
    if (pf != null && !pf.allowed) {
      return pf.blockingReason ??
          'Connect an active exchange API key before opening a trade.';
    }
    if (sym == null) return 'Select a symbol to continue.';
    if (state.availableBalance <= 0) {
      return 'Available balance is unavailable for ${pf?.exchange ?? sym.exchange}.';
    }
    if (marginAmount <= 0) return 'Enter a positive margin amount.';
    if (marginAmount > state.availableBalance) {
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
    final tp2 = state.takeProfit2;
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
    }
    return null;
  }

  Map<String, dynamic> get draftJson {
    final sym = state.symbol;
    return {
      'exchange': sym?.exchange ?? state.preflight?.exchange ?? 'bybit',
      'symbol': sym?.symbol,
      'side': state.side.name,
      'execution_mode': state.orderType == OrderType.limit ? 'limit' : 'market',
      'entry_price': entryPrice,
      'limit_price':
          state.orderType == OrderType.limit ? state.limitPrice : null,
      'margin_mode': state.marginMode.name,
      'margin_value': state.marginValue,
      'margin_amount': marginAmount,
      'available_balance': state.availableBalance,
      'leverage': state.leverage,
      'quantity': quantity,
      'stop_loss': state.slPrice,
      'take_profit_1': state.takeProfit1,
      'take_profit_2': state.takeProfit2,
      'auto_stop_loss_progression': state.autoStopLossProgression,
    };
  }

  Future<bool> validateTrade() async {
    if (!isValid || state.isValidating) return false;
    state = state.copyWith(isValidating: true, validationError: null);
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
}

double _min(double a, double b) => a < b ? a : b;

double _entryFor(TradingSymbol? symbol) => symbol?.lastPrice ?? 0;

({double? stopLoss, double? takeProfit}) _defaultTpSl(
  double entry,
  OrderSide side,
) {
  if (entry <= 0) return (stopLoss: null, takeProfit: null);
  final stopLoss = side == OrderSide.long ? entry * 0.98 : entry * 1.02;
  final takeProfit = side == OrderSide.long ? entry * 1.04 : entry * 0.96;
  return (
    stopLoss: _roundPrice(stopLoss),
    takeProfit: _roundPrice(takeProfit),
  );
}

double _roundPrice(double value) {
  if (value >= 100) return double.parse(value.toStringAsFixed(2));
  if (value >= 1) return double.parse(value.toStringAsFixed(4));
  return double.parse(value.toStringAsFixed(6));
}

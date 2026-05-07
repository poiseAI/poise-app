import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../orders/data/models/order.dart';
import '../../orders/data/orders_api.dart';
import '../../risk/data/models/risk_score.dart';
import '../../risk/data/risk_api.dart';
import '../data/models/symbol.dart';

part 'trade_form_provider.freezed.dart';
part 'trade_form_provider.g.dart';

enum OrderType { market, limit, stop }

enum OrderSide { buy, sell }

@freezed
abstract class TradeFormState with _$TradeFormState {
  const factory TradeFormState({
    TradingSymbol? symbol,
    @Default(OrderType.market) OrderType orderType,
    @Default(OrderSide.buy) OrderSide side,
    @Default(1.0) double quantity,
    double? limitPrice,
    @Default(10.0) double leverage,
    @Default([]) List<double> tpLevels,
    double? slPrice,
    RiskScore? riskScore,
    @Default(false) bool isSubmitting,
    String? submitError,
    Order? lastOrder,
  }) = _TradeFormState;
}

@riverpod
class TradeForm extends _$TradeForm {
  @override
  TradeFormState build() => const TradeFormState();

  void setSymbol(TradingSymbol symbol) {
    state = state.copyWith(symbol: symbol, riskScore: null);
    _fetchRisk(symbol.symbol);
  }

  void setOrderType(OrderType type) => state = state.copyWith(orderType: type);

  void setSide(OrderSide side) => state = state.copyWith(side: side);

  void setQuantity(double qty) => state = state.copyWith(quantity: qty);

  void setLimitPrice(double? price) =>
      state = state.copyWith(limitPrice: price);

  void setLeverage(double lev) => state = state.copyWith(leverage: lev);

  void addTpLevel(double price) {
    final levels = [...state.tpLevels, price]..sort();
    state = state.copyWith(tpLevels: levels);
  }

  void removeTpLevel(int index) {
    final levels = [...state.tpLevels]..removeAt(index);
    state = state.copyWith(tpLevels: levels);
  }

  void setSlPrice(double? price) => state = state.copyWith(slPrice: price);

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
    if (state.symbol == null) return false;
    if (state.quantity <= 0) return false;
    if (state.orderType != OrderType.market && state.limitPrice == null) {
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    if (!isValid || state.isSubmitting) return;
    final sym = state.symbol!;

    state = state.copyWith(isSubmitting: true, submitError: null);

    final req = PlaceOrderRequest(
      exchange: sym.exchange,
      symbol: sym.symbol,
      side: state.side.name,
      orderType: state.orderType.name.replaceAll('_', '-'),
      quantity: state.quantity,
      price: state.orderType == OrderType.limit ? state.limitPrice : null,
      stopPrice: state.orderType == OrderType.stop ? state.limitPrice : null,
      leverage: state.leverage,
      tpLevels: state.tpLevels,
      slPrice: state.slPrice,
      immediateTp: state.tpLevels.isNotEmpty ? state.tpLevels.first : null,
      immediateSl: state.slPrice,
    );

    final result = await ref.read(ordersApiProvider).placeOrder(req);
    result.fold(
      onOk: (order) => state = state.copyWith(
        isSubmitting: false,
        lastOrder: order,
      ),
      onErr: (err) => state = state.copyWith(
        isSubmitting: false,
        submitError: err.userMessage,
      ),
    );
  }
}

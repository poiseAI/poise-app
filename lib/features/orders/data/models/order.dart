import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String symbol,
    required String side,
    required String status,
    @JsonKey(name: 'order_type') required String orderType,
    required double quantity,
    double? price,
    @Default(1.0) double leverage,
    @JsonKey(name: 'tp_levels') @Default([]) List<double> tpLevels,
    @JsonKey(name: 'sl_price', readValue: _readSlPrice) double? slPrice,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

Object? _readSlPrice(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['stop_loss'];

@freezed
abstract class PlaceOrderRequest with _$PlaceOrderRequest {
  const factory PlaceOrderRequest({
    @Default('bybit') String exchange,
    required String symbol,
    required String side,
    @JsonKey(name: 'order_type') required String orderType,
    required double quantity,
    double? price,
    @JsonKey(name: 'stop_price') double? stopPrice,
    required double leverage,
    @JsonKey(name: 'tp_levels') @Default([]) List<double> tpLevels,
    @JsonKey(name: 'sl_price') double? slPrice,
    @JsonKey(name: 'immediate_tp') double? immediateTp,
    @JsonKey(name: 'immediate_sl') double? immediateSl,
  }) = _PlaceOrderRequest;

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderRequestFromJson(json);
}

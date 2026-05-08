import 'package:freezed_annotation/freezed_annotation.dart';

part 'ws_message.freezed.dart';
part 'ws_message.g.dart';

/// All possible messages from the backend WebSocket.
/// Backend sends JSON: { "type": "...", "data": { ... } }
@freezed
sealed class WsMessage with _$WsMessage {
  const factory WsMessage.connected() = WsConnected;

  const factory WsMessage.disconnected() = WsDisconnected;

  const factory WsMessage.orderUpdate({
    required String orderId,
    required String status,
    required Map<String, dynamic> data,
  }) = WsOrderUpdate;

  const factory WsMessage.positionUpdate({
    required String positionId,
    required Map<String, dynamic> data,
  }) = WsPositionUpdate;

  const factory WsMessage.tokenScore({
    required String symbol,
    required double score,
    required String riskLevel,
  }) = WsTokenScore;

  const factory WsMessage.error(String message) = WsError;

  factory WsMessage.fromJson(Map<String, dynamic> json) =>
      _$WsMessageFromJson(json);
}

/// Parse raw JSON payload from WS into a typed WsMessage.
WsMessage? parseWsPayload(Map<String, dynamic> json) {
  final type = json['type'] as String?;
  final envelope = json['data'] as Map<String, dynamic>? ?? {};
  final data = switch (type) {
    'order_update' =>
      (envelope['order'] as Map<String, dynamic>?) ?? envelope,
    'position_update' =>
      (envelope['position'] as Map<String, dynamic>?) ?? envelope,
    _ => envelope,
  };

  return switch (type) {
    'order_update' => WsMessage.orderUpdate(
        orderId: data['id'] as String? ?? '',
        status: data['status'] as String? ?? '',
        data: data,
      ),
    'position_update' => WsMessage.positionUpdate(
        positionId: data['id'] as String? ?? '',
        data: data,
      ),
    'token_score' => WsMessage.tokenScore(
        symbol: data['symbol'] as String? ?? '',
        score: (data['risk_score'] as num?)?.toDouble() ?? 0,
        riskLevel: data['risk_level'] as String? ?? 'low',
      ),
    _ => null,
  };
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsConnected _$WsConnectedFromJson(Map<String, dynamic> json) => WsConnected(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WsConnectedToJson(WsConnected instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

WsDisconnected _$WsDisconnectedFromJson(Map<String, dynamic> json) =>
    WsDisconnected(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WsDisconnectedToJson(WsDisconnected instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

WsOrderUpdate _$WsOrderUpdateFromJson(Map<String, dynamic> json) =>
    WsOrderUpdate(
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      data: json['data'] as Map<String, dynamic>,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WsOrderUpdateToJson(WsOrderUpdate instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'status': instance.status,
      'data': instance.data,
      'runtimeType': instance.$type,
    };

WsPositionUpdate _$WsPositionUpdateFromJson(Map<String, dynamic> json) =>
    WsPositionUpdate(
      positionId: json['positionId'] as String,
      data: json['data'] as Map<String, dynamic>,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WsPositionUpdateToJson(WsPositionUpdate instance) =>
    <String, dynamic>{
      'positionId': instance.positionId,
      'data': instance.data,
      'runtimeType': instance.$type,
    };

WsTokenScore _$WsTokenScoreFromJson(Map<String, dynamic> json) => WsTokenScore(
      symbol: json['symbol'] as String,
      score: (json['score'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WsTokenScoreToJson(WsTokenScore instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'score': instance.score,
      'riskLevel': instance.riskLevel,
      'runtimeType': instance.$type,
    };

WsError _$WsErrorFromJson(Map<String, dynamic> json) => WsError(
      json['message'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WsErrorToJson(WsError instance) => <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

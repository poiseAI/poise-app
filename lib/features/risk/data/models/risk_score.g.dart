// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'risk_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RiskScore _$RiskScoreFromJson(Map<String, dynamic> json) => _RiskScore(
      symbol: json['symbol'] as String,
      score: (json['risk_score'] as num).toDouble(),
      level: json['risk_level'] as String? ?? 'medium',
      factors: (json['factors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: json['fetched_at'] as String? ?? '',
    );

Map<String, dynamic> _$RiskScoreToJson(_RiskScore instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'risk_score': instance.score,
      'risk_level': instance.level,
      'factors': instance.factors,
      'fetched_at': instance.updatedAt,
    };

_PortfolioRisk _$PortfolioRiskFromJson(Map<String, dynamic> json) =>
    _PortfolioRisk(
      userId: json['user_id'] as String? ?? '',
      positions: (json['positions'] as List<dynamic>?)
              ?.map((e) => RiskScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PortfolioRiskToJson(_PortfolioRisk instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'positions': instance.positions,
    };
